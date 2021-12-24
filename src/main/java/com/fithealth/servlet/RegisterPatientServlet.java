package com.fithealth.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/registerPatient" })
public class RegisterPatientServlet extends HttpServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String fullName = null;
		String mobileNo = null;
		String emailAddress = null;
		int age = 0;
		String gender = null;

		fullName = req.getParameter("fullName");
		mobileNo = req.getParameter("mobileNo");
		emailAddress = req.getParameter("emailAddress");
		age = Integer.parseInt(req.getParameter("age"));
		gender = req.getParameter("gender");

		boolean flag = false;
		int patientNo = 0;
		try {
			con = getConnection();
			pstmt = con.prepareStatement(
					"insert into patient(patient_nm, mobile_nbr, email_address, age, gender) values(?,?,?,?,?)",
					new String[] { "patient_no" });
			pstmt.setString(1, fullName);
			pstmt.setString(2, mobileNo);
			pstmt.setString(3, emailAddress);
			pstmt.setInt(4, age);
			pstmt.setString(5, gender);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				patientNo = rs.getInt(1);
				req.setAttribute("patientNo", patientNo);
				req.setAttribute("fullName", fullName);
				req.getRequestDispatcher("/patient-details.jsp").forward(req, resp);
			}
			flag = true;
		} catch (SQLException | ClassNotFoundException e) {
			flag = false;
			throw new ServletException(e);
		} finally {
			try {
				if (con != null) {
					if (flag) {

						con.commit();

					} else {
						con.rollback();
					}
					con.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	private Connection getConnection() throws SQLException, ClassNotFoundException, IOException {
		Connection con = null;
		Properties props = new Properties();
		props.load(this.getClass().getClassLoader().getResourceAsStream("db.properties"));

		Class.forName(props.getProperty("db.driverClassName"));
		con = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.username"),
				props.getProperty("db.password"));
		con.setAutoCommit(false);
		return con;
	}

}
