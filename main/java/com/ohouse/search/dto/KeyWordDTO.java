package com.ohouse.search.dto;

import java.util.Date;
import lombok.Builder;
import lombok.Data;


@Data
@Builder
public class KeyWordDTO {
	private Integer keywordId;
	private String keyword;
	private Integer searchCount;
	private Integer currentRank;
	private Integer previousRank;
	private Date regDate;
	private Integer isNew;
}
