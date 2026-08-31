package com.ohouse.common.controller;

import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.common.handler.NullHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AjaxControllerUsingURI extends HttpServlet {

	private static final long serialVersionUID = -8786711678079225999L;

	// <커맨드, 핸들러인스턴스> 매핑 정보 저장
	private Map<String, CommandHandler> commandHandlerMap = 
			new HashMap<>();

	public void init() throws ServletException {
		String configFile = getInitParameter("configFile");
		Properties prop = new Properties();
		String configFilePath = getServletContext().getRealPath(configFile);
		try (FileReader fis = new FileReader(configFilePath)) {
			prop.load(fis);
		} catch (IOException e) {
			throw new ServletException(e);
		}
		Iterator keyIter = prop.keySet().iterator();
		while (keyIter.hasNext()) {
			String command = (String) keyIter.next();
			String handlerClassName = prop.getProperty(command);
			try {
				Class<?> handlerClass = Class.forName(handlerClassName);
				CommandHandler handlerInstance = 
						(CommandHandler) handlerClass.newInstance();
				commandHandlerMap.put(command, handlerInstance);
			} catch (ClassNotFoundException | InstantiationException 
					| IllegalAccessException e) {
				throw new ServletException(e);
			}
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		process(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	private void process(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String command = request.getRequestURI();
		if (command.indexOf(request.getContextPath()) == 0) {
			command = command.substring(request.getContextPath().length());
		}
		CommandHandler handler = commandHandlerMap.get(command);
		if (handler == null) {
			handler = new NullHandler();
		}

		String jsonData = null;
		try {
			jsonData = handler.process(request, response);
		} catch (Throwable e) {
			throw new ServletException(e);
		}

		if (jsonData != null) {
			PrintWriter out =  response.getWriter();
			out.append(  jsonData );
		}
	}
}

