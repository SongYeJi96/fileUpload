<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File"%>
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
	System.out.println(boardNo + "<-- removeAction.jsp boardNo");
	System.out.println(boardFileNo + "<-- removeAction.jsp boardFileNo");
	
	
	// DB설정
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root"; 
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbpw);
	System.out.println("removeAction.jsp db접속 성공");
	
	// 파일 삭제
	String saveFilenameSql = "SELECT save_filename FROM board_file WHERE board_file_no=?";
	PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
	saveFilenameStmt.setInt(1, boardFileNo);
	System.out.println(saveFilenameStmt + "<-- removeAction.jsp saveFilenameStmt");
	ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
	
	String removeSaveFilename = ""; // 삭제할 파일명
	if(saveFilenameRs.next()) {
		removeSaveFilename = saveFilenameRs.getString("save_filename");
	}
	String dir = request.getServletContext().getRealPath("/upload");
	File f = new File(dir+"/"+removeSaveFilename);
	if(f.exists()) {
		f.delete();
		System.out.println("removeAction.jsp 파일삭제");
	}
	
	// DB board 데이터 삭제
	String removeBoardSql = "DELETE FROM board where board_no = ?";
	PreparedStatement removeBoardStmt = conn.prepareStatement(removeBoardSql); //(?, 1)
	removeBoardStmt.setInt(1, boardNo);
	System.out.println(removeBoardStmt + "<-- removeAction.jsp removeBoardStmt");
	
	/* removeBoardStmt.executeUpdate()후 값을 변수 row에 저장
	* redirection delete 성공, 실패 상관없이 home.jsp 페이지로 이동.
	*/
	int row = removeBoardStmt.executeUpdate();
	System.out.println(row + "<-- removeAction.jsp row");
	if(row == 0){
		System.out.println(row +"<-- removeAction.jsp 삭제 실패");
	}else if(row == 1){
		System.out.println(row +"<-- removeAction.jsp 삭제 성공");
	}else {
		System.out.println("removeAction.jsp error row값 : "+row);
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>