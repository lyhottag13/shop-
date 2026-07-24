class_name ShopMenu extends Control

signal change_item(direction: String) # Only "up" or "down"
signal item_clicked(item_name: String)

@onready var open_shop_button: Button = %OpenShopButton
@onready var shop_item_button: TextureButton = %ShopItemButton
@onready var up_button: Button = %UpButton
@onready var down_button: Button = %DownButton

signal toggle_shop()

const SHOP_MENU_LENGTH := 243

func _on_open_shop_button_pressed() -> void:
	toggle_shop.emit()


func disable():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func enable():
	mouse_filter = Control.MOUSE_FILTER_STOP


func _on_shop_item_button_pressed() -> void:
	item_clicked.emit("godot")
