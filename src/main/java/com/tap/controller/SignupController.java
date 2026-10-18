package com.tap.controller;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

import com.tap.model.User;
import com.tap.DAOImp.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Signup")
public class SignupController extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String password = req.getParameter("password");
		String address = req.getParameter("address");
		String phone = req.getParameter("phone");
		
		User user = new User();
		user.setName(name);
		user.setEmail(email);
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
		user.setPassword(hashedPassword);
		user.setAddress(address);
		user.setPhone(phone);
		user.setRole("user");
		
		UserDAOImpl dao = new UserDAOImpl();

		dao.addUser(user);
		
		resp.sendRedirect(req.getContextPath() + "/restaurants");
		
	}
}
