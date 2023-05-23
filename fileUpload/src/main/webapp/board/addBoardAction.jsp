<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%
	/* session값 유효성 검사
	* session 값이 null 이면 boardList.jsp 페이지로 이동
	*/
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}

	/* MultipartRequest의 API를 사용하여 스트림내에서 문자값을 반환 받을 수 있다
	* request 객체를 MultipartRequest의 API를 사용할 수 있도록 랩핑
	* new MultipartRequest(원본request, 업로드폴더, 최대파일사이즈byte, 인코딩, 중복이름정책)
	* dir : 프로젝트안 upload폴더의 실제 물리적 위치를 반환
	* max : 최대 파일사이즈byte --> 계산된 값을 적는게 아닌 식으로 표기
	* new DefaultFileRenamePolicy() : 업로드 폴더내 동일한 이름이 있으면 뒤에 숫자를 추가
	*/ 
	
	String dir = request.getServletContext().getRealPath("/upload");
	int max = 10 * 1024 * 1024;
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	/* mRequest로 받은 업로드 파일(boardFile)의 ContentType 확인
	* image 파일이 아니면 파일 삭제 후 addBoard.jsp 페이지로 리턴
	*/
	 if(mRequest.getContentType("boardFile").equals("image/png") == false){
		
		System.out.println("img파일이 아닙니다");
		// 이미 저장된 파일을 삭제
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new File(dir+"/"+saveFilename); // new File(파일명.*) \대신 / 사용해도 된다
		if(f.exists()){
			f.delete();
			System.out.println(saveFilename+"파일삭제");
		}
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp");
		return;
	}
	
	// input type = "text" 값 반환 API --> board 테이블 저장
	String boardTitle = mRequest.getParameter("boardTitle");
	String memberId = mRequest.getParameter("memberId");
	// 디버깅 코드
	System.out.println(boardTitle +"<--addBoardAction.jsp boardTitle");
	System.out.println(memberId +"<--addBoardAction.jsp memberId");
	
	Board board = new Board();
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	// input type = "file" 값(파일 메타 정보) 반환 API(원본파일이름, 저장된파일이름, 컨텐츠타입) --> board_file 테이블 저장
	// API <-- 파일(바이너리)은 이미 MultipartRequest(request랩핑 시) 저장되어 있다
	String type = mRequest.getContentType("boardFile");
	String originFilename = mRequest.getOriginalFileName("boardFile");
	String saveFilename = mRequest.getFilesystemName("boardFile");
	// 디버깅 코드
	System.out.println(type +"<--addBoardAction.jsp type");
	System.out.println(originFilename +"<--addBoardAction.jsp originFilename");
	System.out.println(saveFilename +"<--addBoardAction.jsp saveFilename");
	
	BoardFile boardFile = new BoardFile();
	boardFile.setType(type);
	boardFile.setOriginFilename(originFilename);
	boardFile.setSaveFilename(saveFilename);
	
	// DB 설정
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root"; 
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbpw);
	System.out.println("addBoardAction.jsp db접속 성공");
	
	/* board table insert 쿼리
	* INSERT INTO board(board_title, member_id, updatedate, createdate) VALUES(?, ?, NOW(), NOW()) 
	
	* board_file insert 쿼리
	* INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?, ?, ?, ?, '/upload', NOW())
	*/
	
	// 생성된 Primary키값(board_no)을 받아 업로드 하는 파일의 board_no의 저장된 키값 반환(PreparedStatement.RETURN_GENERATED_KEYS)
	String boardSql = "INSERT INTO board(board_title, member_id, updatedate, createdate) VALUES(?, ?, NOW(), NOW())";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql, PreparedStatement.RETURN_GENERATED_KEYS);
	boardStmt.setString(1,boardTitle);
	boardStmt.setString(2,memberId);
	System.out.println(boardStmt +"<--addBoardAction.jsp boardStmt");
	
	boardStmt.executeUpdate(); // board 입력 후 키값 저장
	ResultSet keyRs = boardStmt.getGeneratedKeys(); // boardStmt.getGeneratedKeys() : 방금 생성된 Primary키값을 받는다, 저장된 키값 반환
	System.out.println(keyRs +"<-- addBoardAction.jsp KeyRs");
	
	int boardNo = 0;
	if(keyRs.next()){
		boardNo = keyRs.getInt(1);
	}
	
	String fileSql = "INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?, ?, ?, ?, 'upload', NOW())";
	PreparedStatement fileStmt = conn.prepareStatement(fileSql); //(? 1-4)
	fileStmt.setInt(1, boardNo);
	fileStmt.setString(2, originFilename);
	fileStmt.setString(3, saveFilename);
	fileStmt.setString(4, type);
	System.out.println(fileStmt +"<-- addBoardAction.jsp fileStmt");
	
	fileStmt.executeUpdate();
	
	/* redirection 
	* fileStmt.executeUpdate() 후 변수 row의 값 저장. 값에 따른 페이지 이동
	* row == 0, addBoard.jsp
	* row == 1, home.jsp
	*/
	int row = boardStmt.executeUpdate();
	System.out.println(row+"<-- addBoardAction.jsp row");
	
	if(row == 0){
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp");
	}else if(row == 1){ 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}else {
		System.out.println("error row값 : "+row);
	}
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	
%>