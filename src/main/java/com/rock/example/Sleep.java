package com.rock.example;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress; 
import java.util.HashMap;
 
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; 
import javax.servlet.annotation.WebServlet;

import com.google.gson.Gson;

/**
 * Servlet implementation class Hello
 */
@WebServlet("/Sleep")
public class Sleep extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Sleep() {
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
		
		String sleep = "1";
		if(request.getParameter("sleep") != null) sleep = request.getParameter("sleep");

		long time = Long.parseLong(sleep) * 1000; 

        long start = System.currentTimeMillis(); 
	    
		PrintWriter out = response.getWriter();
		HttpSession session; 
		
		try { 
			session = request.getSession(true);
            HashMap<String,Object> source = new HashMap<>(); 

			Thread.sleep(time);
            			
			// Get the session data value
		    Integer ival = (Integer) session.getAttribute("counter");
			 
		    if (ival == null) ival = new Integer (1);
		    else ival = new Integer (ival.intValue() + 1);
		    session.setAttribute ("counter", ival);
		      
		    //source.put("ip", request.getRemoteAddr().toString());
		    source.put("pageCode", "0003"); 
		    source.put("ip", InetAddress.getLocalHost().getHostAddress().toString());
		    source.put("hostname", InetAddress.getLocalHost().getHostName().toString());

            long finish = System.currentTimeMillis();
            long timeElapsed = finish - start;

		    source.put("expected", time);  
		    source.put("elapsed", timeElapsed); 
		    
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
