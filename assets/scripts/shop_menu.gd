class_name ShopMenu extends Control

signal change_item(direction: String) # Only "up" or "down"
signal item_clicked(item_name: String)

@onready var open_shop_button: Button = %OpenShopButton
@onready var shop_item_button: TextureButton = %ShopItemButton
@onready var up_button: Button = %UpButton
@onready var down_button: Button = %DownButton
@onready var shop_item_container: Control = $HBoxContainer/PanelContainer2/HBoxContainer/VBoxContainer/ShopItemContainer

signal toggle_shop()

const SHOP_MENU_LENGTH := 243

var is_item_swapping := false
var current_item_index := 0

var shop_items: Array[TextureButton]


enum ShopDirection {
	UP,
	DOWN,
}

func _ready() -> void:
	var grid_children = shop_item_container.get_children()
	for item in grid_children:
		if item is TextureButton:
			if item != grid_children[0]:
				item.modulate = Color(1.0, 1.0, 1.0, 0.6)
				item.position.y = 128
			shop_items.append(item)

func _on_open_shop_button_pressed() -> void:
	toggle_shop.emit()


func disable():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func enable():
	mouse_filter = Control.MOUSE_FILTER_STOP


func _on_shop_item_button_pressed() -> void:
	item_clicked.emit("godot")


func _on_up_button_pressed() -> void:
	handle_item_swap(ShopDirection.UP)


func _on_down_button_pressed() -> void:
	handle_item_swap(ShopDirection.DOWN)

func handle_item_swap(p_direction: ShopDirection) -> void:
	if is_item_swapping:
		return
	
	const TWEEN_DURATION = 0.5
	
	is_item_swapping = true
	
	if current_item_index == 1 && p_direction == ShopDirection.UP:
		up_button.modulate = Color(0.0, 0.0, 0.0, 0.0)
		up_button.disabled = true
	elif current_item_index == shop_items.size() - 2 and p_direction == ShopDirection.DOWN:
		down_button.modulate = Color(0.0, 0.0, 0.0, 0.0)
		down_button.disabled = true
	else:
		up_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
		down_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
		up_button.disabled = false
		down_button.disabled = false
	
	var current_item = shop_items[current_item_index]
	var old_shop_item_position = Vector2(0, 128) if p_direction == ShopDirection.UP else Vector2(0, -128)
	
	var shop_item_tween = create_tween()
	shop_item_tween.set_ease(Tween.EASE_OUT)
	shop_item_tween.set_trans(Tween.TRANS_EXPO)
	shop_item_tween.set_parallel()
	shop_item_tween.tween_property(current_item, "modulate", Color(1.0, 1.0, 1.0, 0.6), TWEEN_DURATION)
	shop_item_tween.tween_property(current_item, "scale", Vector2(0.6, 0.6), TWEEN_DURATION)
	shop_item_tween.tween_property(current_item, "position", old_shop_item_position, TWEEN_DURATION)
	
	if p_direction == ShopDirection.UP:
		current_item_index -= 1
	else:
		current_item_index += 1
	
	var new_shop_item = shop_items[current_item_index]
	
	shop_item_tween.set_parallel()
	shop_item_tween.tween_property(new_shop_item, "modulate", Color(1.0, 1.0, 1.0, 1.0), TWEEN_DURATION)
	shop_item_tween.tween_property(new_shop_item, "scale", Vector2(1, 1), TWEEN_DURATION)
	shop_item_tween.tween_property(new_shop_item, "position", Vector2(0, 0), TWEEN_DURATION)
	
	await shop_item_tween.finished
	
	is_item_swapping = false
