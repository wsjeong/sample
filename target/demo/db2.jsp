<%@ page pageEncoding="utf8" contentType="text/html; charset=utf8"%>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%!
  private static String seconds(double l) {
        NumberFormat nf = new DecimalFormat("#.#####");
        return nf.format(l);
  }
%>
<%
  double start = System.nanoTime(); 
%>
<html>
  <head>
	<title>DB Connection Pool Test - JNDI</title>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	<style>
		body{
			background-color:#fff;
			color:#000;
		}
	</style>
  </head>
    <body>
    <h1>DB Connection Pool Test - DBCP2 </h1> 
    
	<P>
        <%
        if(request.getParameter("url") != null || request.getParameter("class") != null || request.getParameter("username") != null || request.getParameter("password") != null) {
           //  	PrintWriter writer = response.getWriter();
          out.write("<h3>- Results of Test</h3>");
          String url = request.getParameter("url");
          String forclass = request.getParameter("class");
          String username = request.getParameter("username");
          String password = request.getParameter("password");

          ResultSet  rs   = null;
          Connection conn = null;
          Statement  stmt = null;
          InitialContext ctx = null;
          DataSource     ds=null;

          try {
              Class.forName(forclass);
              conn = DriverManager.getConnection(url,username, password);

              out.write("<p>Successfully looked up DataSource named " + url + "</p>");

              if(request.getParameter("tableName") != null) {
                  String tableName = request.getParameter("tableName");
                  out.write("<p>Successfully connected to database.</p>");
                  stmt = conn.createStatement();
                  String query = "SELECT * FROM " + tableName;
                  out.write("<p>Attempting query \"" + query + "\"</p>");
                  ResultSet results = stmt.executeQuery(query);
                  ResultSetMetaData rsMetaData = results.getMetaData();

                  int numberOfColumns = rsMetaData.getColumnCount();

                  if(numberOfColumns > 5 ) numberOfColumns = 10;

                  out.write("<table class='table'><tr>");
                  //Display the header row of column names
                  for (int i = 1; i <= numberOfColumns; i++) {
                      int columnType = rsMetaData.getColumnType(i);
                          String columnName = rsMetaData.getColumnName(i);

                          out.write("<td>" + columnName + "</td>");

                  }

                  out.write("</tr>");

                  //Print the values (VARCHAR's only) of each result
                  while(results.next()) {
                      out.write("<tr>");
                          for (int i = 1; i <= numberOfColumns; i++) {
                          int columnType = rsMetaData.getColumnType(i);
                                String columnName = rsMetaData.getColumnName(i);

                              out.write("<td>" + results.getString(columnName) + "</td>");

                          }
                      out.write("</tr>");
                  }
                  out.write("</table>");
                  stmt.close();
                  conn.close();
              }
              }catch(Exception e) {
              out.write("An exception was thrown: " + e.getMessage() + "<br>");
                  e.printStackTrace();
              }
      } else {
      %>
      <form method="post">
          <table style="width:500px">
            <tr>
                <th>DB URL:</th>
                <td><input type="text" style="width:90%" name="url" value="jdbc:mysql://localhost/testDB"/></td>
            </tr>
            <tr>
                <th>DB Class:</th>
                <td><input type="text" style="width:90%" name="class" value="com.mysql.jdbc.Driver"/></td>
            </tr>

            <tr>
                <th>DB User:</th>
                <td><input type="text" style="width:90%" name="username" value="mysql"/></td>
            </tr>

            <tr>
                <th>DB Password:</th>
                <td><input type="text" style="width:90%" name="password" value="mysql"/></td>
            </tr>

            <tr>
                <th>Table Name:</th>
                <td><input type="text" style="width:90%" name="tableName"/></td>
            </tr>
            </table>

          <input type="submit" value="Submit" name="submit"/>
      </form>
      <% } %>

    </P>

	<%
		double end = System.nanoTime();
		double elapsedTime = (end - start)/1000000000;
	%>
	<p>
	Page rendered in <strong><%=seconds(elapsedTime)%></strong> seconds
	</p>

</body>
</html>

