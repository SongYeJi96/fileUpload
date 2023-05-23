<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session 유효성 검사
	* session의 값이 null이 아니면 home.jsp 페이지로 리턴
	*/
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login.jsp</title>
</head>
<body>
	<!-- 메세지 확인 -->
	<div class="msg">
		<%
			String msg = request.getParameter("msg");
			if(msg != null){
		%>
			<%=msg%>
		<%		
			}
		%>
	</div>
	<!-- 로그인 폼 -->
	<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
		<div class="cell-content">
			<div class="sign_in_form">
				<div class=sign_in_id>
					<div class="sign_in_id_label">
						<label for="memberId">Id</label>
					</div>
					<div>
						<input type="text" name="memberId" id="memberId" class="memberId">
					</div>
				</div>
				<div class="sign_in_pw">
					<div class="sign_in_id_label">
						<label for="memberPw">Password</label>
					</div>
					<div>
						<input type="password" name="memberPw" id="memberPw" class="memberPw">
					</div>
				</div>
				<div class="sign_in_btn_div">	
					<button type="submit" class="sign_in_btn">로그인</button>
				</div>
			</div>
		</div>
	</form>
</body>
</html>