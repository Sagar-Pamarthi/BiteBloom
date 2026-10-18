package com.tap.DAO;

import java.util.List;

import com.tap.model.Restaurant;

public interface RestaurantDAO {

	void addRestaurant(Restaurant restaurant);
	Restaurant getRestaurant(int restaurant_id);
	void updateRestaurant(Restaurant restaurant);
	void deleteRestaurant(int restaurant_id);
	List<Restaurant> getAllRestaurants();
}
