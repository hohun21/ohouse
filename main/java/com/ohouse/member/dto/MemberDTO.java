package com.ohouse.member.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MemberDTO {
    
    private Integer memberId;
    private String id;
    private String password;
    private String name;
    private String rank;
    private String role;
    private Date regDate;


    public MemberDTO(String id, String password, String name) {
        this.id = id;
        this.password = password;
        this.name = name;
    }
    
    public boolean matchPassword(String pwd) {
        return this.password != null && this.password.equals(pwd);
    }

    public void changePassword(String newPwd) {
        this.password = newPwd;
    }
}