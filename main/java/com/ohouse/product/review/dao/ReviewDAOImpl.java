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
                        SELECT PRODUCT_OPTION_ID,
                               LISTAGG(OPTION_NAME, ' / ') WITHIN GROUP (ORDER BY OPTION_NAME) AS OPTION_NAME
                        FROM (
                            SELECT DISTINCT pov.PRODUCT_OPTION_ID, ov.OPTION_NAME
                            FROM PRODUCT_OPTION_VALUE pov
                            JOIN OPTION_VALUE ov ON pov.OPTION_VALUE_ID = ov.OPTION_VALUE_ID
                        )
                        GROUP BY PRODUCT_OPTION_ID
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
            pstmt.setInt(paramIdx++, reqDTO.getMember_id());

            // [필수] 상품 ID
            pstmt.setLong(paramIdx++, reqDTO.getProduct_id());

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

            pstmt.setLong(paramIdx++, reqDTO.getProduct_id());

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
    public ReviewSummaryDTO selectReviewSummary(Connection conn, long productId) throws Exception {
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
            pstmt.setLong(1, productId);
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
    public List<OptionFilterDTO> selectOptionFilterList(Connection conn, long productId) throws Exception {
        // 1. 해당 상품의 옵션 그룹 개수 확인 (단일 옵션 vs 복수 옵션 판별)
    	// [변경 후] 필수 옵션 그룹(또는 본품 옵션)만 카운트하도록 제한
    	String countSql = "SELECT COUNT(*) FROM OPTION_GROUP WHERE PRODUCT_ID = ? AND REQUIRED = 1";
        int groupCount = 0;
        try (PreparedStatement pstmt = conn.prepareStatement(countSql)) {
            pstmt.setLong(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    groupCount = rs.getInt(1);
                }
            }
        }

        List<OptionFilterDTO> list = new ArrayList<>();
        Map<Integer, OptionFilterDTO> map = new LinkedHashMap<>();

        String sql = "";
        if (groupCount <= 1) {
            // [단일 옵션 상품] 옵션 그룹 자체를 부모(그룹명)로, 하위 옵션 값들을 자식(SubOption)으로 조회
            sql = """
                SELECT 
                    og.OPTION_GROUP_ID AS PARENT_VAL_ID,
                    og.GROUP_NAME AS PARENT_VAL_NAME,
                    po.PRODUCT_OPTION_ID,
                    ov.OPTION_NAME AS SUB_OPTION_NAME
                FROM OPTION_GROUP og
                JOIN OPTION_VALUE ov ON og.OPTION_GROUP_ID = ov.OPTION_GROUP_ID
                JOIN PRODUCT_OPTION_VALUE pov ON ov.OPTION_VALUE_ID = pov.OPTION_VALUE_ID
                JOIN PRODUCT_OPTION po ON pov.PRODUCT_OPTION_ID = po.PRODUCT_OPTION_ID
                WHERE og.PRODUCT_ID = ?
                  AND po.STATUS = 'ACTIVE'
                ORDER BY ov.SORT_ORDER, po.PRODUCT_OPTION_ID
                """;
        } else {
            // [복수 옵션 상품] DISTINCT를 추가하여 동일한 이름의 2차 옵션이 중복 노출되는 것 방지
        	sql = """
                    SELECT DISTINCT
                        ov1.OPTION_VALUE_ID AS PARENT_VAL_ID,
                        ov1.OPTION_NAME AS PARENT_VAL_NAME,
                        po.PRODUCT_OPTION_ID,
                        ov2.OPTION_NAME AS SUB_OPTION_NAME,
                        og1.SORT_ORDER AS P_SORT,
                        og2.SORT_ORDER AS S_SORT
                    FROM PRODUCT_OPTION po
                    JOIN PRODUCT_OPTION_VALUE pov1 ON po.PRODUCT_OPTION_ID = pov1.PRODUCT_OPTION_ID
                    JOIN OPTION_VALUE ov1 ON pov1.OPTION_VALUE_ID = ov1.OPTION_VALUE_ID
                    JOIN OPTION_GROUP og1 ON ov1.OPTION_GROUP_ID = og1.OPTION_GROUP_ID AND og1.SORT_ORDER = 1
                    JOIN PRODUCT_OPTION_VALUE pov2 ON po.PRODUCT_OPTION_ID = pov2.PRODUCT_OPTION_ID AND pov2.OPTION_VALUE_ID != ov1.OPTION_VALUE_ID
                    JOIN OPTION_VALUE ov2 ON pov2.OPTION_VALUE_ID = ov2.OPTION_VALUE_ID
                    JOIN OPTION_GROUP og2 ON ov2.OPTION_GROUP_ID = og2.OPTION_GROUP_ID AND og2.SORT_ORDER > 1
                    WHERE po.PRODUCT_ID = ?
                      AND po.STATUS = 'ACTIVE'
                    ORDER BY og1.SORT_ORDER, og2.SORT_ORDER, po.PRODUCT_OPTION_ID
                    """;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
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

                 // 기존: productOptionId만 체크하던 것을 subOptionName 중복까지 함께 체크
                    boolean exists = parentDTO.getSubOptions().stream()
                            .anyMatch(sub -> sub.getSubOptionName().equals(subOptionName));

                    if (!exists) {
                        SubOptionDTO subDTO = SubOptionDTO.builder()
                                .productOptionId(productOptionId)
                                .subOptionName(subOptionName)
                                .build();

                        parentDTO.getSubOptions().add(subDTO);
                    }
                }
                list = new ArrayList<>(map.values());
            }
        }
        System.out.println(">>> 상품 ID: " + productId + " 의 옵션 그룹 개수(groupCount): " + groupCount);
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
    public int insertReview2(Connection conn, ReviewDTO reviewDTO) throws Exception {
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
    public int insertReview(Connection conn, ReviewDTO reviewDTO) throws Exception {
        // 1. 해당 상품을 주문한 이력 중 가장 최근의 PRODUCT_OPTION_ID 조회 및 구매 여부 판정
        String findLatestSql = """
            SELECT PRODUCT_OPTION_ID 
            FROM (
                SELECT od.PRODUCT_OPTION_ID
                FROM ORDERS o
                JOIN ORDERS_DETAIL od ON o.ORDER_ID = od.ORDER_ID
                JOIN PRODUCT_OPTION po ON od.PRODUCT_OPTION_ID = po.PRODUCT_OPTION_ID
                WHERE o.MEMBER_ID = ? 
                  AND po.PRODUCT_ID = ?
                ORDER BY o.ORDER_DATE DESC
            )
            WHERE ROWNUM = 1
            """;
        
        Integer resolvedOptionId = null;
        boolean isPurchased = false;
        
        try (PreparedStatement pstmt = conn.prepareStatement(findLatestSql)) {
            pstmt.setInt(1, reviewDTO.getMemberId());
            pstmt.setLong(2, reviewDTO.getProductId());
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    resolvedOptionId = rs.getInt("PRODUCT_OPTION_ID");
                    isPurchased = true; // 주문 내역이 있으므로 구매자 확정
                }
            }
        }
        
        // 사용자가 폼에서 직접 선택한 옵션 ID가 있다면 우선 적용, 없으면 최신 주문 옵션 ID 사용
        Integer finalOptionId = (reviewDTO.getProductOptionId() != null && reviewDTO.getProductOptionId() > 0) 
                                ? reviewDTO.getProductOptionId() 
                                : resolvedOptionId;

        // 2. INSERT 쿼리 실행
        String sql = """
            INSERT INTO REVIEW (
                REVIEW_ID, PRODUCT_ID, MEMBER_ID, PRODUCT_OPTION_ID, 
                RATING, CONTENT, REG_DATE, IS_PURCHASED, IS_HIDE_IMAGE
            )
            VALUES (
                SEQ_REVIEW.NEXTVAL, ?, ?, ?, 
                ?, ?, SYSDATE, ?, 0
            )
            """;
        
        int generatedReviewId = 0;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[]{"REVIEW_ID"})) {
            int paramIdx = 1;
            
            pstmt.setInt(paramIdx++, reviewDTO.getProductId());
            pstmt.setInt(paramIdx++, reviewDTO.getMemberId());
            
            // 옵션 ID 처리 (최신 주문에서 가져왔거나 선택된 값, 없으면 NULL)
            if (finalOptionId != null && finalOptionId > 0) {
                pstmt.setInt(paramIdx++, finalOptionId);
            } else {
                pstmt.setNull(paramIdx++, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(paramIdx++, reviewDTO.getRating());
            pstmt.setString(paramIdx++, reviewDTO.getContent());
            
            // 동적으로 판정된 IS_PURCHASED 값 바인딩 (1 또는 0)
            pstmt.setInt(paramIdx++, isPurchased ? 1 : 0);
            
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
    
    @Override
    public int updateReview(Connection conn, ReviewDTO reviewDTO) throws Exception {
        String sql = "UPDATE REVIEW SET RATING = ?, CONTENT = ?, EDIT_DATE = SYSDATE WHERE REVIEW_ID = ? AND MEMBER_ID = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewDTO.getRating());
            pstmt.setString(2, reviewDTO.getContent());
            pstmt.setInt(3, reviewDTO.getReviewId());
            pstmt.setInt(4, reviewDTO.getMemberId());
            
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int updateReviewImage(Connection conn, int reviewId, String imageUrl) throws Exception {
        // 1. 먼저 해당 리뷰의 이미지가 이미 존재하는지 업데이트 시도
        String updateSql = "UPDATE REVIEW_IMAGE SET IMAGE_URL = ? WHERE REVIEW_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
            pstmt.setString(1, imageUrl);
            pstmt.setInt(2, reviewId);
            int affectedRows = pstmt.executeUpdate();
            
            // 2. 만약 기존 이미지 행이 없어서 업데이트된 게 없다면 새로 INSERT
            if (affectedRows == 0) {
                String insertSql = "INSERT INTO REVIEW_IMAGE (IMG_ID, REVIEW_ID, IMAGE_URL) VALUES (SEQ_REVIEW_IMAGE.NEXTVAL, ?, ?)";
                try (PreparedStatement insertPstmt = conn.prepareStatement(insertSql)) {
                    insertPstmt.setInt(1, reviewId);
                    insertPstmt.setString(2, imageUrl);
                    return insertPstmt.executeUpdate();
                }
            }
            return affectedRows;
        }
    }
    
    @Override
    public int deleteReviewLikes(Connection conn, int reviewId) throws Exception {
        String sql = "DELETE FROM review_like WHERE review_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int deleteReviewImages(Connection conn, int reviewId) throws Exception {
        String sql = "DELETE FROM review_image WHERE review_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int deleteReview(Connection conn, int reviewId) throws Exception {
        String sql = "DELETE FROM review WHERE review_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            return pstmt.executeUpdate();
        }
    }
    
    
    @Override
    public int selectMyReviewTotalCount(Connection conn, int memberId) throws Exception {
        int totalCount = 0;
        String sql = "SELECT COUNT(*) FROM REVIEW WHERE MEMBER_ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    totalCount = rs.getInt(1);
                }
            }
        }
        return totalCount;
    }

    @Override
    public List<ReviewDTO> selectMyReviewList(Connection conn, ReviewPageDTO reqDTO) throws Exception {
        List<ReviewDTO> list = new ArrayList<>();

        // 정렬 조건 설정 (기본값: 최신순)
        String orderBy = "r.REG_DATE DESC, r.REVIEW_ID DESC";
        if ("best".equals(reqDTO.getSort())) {
            orderBy = "HELP_COUNT DESC, r.RATING DESC, r.REG_DATE DESC";
        }

        // ROWNUM 페이징 범위 계산
        int endRow = reqDTO.getCurrentPage() * reqDTO.getNumberPerPage();
        int startRow = endRow - reqDTO.getNumberPerPage() + 1;

        String sql = """
            SELECT * FROM (
                SELECT ROWNUM rnum, b.* FROM (
                    SELECT r.REVIEW_ID, r.PRODUCT_ID, r.MEMBER_ID, r.PRODUCT_OPTION_ID, r.IS_HIDE_IMAGE,
                           p.PRODUCT_NAME,
                           NVL(m.NAME, '탈퇴한 사용자') AS WRITER_NAME,
                           r.RATING, r.CONTENT,
                           TO_CHAR(r.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,
                           TO_CHAR(r.EDIT_DATE, 'YYYY-MM-DD') AS EDIT_DATE,
                           r.ADMIN_REPLY, r.IS_PURCHASED,
                           img.IMG_ID, img.IMAGE_URL,
                           opt.OPTION_NAME AS OPTION_NAME,
                           (SELECT COUNT(*) FROM REVIEW_LIKE rl WHERE rl.REVIEW_ID = r.REVIEW_ID) AS HELP_COUNT
                    FROM REVIEW r
                    JOIN PRODUCT p ON r.PRODUCT_ID = p.PRODUCT_ID
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
                        SELECT PRODUCT_OPTION_ID,
                               LISTAGG(OPTION_NAME, ' / ') WITHIN GROUP (ORDER BY OPTION_NAME) AS OPTION_NAME
                        FROM (
                            SELECT DISTINCT pov.PRODUCT_OPTION_ID, ov.OPTION_NAME
                            FROM PRODUCT_OPTION_VALUE pov
                            JOIN OPTION_VALUE ov ON pov.OPTION_VALUE_ID = ov.OPTION_VALUE_ID
                        )
                        GROUP BY PRODUCT_OPTION_ID
                    ) opt ON r.PRODUCT_OPTION_ID = opt.PRODUCT_OPTION_ID
                    WHERE r.MEMBER_ID = ?
                    ORDER BY %s
                ) b WHERE ROWNUM <= ?
            ) WHERE rnum >= ?
            """.formatted(orderBy);

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIdx = 1;
            pstmt.setInt(paramIdx++, reqDTO.getMember_id());
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

                    ReviewDTO reviewDTO = ReviewDTO.builder()
                            .reviewId(rs.getInt("REVIEW_ID"))
                            .productId(rs.getInt("PRODUCT_ID"))
                            .memberId(rs.getInt("MEMBER_ID"))
                            .productOptionId(rs.getObject("PRODUCT_OPTION_ID") != null ? rs.getInt("PRODUCT_OPTION_ID") : null)
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
                            .productName(rs.getString("PRODUCT_NAME"))
                            .isHideImage(rs.getObject("IS_HIDE_IMAGE") != null ? rs.getInt("IS_HIDE_IMAGE") : 0)
                            .build();

                    // ReviewDTO에 productName 필드가 있다면 아래처럼 추가해 주세요
                    // reviewDTO.setProductName(rs.getString("PRODUCT_NAME"));

                    list.add(reviewDTO);
                }
            }
        }
        return list;
    }
    
    @Override
    public boolean hasUserPurchased(Connection conn, int memberId, long productId) throws Exception {
        String sql = """
            SELECT COUNT(*) 
            FROM ORDERS o
            JOIN ORDERS_DETAIL od ON o.ORDER_ID = od.ORDER_ID
            JOIN PRODUCT_OPTION po ON od.PRODUCT_OPTION_ID = po.PRODUCT_OPTION_ID
            WHERE o.MEMBER_ID = ? 
              AND po.PRODUCT_ID = ?
            """;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            pstmt.setLong(2, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // 결과가 1건 이상이면 true (구매자)
                }
            }
        }
        return false;
    }
    
    public ReviewDTO findLatestOrderInfo(Connection conn, int memberId, long productId) throws Exception {
        String sql = """
            SELECT PRODUCT_OPTION_ID, ORDER_DATE
            FROM (
                SELECT od.PRODUCT_OPTION_ID, o.ORDER_DATE
                FROM ORDERS o
                JOIN ORDERS_DETAIL od ON o.ORDER_ID = od.ORDER_ID
                JOIN PRODUCT_OPTION po ON od.PRODUCT_OPTION_ID = po.PRODUCT_OPTION_ID
                WHERE o.MEMBER_ID = ? 
                  AND po.PRODUCT_ID = ?
                ORDER BY o.ORDER_DATE DESC
            )
            WHERE ROWNUM = 1
            """;

        // 기본값 설정 (주문 이력이 없으면 productOptionId와 orderDate는 null/0 처리)
        ReviewDTO orderInfo = ReviewDTO.builder()
                .memberId(memberId)
                .productId((int) productId)
                .productOptionId(null)
                .isPurchased(0)
                .orderDate(null)
                .build();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            pstmt.setLong(2, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    orderInfo.setProductOptionId(rs.getInt("PRODUCT_OPTION_ID"));
                    orderInfo.setIsPurchased(1);
                    
                    // 주문 날짜 가져오기 (null 안전 처리)
                    java.sql.Date dbDate = rs.getDate("ORDER_DATE");
                    if (dbDate != null) {
                        orderInfo.setOrderDate(dbDate.toLocalDate().toString());
                    }
                }
            }
        }
        return orderInfo;
    }
    
    @Override
    public boolean hasUserReviewedProduct(Connection conn, long memberId, long productId) throws Exception {
        String sql = """
            SELECT CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM REVIEW 
                            WHERE MEMBER_ID = ? AND PRODUCT_ID = ?
                        ) THEN 1 
                        ELSE 0 
                    END AS HAS_REVIEWED
            FROM DUAL
            """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, memberId);
            pstmt.setLong(2, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("HAS_REVIEWED") == 1;
                }
            }
        }
        return false;
    }
}