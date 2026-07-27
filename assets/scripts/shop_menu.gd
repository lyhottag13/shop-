class_name ShopMenu extends Control

signal item_clicked(dialogue: Array[Dialogue])

@onready var open_shop_button: Button = %OpenShopButton
@onready var up_button: Button = %UpButton
@onready var down_button: Button = %DownButton
@onready var shop_item_container: Control = %ShopItemContainer
@onready var title: Label = %Title
@onready var description: Label = %Description

signal toggle_shop()

const SHOP_MENU_LENGTH := 243
const TWEEN_DURATION := 0.5
const INVISIBLE_COLOR := Color(1.0, 1.0, 1.0, 0.0)
const VISIBLE_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const TRANSLUCENT_COLOR := Color(1.0, 1.0, 1.0, 0.6)
const ITEM_HEIGHT := 128

var is_item_swapping := false
var current_item_index := 0

var shop_item_buttons: Array[TextureButton]


func _ready() -> void:
	for item in ItemData.item_data.values():
		var new_button = TextureButton.new()
		new_button.size = Vector2(132, 132)
		new_button.texture_normal = item.image
		new_button.pivot_offset_ratio = Vector2(0.5, 0.5)
		
		var is_front_item = item == ItemData.item_data.values().front()
		if is_front_item:
			title.text = item.title
			description.text = item.description
		new_button.position = Vector2(0, 0) if is_front_item else Vector2(0, 132)
		new_button.pressed.connect(_on_shop_item_clicked.bind(item.name))
		shop_item_buttons.append(new_button)
		shop_item_container.add_child(new_button)

func _on_open_shop_button_pressed() -> void:
	toggle_shop.emit()


func disable():
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func enable():
	mouse_filter = Control.MOUSE_FILTER_STOP


func _on_shop_item_clicked(item_name: String) -> void:
	item_clicked.emit(item_name)


func _on_up_button_pressed() -> void:
	var new_item_index = current_item_index - 1
	handle_item_swap(current_item_index, new_item_index)


func _on_down_button_pressed() -> void:
	var new_item_index = current_item_index + 1
	handle_item_swap(current_item_index, new_item_index)

func handle_item_swap(old_item_index: int, new_item_index: int) -> void:
	if is_item_swapping:
		return
	
	is_item_swapping = true
	
	var is_going_to_top := new_item_index == 0
	var is_going_to_bottom := new_item_index == ItemData.item_data.size() - 1
	
	up_button.visible = not is_going_to_top
	down_button.visible = not is_going_to_bottom
	
	var old_shop_item: TextureButton = shop_item_buttons[old_item_index]
	var new_shop_item: TextureButton = shop_item_buttons[new_item_index]
	var old_shop_item_position := Vector2(0, (132 if new_item_index < old_item_index else -132))
	
	var shop_item_tween := create_tween()
	shop_item_tween.set_ease(Tween.EASE_OUT)
	shop_item_tween.set_trans(Tween.TRANS_EXPO)
	shop_item_tween.set_parallel()
	
	shop_item_tween.tween_property(old_shop_item, "modulate", Color(1.0, 1.0, 1.0, 0.6), TWEEN_DURATION)
	shop_item_tween.tween_property(old_shop_item, "scale", Vector2(0.6, 0.6), TWEEN_DURATION)
	shop_item_tween.tween_property(old_shop_item, "position", old_shop_item_position, TWEEN_DURATION)
	
	shop_item_tween.tween_property(new_shop_item, "modulate", Color(1.0, 1.0, 1.0, 1.0), TWEEN_DURATION)
	shop_item_tween.tween_property(new_shop_item, "scale", Vector2(1, 1), TWEEN_DURATION)
	shop_item_tween.tween_property(new_shop_item, "position", Vector2(0, 0), TWEEN_DURATION)
	
	var item_title: String = ItemData.item_data.values()[new_item_index].title
	var item_description: String = ItemData.item_data.values()[new_item_index].description
	set_title_and_description(item_title, item_description)
	
	current_item_index = new_item_index
	
	await shop_item_tween.finished
	
	is_item_swapping = false


func set_title_and_description(p_title: String, p_description: String):
	title.text = p_title
	description.text = p_description
	
