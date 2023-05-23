<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session값 유효성 검사
	* session 값이 null 이면 home.jsp 페이지로 이동
	*/
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 값 저장(memberId)
	String memberId = (String)(session.getAttribute("loginMemberId"));
	System.out.println(memberId +"<--addBoard.jsp memberId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addBoard + file</title>
<style type="text/css">
	table, th, td {
		border : 1px solid #FF0000;
	}
</style>
</head>
<body>
	<!-- 자료 등록시 form
	* method = "post"
	* enctype = "multipart/form-data"
	 -->
	<h1>자료 등록</h1>
	<form action="<%=request.getContextPath()%>/board/addBoardAction.jsp" method="post" enctype="multipart/form-data">
		<table>
		<!-- 자료 등록 제목글 -->
			<tr>
				<th>Title</th>
				<td>
					<textarea rows="3" cols="50" name="boardTitle" required="required"></textarea>
				</td>
			</tr>
			
			<!-- 로그인 사용자 Id -->
			<tr>
				<th>memberId</th>
				<td>
					<input type="text" name="memberId" value="<%=memberId%>">
				</td>
			</tr>
			
			<!-- 자료 등록 -->
			<tr>
				<th>boardFile</th>
				<td>
					<input type="file" name="boardFile" multiple="multiple" required="required">
				</td>
			</tr>
			
		</table>
		<button type="submit">자료 등록</button>
	</form>
</body>
</html>