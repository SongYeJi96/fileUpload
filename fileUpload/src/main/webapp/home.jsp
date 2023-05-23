<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	// 현재 로그인 사용자의 Id
	String loginMemberId = null;
	if(session.getAttribute("loginMemberId") != null){
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}

	// DB설정
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root"; 
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbpw);
	System.out.println("home.jsp db접속 성공");
	
	/* 테이블 board, board_file INNER JOIN
	SELECT b.board_no boardNo, b.board_title boardTitle, 
	f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, f.path 
	FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC
	*/
	
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, b.member_id memberId, f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, f.path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("boardNo", rs.getInt("boardNo"));
		m.put("boardTitle", rs.getString("boardTitle"));
		m.put("memberId", rs.getString("memberId"));
		m.put("boardFileNo", rs.getString("boardFileNo"));
		m.put("originFilename", rs.getString("originFilename"));
		m.put("saveFilename", rs.getString("saveFilename"));
		m.put("path", rs.getString("path"));
		list.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
</head>
<body>
	<!-- 메인메뉴 -->
	<div class="cell-header">
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<!-- boardList 출력 -->
	<h1>자료실</h1>
	<table>
		<tr>
			<td>boardTitle</td>
			<td>originFilename</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><%=(String) m.get("boardTitle")%></td>
					<td>
						<a href="<%=request.getContextPath()%>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("saveFilename")%>">
                     		<%=(String)m.get("originFilename")%>
                 		</a>
					</td>
					<!-- session 유무 and 파일 등록한 memberId의 따른 수정, 삭제  -->
					<%
						if(loginMemberId !=null && loginMemberId.equals(m.get("memberId"))){
					%>
						<td><a href="<%=request.getContextPath()%>/board/modifyBoard.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">수정</a></td>
						<td><a href="<%=request.getContextPath()%>/board/removeAction.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">삭제</a></td>
					<%		
						}
					%>
					
				</tr>
		<%		
			}
		%>
	</table>
	
	<!-- session 유무에 따른 자료 등록 -->
	<%
		if(loginMemberId != null){
	%>
		<div class="addBoard">
			<a href="<%=request.getContextPath()%>/board/addBoard.jsp" class="btn">자료 등록</a>
		</div>
	<%
		}
	%>
</body>
</html>