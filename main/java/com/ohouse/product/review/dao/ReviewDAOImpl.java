package com.ohouse.product.review.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.ohouse.product.review.dto.OptionFilterDTO;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.dto.ReviewImageDTO;
import com.ohouse.product.review.dto.ReviewPageDTO;
import com.ohouse.product.review.dto.ReviewSummaryDTO;
import com.ohouse.product.review.dto.SubOptionDTO;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public List<ReviewDTO> selectReviewList2(Connection conn, ReviewPageDTO reqDTO) throws Exception {
        List<ReviewDTO> list = new ArrayList<>();
        
        // 1. 정렬 조건 설정
        String orderBy = "r.REG_DATE DESC, r.REVIEW_ID DESC";
        if ("best".equals(reqDTO.getSort())) {
            orderBy = "r.RATING DESC, r.HELP_COUNT DESC, r.REG_DATE DESC";
        }

        // 2. 동적 IN 절 생성 (별점 및 옵션 필터)
        String ratingInClause = "";
        if (reqDTO.getRatings() != null && !reqDTO.getRatings().isEmpty()) {
            ratingInClause = " AND r.RATING IN (" + 
                reqDTO.getRatings().stream().map(r -> "?").collect(Collectors.joining(",")) + ")";
        }

        String optionInClause = "";
        if (reqDTO.getOptions() != null && !reqDTO.getOptions().isEmpty()) {
            optionInClause = " AND r.PRODUCT_OPTION_ID IN (" + 
                reqDTO.getOptions().stream().map(o -> "?").collect(Collectors.joining(",")) + ")";
        }

        // 3. Text Block 기반 쿼리 작성 (PRODUCT_OPTION_ID IS NOT NULL 포함)
        String sql = """
            SELECT * FROM (
                SELECT ROWNUM rnum, b.* FROM (
                    SELECT r.REVIEW_ID, r.PRODUCT_ID, r.MEMBER_ID, r.PRODUCT_OPTION_ID, r.IS_HIDE_IMAGE
                           NVL(m.NAME, '더미사용자' || r.REVIEW_ID) AS WRITER_NAME,
                           r.RATING, r.CONTENT,
                           TO_CHAR(r.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,
                           TO_CHAR(r.EDIT_DATE, 'YYYY-MM-DD') AS EDIT_DATE,
                           r.HELP_COUNT, r.ADMIN_REPLY, r.IS_PURCHASED,
                           img.IMG_ID, img.IMAGE_URL,
                           opt.OPTION_NAME AS OPTION_NAME
                    FROM REVIEW r
                    LEFT JOIN MEMBER m ON r.MEMBER_ID = m.MEMBER_ID
                    LEFT JOIN REVIEW_IMAGE img ON r.REVIEW_ID = img.REVIEW_ID
                    LEFT JOIN (
                        SELECT pov.PRODUCT_OPTION_ID,
                               LISTAGG(ov.OPTION_NAME, ' / ') WITHIN GROUP (ORDER BY ov.SORT_ORDER, ov.OPTION_VALUE_ID) AS OPTION_NAME
                        FROM PRODUCT_OPTION_VALUE pov
                        JOIN OPTION_VALUE ov ON pov.OPTION_VALUE_ID = ov.OPTION_VALUE_ID
                        GROUP BY pov.PRODUCT_OPTION_ID
                    ) opt ON r.PRODUCT_OPTION_ID = opt.PRODUCT_OPTION_ID
                    WHERE r.PRODUCT_ID = ?
                      AND r.PRODUCT_OPTION_ID IS NOT NULL
                      %s
                      %s
                    ORDER BY %s
                ) b WHERE ROWNUM <= ?
            ) WHERE rnum >= ?
            """.formatted(ratingInClause, optionInClause, orderBy);

        int endRow = reqDTO.getCurrentPage() * reqDTO.getNumberPerPage();
        int startRow = endRow - reqDTO.getNumberPerPage() + 1;

        // 4. PreparedStatement 생성 및 파라미터 바인딩
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIdx = 1;
            
            // [필수] 상품 ID
            pstmt.setInt(paramIdx++, reqDTO.getProductId());

            // [동적] 별점 목록 (Integer)
            if (reqDTO.getRatings() != null && !reqDTO.getRatings().isEmpty()) {
                for (Integer rating : reqDTO.getRatings()) {
                    pstmt.setInt(paramIdx++, rating);
                }
            }

            // [동적] 옵션 ID 목록 (Integer 또는 Long)
            if (reqDTO.getOptions() != null && !reqDTO.getOptions().isEmpty()) {
                for (Integer optionId : reqDTO.getOptions()) {
                    pstmt.setInt(paramIdx++, optionId);
                }
            }

            // [필수] 페이징
            pstmt.setInt(paramIdx++, endRow);
            pstmt.setInt(paramIdx++, startRow);

            // 5. ResultSet 매핑
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewImageDTO imageDTO = null;
                    if (rs.getObject("IMG_ID") != null) {
                        imageDTO = ReviewImageDTO.builder()
                                .imgId(rs.getInt("IMG_ID"))
                                .reviewId(rs.getInt("REVIEW_ID"))
                                .imageUrl(rs.getString("IMAGE_URL"))
                                .build();
                    }

                    Integer memberId = rs.getObject("MEMBER_ID") != null ? rs.getInt("MEMBER_ID") : 0;
                    Integer optionId = rs.getObject("PRODUCT_OPTION_ID") != null ? rs.getInt("PRODUCT_OPTION_ID") : 0;
                    Integer isHideImage = rs.getObject("IS_HIDE_IMAGE") != null ? rs.getInt("IS_HIDE_IMAGE") : 0;
                    
                    ReviewDTO reviewDTO = ReviewDTO.builder()
                            .reviewId(rs.getInt("REVIEW_ID"))
                            .productId(rs.getInt("PRODUCT_ID"))
                            .memberId(memberId)
                            .productOptionId(optionId)
                            .writerName(rs.getString("WRITER_NAME"))
                            .rating(rs.getInt("RATING"))
                            .content(rs.getString("CONTENT"))
                            .regDate(rs.getString("REG_DATE"))
                            .editDate(rs.getString("EDIT_DATE"))
                            .helpCount(rs.getInt("HELP_COUNT"))
                            .adminReply(rs.getString("ADMIN_REPLY"))
                            .isPurchased(rs.getInt("IS_PURCHASED"))
                            .optionName(rs.getString("OPTION_NAME"))
                            .reviewImage(imageDTO)
                            .isHideImage(isHideImage) // 💥 추가
                            .build();

                    list.add(reviewDTO);
                }
            }
        }
        return list;
    }

    @Override
    public List<ReviewDTO> selectReviewList(Connection conn, ReviewPageDTO reqDTO) throws Exception {
        List<ReviewDTO> list = new ArrayList<>();
        
        // 1. 정렬 조건 (HELP_COUNT 1순위)
        String orderBy = "r.REG_DATE DESC, r.REVIEW_ID DESC";
        if ("best".equals(reqDTO.getSort())) {
            orderBy = "HELP_COUNT DESC, r.RATING DESC, r.REG_DATE DESC";
        }

        // 2. 동적 IN 절
        String ratingInClause = "";
        if (reqDTO.getRatings() != null && !reqDTO.getRatings().isEmpty()) {
            ratingInClause = " AND r.RATING IN (" + 
                reqDTO.getRatings().stream().map(r -> "?").collect(Collectors.joining(",")) + ")";
        }

        String optionInClause = "";
        if (reqDTO.getOptions() != null && !reqDTO.getOptions().isEmpty()) {
            optionInClause = " AND r.PRODUCT_OPTION_ID IN (" + 
                reqDTO.getOptions().stream().map(o -> "?").collect(Collectors.joining(",")) + ")";
        }

        // 3. SQL (대표 이미지만 1:1 조인)
        String sql = """
            SELECT * FROM (
                SELECT ROWNUM rnum, b.* FROM (
                    SELECT r.REVIEW_ID, r.PRODUCT_ID, r.MEMBER_ID, r.PRODUCT_OPTION_ID, r.IS_HIDE_IMAGE,
                           NVL(m.NAME, '더미사용자' || r.REVIEW_ID) AS WRITER_NAME,
                           r.RATING, r.CONTENT,
                           TO_CHAR(r.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,
                           TO_CHAR(r.EDIT_DATE, 'YYYY-MM-DD') AS EDIT_DATE,
                           r.ADMIN_REPLY, r.IS_PURCHASED,
                           img.IMG_ID, img.IMAGE_URL,
                           opt.OPTION_NAME AS OPTION_NAME,
                           (SELECT COUNT(*) FROM REVIEW_LIKE rl WHERE rl.REVIEW_ID = r.REVIEW_ID) AS HELP_COUNT,
                           (SELECT COUNT(*) FROM REVIEW_LIKE rl WHERE rl.REVIEW_ID = r.REVIEW_ID AND rl.MEMBER_ID = ?) AS IS_LIKED
                    FROM REVIEW r
                    LEFT JOIN MEMBER m ON r.MEMBER_ID = m.MEMBER_ID
                    LEFT JOIN (
                        SELECT REVIEW_ID, IMG_ID, IMAGE_URL
                        FROM (
                            SELECT REVIEW_ID, IMG_ID, IMAGE_URL,
                                   ROW_NUMBER() OVER (PARTITION BY REVIEW_ID ORDER BY IMG_ID ASC) as rn
                            FROM REVIEW_IMAGE
                        )
                        WHERE rn = 1
                    ) img ON r.REVIEW_ID = img.REVIEW_ID
                    LEFT JOIN (
                        SELECT pov.PRODUCT_OPTION_ID,
                               LISTAGG(ov.OPTION_NAME, ' / ') WITHIN GROUP (ORDER BY ov.SORT_ORDER, ov.OPTION_VALUE_ID) AS OPTION_NAME
                        FROM PRODUCT_OPTION_VALUE pov
                        JOIN OPTION_VALUE ov ON pov.OPTION_VALUE_ID = ov.OPTION_VALUE_ID
                        GROUP BY pov.PRODUCT_OPTION_ID
                    ) opt ON r.PRODUCT_OPTION_ID = opt.PRODUCT_OPTION_ID
                    WHERE r.PRODUCT_ID = ?
                      %s
                      %s
                    ORDER BY %s
                ) b WHERE ROWNUM <= ?
            ) WHERE rnum >= ?
            """.formatted(ratingInClause, optionInClause, orderBy);

        int endRow = reqDTO.getCurrentPage() * reqDTO.getNumberPerPage();
        int startRow = endRow - reqDTO.getNumberPerPage() + 1;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIdx = 1;
            
            // 💥 [수정] 하드코딩 4 제거 -> reqDTO에서 전달된 회원 ID 동적 적용 (IS_LIKED 판단용)
            pstmt.setInt(paramIdx++, reqDTO.getMemberId());

            // [필수] 상품 ID
            pstmt.setInt(paramIdx++, reqDTO.getProductId());

            // [동적] 별점
            if (reqDTO.getRatings() != null && !reqDTO.getRatings().isEmpty()) {
                for (Integer rating : reqDTO.getRatings()) {
                    pstmt.setInt(paramIdx++, rating);
                }
            }

            // [동적] 옵션 ID
            if (reqDTO.getOptions() != null && !reqDTO.getOptions().isEmpty()) {
                for (Integer optionId : reqDTO.getOptions()) {
                    pstmt.setInt(paramIdx++, optionId);
                }
            }

            // [필수] 페이징
            pstmt.setInt(paramIdx++, endRow);
            pstmt.setInt(paramIdx++, startRow);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewImageDTO imageDTO = null;
                    if (rs.getObject("IMG_ID") != null) {
                        imageDTO = ReviewImageDTO.builder()
                                .imgId(rs.getInt("IMG_ID"))
                                .reviewId(rs.getInt("REVIEW_ID"))
                                .imageUrl(rs.getString("IMAGE_URL"))
                                .build();
                    }

                    Integer memberId = rs.getObject("MEMBER_ID") != null ? rs.getInt("MEMBER_ID") : 0;
                    Integer optionId = rs.getObject("PRODUCT_OPTION_ID") != null ? rs.getInt("PRODUCT_OPTION_ID") : 0;

                    Integer isPurchased = rs.getString("IS_PURCHASED") != null ? rs.getInt("IS_PURCHASED") : 0;
                    Integer isHideImage = rs.getObject("IS_HIDE_IMAGE") != null ? rs.getInt("IS_HIDE_IMAGE") : 0;
                    
                    ReviewDTO reviewDTO = ReviewDTO.builder()
                            .reviewId(rs.getInt("REVIEW_ID"))
                            .productId(rs.getInt("PRODUCT_ID"))
                            .memberId(memberId)
                            .productOptionId(optionId)
                            .writerName(rs.getString("WRITER_NAME"))
                            .rating(rs.getInt("RATING"))
                            .content(rs.getString("CONTENT"))
                            .regDate(rs.getString("REG_DATE"))
                            .editDate(rs.getString("EDIT_DATE"))
                            .helpCount(rs.getInt("HELP_COUNT"))
                            .adminReply(rs.getString("ADMIN_REPLY"))
                            .isPurchased(isPurchased)
                            .optionName(rs.getString("OPTION_NAME"))
                            .reviewImage(imageDTO)
                            .liked(rs.getInt("IS_LIKED") > 0)
                            .isHideImage(isHideImage)
                            .build();

                    list.add(reviewDTO);
                }
            }
        }
        return list;
    }
    @Override
    public int getTotalRecords(Connection conn, ReviewPageDTO reqDTO) throws Exception {
        int totalCount = 0;

        // 1. 동적 IN 절 생성 (selectReviewList와 동일 조건)
        String ratingInClause = "";
        if (reqDTO.getRatings() != null && !reqDTO.getRatings().isEmpty()) {
            ratingInClause = " AND r.RATING IN (" + 
                reqDTO.getRatings().stream().map(r -> "?").collect(Collectors.joining(",")) + ")";
        }

        String optionInClause = "";
        if (reqDTO.getOptions() != null && !reqDTO.getOptions().isEmpty()) {
            optionInClause = " AND r.PRODUCT_OPTION_ID IN (" + 
                reqDTO.getOptions().stream().map(o -> "?").collect(Collectors.joining(",")) + ")";
        }

        // 💥 [수정] AND r.PRODUCT_OPTION_ID IS NOT NULL 제거함!
        String sql = """
            SELECT COUNT(*)
            FROM REVIEW r
            WHERE r.PRODUCT_ID = ?
              %s
              %s
            """.formatted(ratingInClause, optionInClause);

        // 3. PreparedStatement 파라미터 바인딩
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIdx = 1;

            pstmt.setInt(paramIdx++, reqDTO.getProductId());

            if (reqDTO.getRatings() != null && !reqDTO.getRatings().isEmpty()) {
                for (Integer rating : reqDTO.getRatings()) {
                    pstmt.setInt(paramIdx++, rating);
                }
            }

            if (reqDTO.getOptions() != null && !reqDTO.getOptions().isEmpty()) {
                for (Integer optionId : reqDTO.getOptions()) {
                    pstmt.setInt(paramIdx++, optionId);
                }
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    totalCount = rs.getInt(1);
                }
            }
        }
        return totalCount;
    }
    @Override
    public ReviewSummaryDTO selectReviewSummary(Connection conn, int productId) throws Exception {
        String sql = "SELECT COUNT(*) as TOTAL_COUNT, " +
                     "       NVL(AVG(RATING), 0) as AVG_RATING, " +
                     "       COUNT(CASE WHEN RATING = 5 THEN 1 END) as COUNT5, " +
                     "       COUNT(CASE WHEN RATING = 4 THEN 1 END) as COUNT4, " +
                     "       COUNT(CASE WHEN RATING = 3 THEN 1 END) as COUNT3, " +
                     "       COUNT(CASE WHEN RATING = 2 THEN 1 END) as COUNT2, " +
                     "       COUNT(CASE WHEN RATING = 1 THEN 1 END) as COUNT1 " +
                     "FROM REVIEW WHERE PRODUCT_ID = ?";

        ReviewSummaryDTO summary = null;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("TOTAL_COUNT");
                    double avg = Math.round(rs.getDouble("AVG_RATING") * 10.0) / 10.0;
                    int c5 = rs.getInt("COUNT5");
                    int c4 = rs.getInt("COUNT4");
                    int c3 = rs.getInt("COUNT3");
                    int c2 = rs.getInt("COUNT2");
                    int c1 = rs.getInt("COUNT1");

                    int r5 = total > 0 ? (int) Math.round((c5 / (double) total) * 100) : 0;
                    int r4 = total > 0 ? (int) Math.round((c4 / (double) total) * 100) : 0;
                    int r3 = total > 0 ? (int) Math.round((c3 / (double) total) * 100) : 0;
                    int r2 = total > 0 ? (int) Math.round((c2 / (double) total) * 100) : 0;
                    int r1 = total > 0 ? (int) Math.round((c1 / (double) total) * 100) : 0;

                    summary = ReviewSummaryDTO.builder()
                            .avgRating(avg)
                            .totalCount(total)
                            .count5(c5).count4(c4).count3(c3).count2(c2).count1(c1)
                            .rate5(r5).rate4(r4).rate3(r3).rate2(r2).rate1(r1)
                            .build();
                }
            }
        }
        return summary;
    }

    // 2단 구조의 리뷰 옵션 필터 드롭다운용 목록 조회 추가
    @Override
    public List<OptionFilterDTO> selectOptionFilterList(Connection conn, int productId) throws Exception {
        String sql = """
            SELECT ov1.OPTION_VALUE_ID AS PARENT_VAL_ID,
                   ov1.OPTION_NAME AS PARENT_VAL_NAME,
                   po.PRODUCT_OPTION_ID,
                   LISTAGG(ov2.OPTION_NAME, ' / ') WITHIN GROUP (ORDER BY og2.SORT_ORDER, ov2.SORT_ORDER) AS SUB_OPTION_NAME
            FROM PRODUCT_OPTION po
            JOIN PRODUCT_OPTION_VALUE pov1 ON po.PRODUCT_OPTION_ID = pov1.PRODUCT_OPTION_ID
            JOIN OPTION_VALUE ov1 ON pov1.OPTION_VALUE_ID = ov1.OPTION_VALUE_ID
            JOIN OPTION_GROUP og1 ON ov1.OPTION_GROUP_ID = og1.OPTION_GROUP_ID AND og1.SORT_ORDER = 1
            
            JOIN PRODUCT_OPTION_VALUE pov2 ON po.PRODUCT_OPTION_ID = pov2.PRODUCT_OPTION_ID
            JOIN OPTION_VALUE ov2 ON pov2.OPTION_VALUE_ID = ov2.OPTION_VALUE_ID
            JOIN OPTION_GROUP og2 ON ov2.OPTION_GROUP_ID = og2.OPTION_GROUP_ID AND og2.SORT_ORDER > 1
            WHERE po.PRODUCT_ID = ?
              AND po.STATUS = 'ACTIVE'
            GROUP BY ov1.OPTION_VALUE_ID, ov1.OPTION_NAME, po.PRODUCT_OPTION_ID
            ORDER BY ov1.OPTION_VALUE_ID, po.PRODUCT_OPTION_ID
            """;

        List<OptionFilterDTO> list = null;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
                Map<Integer, OptionFilterDTO> map = new LinkedHashMap<>();

                while (rs.next()) {
                    int parentValId = rs.getInt("PARENT_VAL_ID");
                    String parentValName = rs.getString("PARENT_VAL_NAME");
                    int productOptionId = rs.getInt("PRODUCT_OPTION_ID");
                    String subOptionName = rs.getString("SUB_OPTION_NAME");

                    OptionFilterDTO parentDTO = map.computeIfAbsent(parentValId, k -> 
                        OptionFilterDTO.builder()
                            .optionValueId(parentValId)
                            .optionValueName(parentValName)
                            .subOptions(new ArrayList<>())
                            .build()
                    );

                    SubOptionDTO subDTO = SubOptionDTO.builder()
                            .productOptionId(productOptionId)
                            .subOptionName(subOptionName)
                            .build();

                    parentDTO.getSubOptions().add(subDTO);
                }

                list = new ArrayList<>(map.values());
            }
        }
        return list;
    }
    //도움돼요 토그
 // 1. 해당 유저가 해당 리뷰에 이미 좋아요를 눌렀는지 확인
    @Override
    public boolean isReviewLiked(Connection conn, int reviewId, int memberId) {
        String sql = "SELECT COUNT(*) FROM REVIEW_LIKE WHERE REVIEW_ID = ? AND MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            pstmt.setInt(2, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. 좋아요 추가 (INSERT)
    @Override
    public int insertReviewLike(Connection conn, int reviewId, int memberId) {
        String sql = "INSERT INTO REVIEW_LIKE (ID, MEMBER_ID, REVIEW_ID) VALUES (SEQ_REVIEW_LIKE.NEXTVAL, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, reviewId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 3. 좋아요 삭제 (DELETE)
    @Override
    public int deleteReviewLike(Connection conn, int reviewId, int memberId) {
        String sql = "DELETE FROM REVIEW_LIKE WHERE REVIEW_ID = ? AND MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            pstmt.setInt(2, memberId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. REVIEW_LIKE 테이블에서 직접 최신 좋아요 수 조회 (REVIEW 테이블의 HELP_COUNT 대체)
    @Override
    public int getHelpCount(Connection conn, int reviewId) {
        String sql = "SELECT COUNT(*) FROM REVIEW_LIKE WHERE REVIEW_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
 // 리뷰 이미지 숨김/해제 상태 업데이트 (관리자용)
    @Override
    public int updateHideImage(Connection conn, int reviewId, int isHideImage) throws Exception {
        PreparedStatement pstmt = null;
        int rowCount = 0;

        String sql = "UPDATE REVIEW SET IS_HIDE_IMAGE = ? WHERE REVIEW_ID = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, isHideImage); // 0 (노출) 또는 1 (숨김)
            pstmt.setInt(2, reviewId);

            rowCount = pstmt.executeUpdate(); // 정상 변경 시 1 반환
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        }

        return rowCount;
    }
    //관리자 답변 관리 
    @Override
    public int updateAdminReply(Connection conn, int reviewId, String adminReply) throws Exception {
        String sql = "UPDATE REVIEW SET ADMIN_REPLY = ? WHERE REVIEW_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (adminReply != null && !adminReply.trim().isEmpty()) {
                pstmt.setString(1, adminReply);
            } else {
                pstmt.setNull(1, java.sql.Types.VARCHAR); // 삭제 시 NULL 처리
            }
            pstmt.setInt(2, reviewId);
            return pstmt.executeUpdate();
        }
    }
    @Override
    public int insertReview(Connection conn, ReviewDTO reviewDTO) throws Exception {
        String sql = "INSERT INTO REVIEW (REVIEW_ID, PRODUCT_ID, MEMBER_ID, RATING, CONTENT, REG_DATE, IS_PURCHASED, IS_HIDE_IMAGE) " +
                     "VALUES (SEQ_REVIEW.NEXTVAL, ?, ?, ?, ?, SYSDATE, 1, 0)";
        
        int generatedReviewId = 0;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[]{"REVIEW_ID"})) {
            pstmt.setInt(1, reviewDTO.getProductId());
            pstmt.setInt(2, reviewDTO.getMemberId());
            pstmt.setInt(3, reviewDTO.getRating());
            pstmt.setString(4, reviewDTO.getContent());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedReviewId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedReviewId;
    }

    @Override
    public int insertReviewImage(Connection conn, int reviewId, String imageUrl) throws Exception {
        String sql = "INSERT INTO REVIEW_IMAGE (IMG_ID, REVIEW_ID, IMAGE_URL) VALUES (SEQ_REVIEW_IMAGE.NEXTVAL, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            pstmt.setString(2, imageUrl);
            
            return pstmt.executeUpdate();
        }
    }
}