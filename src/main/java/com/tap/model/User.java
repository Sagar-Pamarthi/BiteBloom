package com.tap.model;

import java.sql.Timestamp;

public class User {
	
	private int user_id;
	private String name;
	private String email;
	private String password;
	private String address;
	private String phone;
	private String role;
	private Timestamp createdDate;
	private Timestamp lastLoginDate;
	

	public User() {
		super();
		
	}
	
	public User(String name, String email, String password, String address, String phone, String role,
			Timestamp createdDate, Timestamp lastLoginDate) {
		super();
		this.name = name;
		this.email = email;
		this.password = password;
		this.address = address;
		this.phone = phone;
		this.role = role;
		this.createdDate = createdDate;
		this.lastLoginDate = lastLoginDate;
	}
	
	
	public User(String name, String email, String password, String address, String phone, String role) {
		super();
		this.name = name;
		this.email = email;
		this.password = password;
		this.address = address;
		this.phone = phone;
		this.role = role;
	}

	
	public User(int user_id, String name, String email, String password, String address, String phone, String role,
			Timestamp createdDate, Timestamp lastLoginDate) {
		super();
		this.user_id = user_id;
		this.name = name;
		this.email = email;
		this.password = password;
		this.address = address;
		this.phone = phone;
		this.role = role;
		this.createdDate = createdDate;
		this.lastLoginDate = lastLoginDate;
	}

	public User(int user_id, String role) {
		super();
		this.user_id = user_id;
		this.role = role;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public Timestamp getLastLoginDate() {
		return lastLoginDate;
	}

	public void setLastLoginDate(Timestamp lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}

	@Override
	public String toString() {
		return "User [user_id=" + user_id + ", name=" + name + ", email=" + email + ", password=" + password
				+ ", address=" + address + ", phone=" + phone + ", role=" + role + ", createdDate=" + createdDate
				+ ", lastLoginDate=" + lastLoginDate + "]";
	}

}
