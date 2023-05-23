<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*"%>
<%
	/* session값 유효성 검사
	* session 값이 null이면 home.jsp 페이지로 리턴
	*/
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	/* MultipartRequest API 
	* new MultipartRequest(원본request, 업로드폴더, 최대파일사이즈byte, 인코딩, 중복이름정책)
	* new DefaultFileRenamePolicy() : 업로드 폴더내 동일한 이름이 있으면 뒤에 숫자를 추가
	* dir : 프로젝트안 upload폴더의 실제 물리적 위치를 반환
	* max : 최대 파일사이즈byte
	*/
	String dir = request.getServletContext().getRealPath("/upload");
	int max = 10 * 1024 * 1024;
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// 값 저장
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(mRequest.getParameter("boardFileNo"));
	String boardTitle = mRequest.getParameter("boardTitle");
	// 디버깅 코드
	System.out.println(boardNo + "<-- modifyBoardAction.jsp boardNo");
	System.out.println(boardFileNo + "<-- modifyBoardAction.jsp boardFileNo");
	System.out.println(boardTitle + "<-- modifyBoardAction.jsp boardTitle");
	
	// DB 설정
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root"; 
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbpw);
	System.out.println("modifyBoardAction.jsp db접속 성공");
	
	// 1) board_title 수정
	String boardSql = "UPDATE board SET board_title = ? WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setString(1, boardTitle);
	boardStmt.setInt(2, boardNo);
	System.out.println(boardStmt + "<-- modifyBoardAction.jsp boardStmt");
	int boardRow = boardStmt.executeUpdate();

	// 2) 이전 boardFile 삭제, 새로운 boardFile추가 테이블을 수정
	// mRequest.getOriginalFileName("boardFile") == null이면 boardTitle만 수정
	if(mRequest.getOriginalFileName("boardFile") !=null){
		
		// 수정할 파일이 있으면 image 파일 유효성 검사
		if(mRequest.getContentType("boardFile").equals("image/png") == false){
			System.out.println("image파일이 아닙니다");
			String saveFilename = mRequest.getOriginalFileName("boardFile");
			File f = new File(dir+"/"+saveFilename);
			if(f.exists()){
				f.delete();
				System.out.println(saveFilename+"modifyBoardAction.jsp 파일삭제");
			}
		} else{
			/* image파일이면 
			* 1) 이전 파일 삭제
			* 2) DB수정(update)
			*/ 
			String type = mRequest.getContentType("boardFile");
			String originFilename = mRequest.getOriginalFileName("boardFile");
			String saveFilename = mRequest.getFilesystemName("boardFile");
			// 디버깅 코드
			System.out.println(type + "<-- modifyBoardAction.jsp type");
			System.out.println(originFilename + "<-- modifyBoardAction.jsp originFilename");
			System.out.println(saveFilename + "<-- modifyBoardAction.jsp saveFilename");
			
			// mRequest로 받은 값 BoardFile 객체 만들어 값 저장
			BoardFile boardFile = new BoardFile();
			boardFile.setBoardFileNo(boardFileNo);
			boardFile.setType(type);
			boardFile.setOriginFilename(originFilename);
			boardFile.setSaveFilename(saveFilename);
			
			// 1) 이전 파일 삭제
			String saveFilenameSql = "SELECT save_filename FROM board_file WHERE board_file_no=?";
			PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
			saveFilenameStmt.setInt(1, boardFile.getBoardFileNo());
			System.out.println(saveFilenameStmt + "<-- modifyBoardAction.jsp saveFilenameStmt");
			
			ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
			String preSaveFilename = "";
			if(saveFilenameRs.next()) {
				preSaveFilename = saveFilenameRs.getString("save_filename");
			}
			File f = new File(dir+"/"+preSaveFilename);
			if(f.exists()) {
				f.delete();
				System.out.println("modifyBoardAction.jsp 파일삭제");
			}
			
			// 2) 수정된 파일의 정보로 DB수정
			String boardFileSql = "UPDATE board_file SET origin_filename=?, save_filename=? WHERE board_file_no=?";
			PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
			boardFileStmt.setString(1, boardFile.getOriginFilename());
			boardFileStmt.setString(2, boardFile.getSaveFilename());
			boardFileStmt.setInt(3, boardFile.getBoardFileNo());
			System.out.println(boardFileStmt+"<-- modifyBoardAction.jsp boardFileStmt");
			
			int boardFileRow = boardFileStmt.executeUpdate();	
			
			/* redirection 수정 성공, 실패에 따른 페이지 이동
			* boardFileRow의 boardFileStmt.executeUpdate() 값 저장
			* row == 0 : modifyBoard.jsp 페이지 이동. 
			* row == 1 : home.jsp 페이지 이동.
			*/
			int row = boardFileStmt.executeUpdate();
			System.out.println(row+"<--modifyBoardAction.jsp row");
			
			if(row == 0){
				response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp");
				System.out.println("modifyBoardAction.jsp 수정 실패");
			}else if(row == 1){ 
				response.sendRedirect(request.getContextPath()+"/home.jsp");
				System.out.println("modifyBoardAction.jsp 수정 성공");
			}else {
				System.out.println("error row값 : "+row);
			}
		}
	}
	
	
%>