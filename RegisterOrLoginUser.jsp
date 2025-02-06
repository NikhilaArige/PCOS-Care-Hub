<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
    response.setContentType("text/html");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        // Load the Oracle JDBC driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Connect to the database
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "abc123");

        // Check if user already exists
        String checkUserQuery = "SELECT password FROM users WHERE email = ?";
        pst = con.prepareStatement(checkUserQuery);
        pst.setString(1, email);
        rs = pst.executeQuery();

        if (rs.next()) {
            // User exists; validate password
            String storedPassword = rs.getString("password");

            if (storedPassword.equals(password)) {
                // Password matches; redirect to login.html
                out.println("<script>alert('Login Successful!'); window.location.href = 'login.html';</script>");
            } else {
                // Password mismatch; redirect to home.html
                out.println("<script>alert('Incorrect Password!'); window.location.href = 'home.html';</script>");
            }
        } else {
            // User does not exist; insert new user
            String insertUserQuery = "INSERT INTO users (email, password) VALUES (?, ?)";
            pst = con.prepareStatement(insertUserQuery);
            pst.setString(1, email);
            pst.setString(2, password);

            int result = pst.executeUpdate();

            if (result > 0) {
                // Registration successful; redirect to login.html
                out.println("<script>alert('Registration Successful! Redirecting to login page...'); window.location.href = 'login.html';</script>");
            } else {
                // Registration failed
                out.println("<script>alert('Registration Failed'); window.location.href = 'home.html';</script>");
            }
        }
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location.href = 'home.html';</script>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
