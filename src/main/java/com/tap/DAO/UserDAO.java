package com.tap.DAO;

import java.util.List;

import com.tap.model.User;

public interface UserDAO {
	void addUser(User user);
	User getUserByEmail(String email);
	void updateUser(User user);
	void deleteUser(int user_id);
	List<User> getAllUsers();
}
