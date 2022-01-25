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
    <h1>DB Connection Pool Test - JNDI </h1> 
    
	<P>
        <%
        if(request.getParameter("jndiName") != null) {
             //  	PrintWriter writer = response.getWriter();
            out.write("<h1>Results of Test</h1>");
            String jndiName = request.getParameter("jndiName");
            try {
                InitialContext ctx = new InitialContext();
                DataSource ds = (DataSource)ctx.lookup(jndiName);
                out.write("<p>Successfully looked up DataSource named " + jndiName + "</p>");
                if(request.getParameter("tableName") != null) {
                    String tableName = request.getParameter("tableName");
                    Connection conn = null;
                        Statement stmt = null;
                    conn = ds.getConnection();
                    out.write("<p>Successfully connected to database.</p>");
                    stmt = conn.createStatement();
                    String query = "SELECT * FROM " + tableName;
                    out.write("<p>Attempting query \"" + query + "\"</p>");
                    ResultSet results = stmt.executeQuery(query);
                    ResultSetMetaData rsMetaData = results.getMetaData();
                        int numberOfColumns = rsMetaData.getColumnCount();
                    out.write("<table><tr>");
                    //Display the header row of column names
                        for (int i = 1; i <= numberOfColumns; i++) {
                        int columnType = rsMetaData.getColumnType(i);
                              String columnName = rsMetaData.getColumnName(i);
                        if(columnType == Types.VARCHAR) {
                            out.write("<td>" + columnName + "</td>");
                        }
                        }
                    out.write("</tr>");
                    //Print the values (VARCHAR's only) of each result
                    while(results.next()) {
                        out.write("<tr>");
                            for (int i = 1; i <= numberOfColumns; i++) {
                            int columnType = rsMetaData.getColumnType(i);
                                  String columnName = rsMetaData.getColumnName(i);
                            if(columnType == Types.VARCHAR) {
                                out.write("<td>" + results.getString(columnName) + "</td>");
                            }
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
        <h1>Test an EAP Datasource</h1>
        <form method="post">
            <table>
                <tr>
                    <td>JNDI Name of Datasource:</td>
                    <td><input type="text" width="60" name="jndiName"/></td>
                </tr>
                <tr>
                    <td>Table Name to Query (optional):</td>
                    <td><input type="text" width="60" name="tableName"/></td>
                </tr>
                <tr>
                    <td colspan="2" align="center"><input type="submit" value="Submit" name="submit"/></td>
                </tr>
            </table>
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

