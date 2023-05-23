<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
<%
	/* session 유효성 검사
	* session의 값이 null이 아니면 home.jsp 페이지로 리턴
	*/
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	/* 요청값 유효성 검사(memberId, memberPw)
	* 요청값이 null, ""이 들어왔을 때 login.jsp에 보여주는 메세지 분기
	* 위에 조건에 해당하면 login.jsp 페이지로 리턴. 메시지 전달
	*/
	String msg = null;
	if(request.getParameter("memberId") == null
		|| request.getParameter("memberId").equals("")){
			msg ="Id가 입력되지 않았습니다.";
	} else if(request.getParameter("memberPw") == null
		|| request.getParameter("memberPw").equals("")){
			msg ="Password가 입력되지 않았습니다.";
	}
	
	if(msg != null) {
		String rmsg =  URLEncoder.encode(msg,"utf-8");
		response.sendRedirect(request.getContextPath()+"/member/login.jsp?msg="+rmsg);
		return;
	}
	
	// 값 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 디버깅 코드
	System.out.println(memberId + "<-- loginAction.jsp memberId");
	System.out.println(memberPw + "<-- loginAction.jsp memberPw");
	
	// request.getParameter로 받은 값 Member 객체 만들어 저장
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	// DB 설정
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root"; 
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbpw);
	System.out.println("loginAction.jsp db접속 성공");
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql); //(?,1-2)
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	System.out.println(stmt + "<-- loginAction.jsp stmt");
	rs = stmt.executeQuery();
	
	/* redirection 조회 결과에 따른 페이지 이동
	* rs.next()로 조회 값이 있으면 로그인 성공. session에 로그인 정보 저장 후 home.jsp 페이지로 이동
	* 조회 값이 없으면 로그인 실패. login.jsp 페이지로 이동, 메세지 전달
	*/
	if(rs.next()){
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("로그인 성공 세션 정보 :" +session.getAttribute("loginMemberId"));
	} else{
		msg = URLEncoder.encode("ID, Password가 일치하지 않습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/login.jsp?msg="+msg);
		System.out.println("로그인 실패");
	}
%>