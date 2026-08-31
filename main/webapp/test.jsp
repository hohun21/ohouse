<%@page import="com.util.conn.ConnectionProvider"%>
<%@page import="com.util.conn.ConnectionProvider"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>

<%
	  /* Context initContext = new InitialContext();
	  Context envContext  = (Context)initContext.lookup("java:/comp/env");
	  DataSource ds = (DataSource)envContext.lookup("jdbc/myoracle");
	  Connection conn = ds.getConnection(); */
	  
	  Connection conn = ConnectionProvider.getConnection();
	  
  //etc.
%>
  
  > conn : <%= conn %>
  
<%
	conn.close(); // 커넥션 풀에 반환
%>
</html>