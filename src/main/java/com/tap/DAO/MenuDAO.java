package com.tap.DAO;

import java.util.List;

import com.tap.model.Menu;

public interface MenuDAO {

	void addMenu(Menu menu);
	Menu getMenu(int menu_id);
	void updateMenu(Menu menu);
	void deleteMenu(int menu_id);
	List<Menu> getAllMenu();
	List<Menu> getMenusByRestaurantId(int restaurantId);
	List<Integer> getRestaurantIdsByFoodCategory(String foodCategory);
}
