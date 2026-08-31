package com.ohouse.member.service;

import java.util.Map;
import java.util.regex.Pattern;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SignupRequest {

   // 1. emailId, emailDomain 삭제하고 id로 통합
   private String id;
   
   // 2. nickname을 name으로 변경
   private String name;
   
   private String password;
   private String passwordConfirm;
   
   // 3. 아이디 정규식 변경 (JSP와 동일하게 영문, 숫자, 하이픈, 밑줄 4~20자)
   private static final Pattern ID_PATTERN =
        Pattern.compile("^[A-Za-z0-9_-]{4,20}$");
   
   public boolean isValidId() {
       return id != null && ID_PATTERN.matcher(id).matches();
   }
   
   private static final Pattern PASSWORD_PATTERN =
          Pattern.compile("^(?=.*[A-Za-z])(?=.*[0-9])[\\x21-\\x7E]{8,20}$");
   
   public boolean isValidPassword() {
       return password != null && PASSWORD_PATTERN.matcher(password).matches();
   }
   
   public boolean isPasswordEqualToConfirm() {
       return password != null && password.equals(passwordConfirm);
   }
   
   public void validate(Map<String, Boolean> errors) {
      // 4. 검증할 필드 이름도 id, name으로 변경
      checkEmpty(errors, id, "id");
      checkEmpty(errors, name, "name");
      checkEmpty(errors, password, "password");
      checkEmpty(errors, passwordConfirm, "passwordConfirm");

      // 5. 아이디 유효성 검사 로직으로 수정
      if (!errors.containsKey("id")) {
          if (!isValidId()) {
              errors.put("invalidId", Boolean.TRUE);
          }
      }
      
      if (!errors.containsKey("password")) {
         if (!isValidPassword()) {
            errors.put("invalidPassword", Boolean.TRUE);
         }
      }
      if (!errors.containsKey("passwordConfirm")) {
         if (!isPasswordEqualToConfirm()) {
            errors.put("notMatch", Boolean.TRUE);
         }
      }
   }

   private void checkEmpty(
         Map<String, Boolean> errors, 
         String value,
         String fieldName) {
      if (value == null || value.trim().isEmpty())
         errors.put(fieldName, Boolean.TRUE);
   }
   
}