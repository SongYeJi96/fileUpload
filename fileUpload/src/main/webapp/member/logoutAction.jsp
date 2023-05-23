<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session.invalidate() : 기존 session을 지우고 갱신(session이 가지고 있는 정보를 모두 삭제)
	* home.jsp 페이지로 이동
	*/
	session.invalidate(); 
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>
