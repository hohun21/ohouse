package com.ohouse.seller.service;

import java.util.Map;
import java.util.regex.Pattern;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SellerSignupRequest {

	private String emailId;
	private String emailDomain;
	private String password;
	private String passwordConfirm;
	private String brandName;
	private String representativeName;
	private String businessNumber;
	private String mailOrderNumber;
	private String businessAddrLine1;
	private String businessAddrLine2;
	private String representativeContact;
	private String customerServicePhone;

	private static final Pattern EMAIL_ID_PATTERN =
			Pattern.compile(
					"^(?!\\.)(?!.*\\.\\.)" +
							"[A-Za-z0-9_-]+" +
							"(?:\\.[A-Za-z0-9_-]+)*$"
					);

	public boolean isValidEmailID() {
		return emailId != null
				&& EMAIL_ID_PATTERN.matcher(emailId).matches();
	}

	private static final Pattern PASSWORD_PATTERN =
			Pattern.compile(
					"^(?=.*[A-Za-z])(?=.*[0-9])" + "[\\x21-\\x7E]{8,20}$"
					);

	public boolean isValidPassword() {
		return password != null
				&& PASSWORD_PATTERN.matcher(password).matches();
	}

	public boolean isPasswordEqualToConfirm() {
		return password != null && password.equals(passwordConfirm);
	}

	private static final Pattern MAIL_ORDER_NUMBER_PATTERN =
			Pattern.compile(
					"^\\d{4}-[가-힣A-Za-z0-9]+-[가-힣A-Za-z0-9]+$"
					);

	public boolean isValidMailOrderNumber() {
		return mailOrderNumber != null
				&& MAIL_ORDER_NUMBER_PATTERN
				.matcher(mailOrderNumber.trim())
				.matches();
	}

	/**
	 * 필수 입력값 검사
	 */
	 public void validate( Map<String, Boolean> errors ) {
		 checkEmpty(errors, emailId, "emailId");
		 checkEmpty(errors, emailDomain, "emailDomain");
		 checkEmpty(errors, password, "password");
		 checkEmpty(errors, passwordConfirm, "passwordConfirm");
		 checkEmpty(errors, brandName, "brandName");
		 checkEmpty(errors, representativeName, "representativeName");
		 checkEmpty(errors, businessNumber, "businessNumber");
		 checkEmpty(errors, mailOrderNumber, "mailOrderNumber");
		 checkEmpty(errors, businessAddrLine1, "businessAddrLine1");
		 checkEmpty(errors, businessAddrLine2, "businessAddrLine2");
		 checkEmpty(errors, representativeContact, "representativeContact");
		 checkEmpty(errors, customerServicePhone, "customerServicePhone");

		 if (
				 !errors.containsKey("emailId") &&
				 !errors.containsKey("emailDomain")
				 ) {

			 if (!isValidEmailID()) {
				 errors.put(
						 "invalidEmail",
						 Boolean.TRUE
						 );
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
		 
		 if (!errors.containsKey("mailOrderNumber")
			        && !isValidMailOrderNumber()) {
			    errors.put("invalidMailOrderNumber", Boolean.TRUE);
		 }

	 } //. validate()

	 private void checkEmpty(
			 Map<String, Boolean> errors, 
			 String value,
			 String fieldName) {
		 if (value == null || value.isEmpty())
			 errors.put(fieldName, Boolean.TRUE);
	 } //. checkEmpty

	 public String getEmail() {
		 if (emailId == null || emailDomain == null) {
			 return null;
		 }
		 return emailId + "@" + emailDomain;
	 } //. getEmail

	 public String getBusinessAddress() {
		 if (businessAddrLine1 == null || businessAddrLine2 == null) {
			 return null;
		 }
		 return businessAddrLine1 + ", " + businessAddrLine2;
	 } //. getBusinessAddress


}
