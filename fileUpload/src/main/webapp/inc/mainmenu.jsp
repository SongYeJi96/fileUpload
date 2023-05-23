<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<div>
			<i class='fas fa-home homeI' onclick="location.href='<%=request.getContextPath()%>/home.jsp'"></i>
		</div>
		<!-- 
			로그인전 : 회원가입 
			로그인후 : 회원정보 / 로그아웃 (로그인 정보 : session loginMemberId)
		-->
		
		<%
			if(session.getAttribute("loginMemberId") == null){ // 로그인전
		%>
				<div>
					<ul class="list-group list-group-horizontal">
						<li class="list-group-item sign_in" onclick="location.href='<%=request.getContextPath()%>/member/login.jsp'">로그인</li>
						<li class="list-group-item sign_up" onclick="location.href='<%=request.getContextPath()%>/member/insertMemberForm.jsp'">회원가입</li>
					</ul>
				</div>
				
		<%	
			} else{ // 사용자 로그인 후
					String memberId = (String)(session.getAttribute("loginMemberId"));
		%>
					<div class="dropdown">
					    <button type="button" class="btn dropdown user" data-bs-toggle="dropdown"><i class='fas fa-user-circle iheader'></i></button>
					    <ul class="dropdown-menu">
					      <li class="dropdown-header"><%=memberId%>님</li>
					      <li class="dropdown-item" onclick="location.href='<%=request.getContextPath()%>/member/memberInformation.jsp'">회원정보</li>
					      <li class="dropdown-item" onclick="location.href='<%=request.getContextPath()%>/member/logoutAction.jsp'">로그아웃</li>
					    </ul>
					</div> 
		<%	
			}
		%>	