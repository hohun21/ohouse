package com.ohouse.common.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Map.Entry;

import com.ohouse.common.command.CommandHandler;
import com.ohouse.common.command.NullHandler;

public class DispatcherServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
      
    public DispatcherServlet() {
        super();
    }
    
    private Map<String, CommandHandler> commandHandlerMap = new HashMap<>();
    
	@Override
	public void init() throws ServletException {
		super.init();
		System.out.println("Ohouse DispatcherServlet.init() 실행 중..."); // 로그 메세지 수정
		
		String urlMappingPath = this.getInitParameter("urlMappingPath");
		System.out.println("urlMappingPath: " + urlMappingPath);
		
		String realPath = this.getServletContext().getRealPath(urlMappingPath);
		
		Properties p = new Properties();
		
		try( FileReader reader = new FileReader(realPath)){
			p.load(reader);
		}catch(Exception e) {
			throw new ServletException();
		}
		
		// Properties p -> commandHandlerMap 저장
		Set<Entry<Object, Object>> set =  p.entrySet();
		Iterator<Entry<Object, Object>> ir = set.iterator();
		
		while (ir.hasNext()) {
         Entry<Object, Object> entry = ir.next();
         String url = (String) entry.getKey();
         String fullName = (String) entry.getValue();
         
         // fullName 문자열 -> 생성된 커맨드 객체
         try {
            Class<?> commmandHandlerClass = Class.forName(fullName);
            CommandHandler handler = (CommandHandler) commmandHandlerClass
                                       .getDeclaredConstructor()
                                       .newInstance();
            commandHandlerMap.put(url, handler);
         } catch (Exception e) { 
            e.printStackTrace();
         }
           
      } // while
		
		System.out.println("등록된 핸들러 개수 : " + commandHandlerMap.size());
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 요청URL 분석 
		String requestURI = request.getRequestURI();
		System.out.println("! requestURI: " + requestURI);
		String contextPath = request.getContextPath(); 
		String path = requestURI.substring(contextPath.length());
		System.out.println("path: " + path);
		
		// 2. 요청을 처리할 핸들러 객체를 map 으로부터 얻어오기
		CommandHandler handler = this.commandHandlerMap.get(path);
		
		if(handler == null) {
			handler = new NullHandler();
		}
		
		// 3. 핸들러 객체 실행
		String viewName = null;
		try {
			viewName = handler.process(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 4.
		if(viewName == null) {
			return;
		}
		
		if(viewName.startsWith("redirect:")) {
			// 5. 리다이렉트
			String location = viewName.substring("redirect:".length());
			response.sendRedirect(location);
			
		}else {
			// 5-2. 포워딩
			RequestDispatcher dispatcher = request.getRequestDispatcher(viewName);
			dispatcher.forward(request, response);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}