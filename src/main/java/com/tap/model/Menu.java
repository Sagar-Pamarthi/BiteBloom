package com.tap.model;

import java.sql.Timestamp;

public class Menu {

	private int menu_id;
	private int restaurant_id;
	private String itemName;
	private float price;
	private int is_available;
	private String category;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private Timestamp deletedAt;
	private String imagePath;
	private String dishType;
	private String description;
	
	
	
	public Menu() {
		super();
	}


	public Menu(int menu_id, int restaurant_id, String itemName, float price, int is_available, String category,
			Timestamp createdAt, Timestamp updatedAt, Timestamp deletedAt, String imagePath, String dishType, String description) {
		super();
		this.menu_id = menu_id;
		this.restaurant_id = restaurant_id;
		this.itemName = itemName;
		this.price = price;
		this.is_available = is_available;
		this.category = category;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
		this.deletedAt = deletedAt;
		this.imagePath = imagePath;
		this.dishType = dishType;
		this.description = description;
	}


	public int getMenu_id() {
		return menu_id;
	}


	public void setMenu_id(int menu_id) {
		this.menu_id = menu_id;
	}


	public int getRestaurant_id() {
		return restaurant_id;
	}


	public void setRestaurant_id(int restaurant_id) {
		this.restaurant_id = restaurant_id;
	}


	public String getItemName() {
		return itemName;
	}


	public void setItemName(String itemName) {
		this.itemName = itemName;
	}


	public float getPrice() {
		return price;
	}


	public void setPrice(float price) {
		this.price = price;
	}


	public int getIs_available() {
		return is_available;
	}


	public void setIs_available(int is_available) {
		this.is_available = is_available;
	}


	public String getCategory() {
		return category;
	}


	public void setCategory(String category) {
		this.category = category;
	}


	public Timestamp getCreatedAt() {
		return createdAt;
	}


	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}


	public Timestamp getUpdatedAt() {
		return updatedAt;
	}


	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}


	public Timestamp getDeletedAt() {
		return deletedAt;
	}


	public void setDeletedAt(Timestamp deletedAt) {
		this.deletedAt = deletedAt;
	}


	public String getImagePath() {
		return imagePath;
	}


	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}


	public String getDishType() {
		return dishType;
	}


	public void setDishType(String dishType) {
		this.dishType = dishType;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	@Override
	public String toString() {
		return "Menu [menu_id=" + menu_id + ", restaurant_id=" + restaurant_id + ", itemName=" + itemName + ", price="
				+ price + ", is_available=" + is_available + ", category=" + category + ", createdAt=" + createdAt
				+ ", updatedAt=" + updatedAt + ", deletedAt=" + deletedAt + ", imagePath=" + imagePath + ", dishType="
				+ dishType + ", description=" + description + "]";
	}

	

	
}
