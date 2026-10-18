package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items;
    private int restaurantId;

    public Cart() {
        items = new LinkedHashMap<>();
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public boolean addItem(Menu menu) {
        if (items.isEmpty()) {
            restaurantId = menu.getRestaurant_id();
        }

        if (restaurantId != menu.getRestaurant_id()) {
            return false;
        }

        int menuId = menu.getMenu_id();

        if (items.containsKey(menuId)) {
            CartItem existingItem = items.get(menuId);
            existingItem.setQuantity(existingItem.getQuantity() + 1);
        } else {
            CartItem cartItem = new CartItem(menu, 1);
            items.put(menuId, cartItem);
        }

        return true;
    }

    public void removeItem(int menuId) {
        items.remove(menuId);

        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }

    public void updateQuantity(int menuId, int quantity) {
        if (items.containsKey(menuId)) {
            if (quantity <= 0) {
                removeItem(menuId);
            } else {
                items.get(menuId).setQuantity(quantity);
            }
        }
    }

    public double getGrandTotal() {
        double total = 0;

        for (CartItem item : items.values()) {
            total += item.getSubTotal();
        }

        return total;
    }

    public int getTotalItems() {
        int count = 0;

        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }

        return count;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clearCart() {
        items.clear();
        restaurantId = 0;
    }

    public Collection<CartItem> getCartItems() {
        return items.values();
    }

    @Override
    public String toString() {
        return "Cart [items=" + items.values() + ", restaurantId=" + restaurantId + ", grandTotal=" + getGrandTotal() + "]";
    }
}