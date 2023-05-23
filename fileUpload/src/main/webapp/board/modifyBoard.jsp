<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	/* session값 유효성 검사
	* session 값이 null이면 home.jsp 페이지로 리턴
	*/
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}

	/* 요청값(boardNo, boardFileNo) 유효성 검사
	* null or ""이면 home.jsp 페이지로 리턴
	*/
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardFileNo") == null
		|| request.getParameter("boardNo").equals("")
		|| request.getParameter("boardFileNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 값 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	// 디버깅 코드
	System.out.println(boardNo + "<-- moldifyBoard.jsp boardNo");
	System.out.println(boardFileNo + "<-- moldifyBoard.jsp boardFileNo");

	// DB설정
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root"; 
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbpw);
	System.out.println("modifyboard.jsp db접속 성공");
	
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename" 
					+" "+"FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no=? AND f.board_file_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql); //(?, 1-2)
	stmt.setInt(1, boardNo);
	stmt.setInt(2, boardFileNo);
	System.out.println(stmt + "<-- modifyBoard.jsp stmt");
	ResultSet rs = stmt.executeQuery();
	
	HashMap<String, Object> map = null;
	if(rs.next()){
		map = new HashMap<>();
		map.put("boardNo", rs.getInt("boardNo"));
		map.put("boardTitle", rs.getString("boardTitle"));
		map.put("boardFileNo", rs.getInt("boardFileNo"));
		map.put("originFilename", rs.getString("originFilename"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyBoard.jsp</title>
<style>
	table, tr, td{
		border: 1px solid #000000;
	}
</style>
</head>
<body>
	<h1>board & boardFile 수정</h1>
	<form enctype="multipart/form-data" method="post" action="<%=request.getContextPath()%>/board/modifyBoardAction.jsp">
		<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
		<input type="hidden" name="boardFileNo" value="<%=map.get("boardFileNo")%>">
		
		<table>
			<tr>
				<th>boardTitle</th>
				<td>
					<textarea rows="3" cols="50" name="boardTitle" required="required"><%=map.get("boardTitle")%></textarea>
				</td>
			</tr>
			<tr>
				<th>boardFile(수정전 파일 : <%=map.get("originFilename")%>)</th>
				<td>
					<input type="file" name="boardFile">
				</td>
			</tr>
		</table>
		<button type="submit">수정</button>
	</form>
</body>
</html>