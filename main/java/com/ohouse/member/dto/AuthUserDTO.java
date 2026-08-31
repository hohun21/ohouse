package com.ohouse.member.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class AuthUserDTO {

    private Integer memberId;
    private String id;
    private String name;
    private String role;

}