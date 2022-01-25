package com.rock.example;

import java.io.IOException;
import java.io.PrintWriter; 
import java.net.InetAddress; 
import java.util.HashMap;
 
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse; 
import javax.servlet.annotation.WebServlet;

import com.google.gson.Gson;

/**
 * Servlet implementation class Hello
 */
@WebServlet("/Ping")
public class Ping extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Ping() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		  
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8"); 

		PrintWriter out = response.getWriter(); 
		
		try {  
            HashMap<String,Object> source = new HashMap<>();  
             
		    source.put("pageCode", "0001"); 
		    source.put("ip", InetAddress.getLocalHost().getHostAddress().toString());
		    source.put("hostname", InetAddress.getLocalHost().getHostName().toString());
		    source.put("ping", "pong"); 

		    String json = new Gson().toJson(source);

		    out.print(json);
		    System.out.println(json);
		    
		    out.flush();
		    
    	}catch(Exception e) {
			out.print("An exception was thrown: " + e.getMessage() + "<br>");
    		e.printStackTrace();
    	}   
		
		//response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
