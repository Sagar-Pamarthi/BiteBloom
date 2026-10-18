package com.tap.model;

public class Restaurant {
	
	int restaurant_id;
	String name;
	String cuisine_type;
	int delivery_time;
	String address;
	float rating;
	boolean is_active;
	String imagepath;
	
	public Restaurant() {
		super();
	}

	public Restaurant(int restaurant_id, String name, String cuisine_type, int delivery_time, String address,
			float rating, boolean is_active, String imagepath) {
		super();
		this.restaurant_id = restaurant_id;
		this.name = name;
		this.cuisine_type = cuisine_type;
		this.delivery_time = delivery_time;
		this.address = address;
		this.rating = rating;
		this.is_active = is_active;
		this.imagepath = imagepath;
	}

	public Restaurant(String name, String cuisine_type, int delivery_time, String address, float rating,
			boolean is_active, String imagepath) {
		super();
		this.name = name;
		this.cuisine_type = cuisine_type;
		this.delivery_time = delivery_time;
		this.address = address;
		this.rating = rating;
		this.is_active = is_active;
		this.imagepath = imagepath;
	}

	public int getRestaurant_id() {
		return restaurant_id;
	}

	public void setRestaurant_id(int restaurant_id) {
		this.restaurant_id = restaurant_id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCuisine_type() {
		return cuisine_type;
	}

	public void setCuisine_type(String cuisine_type) {
		this.cuisine_type = cuisine_type;
	}

	public int getDelivery_time() {
		return delivery_time;
	}

	public void setDelivery_time(int delivery_time) {
		this.delivery_time = delivery_time;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public float getRating() {
		return rating;
	}

	public void setRating(float rating) {
		this.rating = rating;
	}

	public boolean isIs_active() {
		return is_active;
	}

	public void setIs_active(boolean is_active) {
		this.is_active = is_active;
	}
	
	

	public String getImagepath() {
		return imagepath;
	}

	public void setImagepath(String imagepath) {
		this.imagepath = imagepath;
	}

	@Override
	public String toString() {
		return "Restaurant [restaurant_id=" + restaurant_id + ", name=" + name + ", cuisine_type=" + cuisine_type
				+ ", delivery_time=" + delivery_time + ", address=" + address + ", rating=" + rating + ", is_active="
				+ is_active + ", imagepath=" + imagepath + "]";
	}

	
	
	
}

