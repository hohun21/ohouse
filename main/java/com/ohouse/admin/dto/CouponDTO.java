package com.ohouse.admin.dto;

import java.util.Date;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CouponDTO {
    private Integer couponId;
    private String couponName;
    private String discountType;
    private Integer discountValue;
    private Integer minOrderPrice;
    private Integer maxDiscount;
    private Date startDate;
    private Date endDate;
    private Integer status;
}