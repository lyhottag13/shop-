class_name Shop 
extends Node2D

signal goto_arcade

@onready var ali_shop_button: Button = %AliShopButton
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var background: TextureRect = $Background
@onready var ali: Ali = $Ali
@onready var sign_animation_player: AnimationPlayer = %SignAnimationPlayer
@onready var shop_menu: ShopMenu = %ShopMenu
@onready var arcade_switcher_button: TextureButton = %ArcadeSwitcherButton

var can_interact := true

enum CUTSCENE_TYPE {
	ITEM,
	SEQUENCE
}

func _on_interactable_pressed(sequence_key: String) -> void:
	handle_cutscene(CUTSCENE_TYPE.SEQUENCE, sequence_key)


func handle_sequence(key: String):
	match key:
		"remove_sign":
			if ali_shop_button.pressed.is_connected(_on_interactable_pressed):
				ali_shop_button.pressed.disconnect(_on_interactable_pressed)
			create_tween().tween_property(background, "modulate", Color.WHITE, 0.5)
			create_tween().tween_property(ali, "modulate", Color.WHITE, 0.5)
			ali.play_animation("removing_sign")
			await Utils.sleep(1)
			SoundManager.play_background(Constants.BACKGROUNDS.SHOP)
			SoundManager.fade_background(0, 1)
			start_howdy_text()
			await ali.play_animation("emerging")
			appear_shop()
			ali.play_animation("idle")
			ali_shop_button.pressed.connect(_on_interactable_pressed.bind("banter"))
	
			const ENDING_POSITION = Vector2(357, 0)
			create_tween().tween_property(arcade_switcher_button, "position", ENDING_POSITION, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		"banter":
			var random_index = randi_range(0, 2)
			var dialogue: Array = Dialogue.dialogue["banter" + str(random_index)] as Array[Dictionary]
			await handle_dialogue(dialogue)
		"thorn_ring":
			disappear_shop()
			dialogue_box.clear()
			background.modulate = Color(1.0, 0.559, 0.559, 1.0)
			ali.play_animation("thorn_ring")
			SoundManager.stop_background()
			await Utils.sleep(3)
			SoundManager.play_background(Constants.BACKGROUNDS.SHOP)
			background.modulate = Color(1.0, 1.0, 1.0, 1.0)
			ali.play_animation("idle")
			appear_shop()


func start_howdy_text() -> void:
	await Utils.sleep(1)
	await dialogue_box.show_text({text = "Howdy!\nI'm Ali.", face = "happy"})


func _on_shop_menu_toggle_shop() -> void:
	if not can_interact:
		return
	
	can_interact = false
	await toggle_shop()
	can_interact = true


var is_shop_menu_open = false


# Used when the open shop button is clicked
func toggle_shop(enabled = null) -> void:
	# Useful when the disappear shop is used and the shop is currently closed
	if enabled == is_shop_menu_open: 
		return
	
	is_shop_menu_open = enabled if enabled != null else not is_shop_menu_open
	
	const TWEEN_TIME = 0.7
	var ali_final_pos = 104 if is_shop_menu_open else 240
	var shop_final_pos = 480 if is_shop_menu_open else 761
	var tween := create_tween()
	tween.tween_property(shop_menu, "position:x", shop_final_pos, TWEEN_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(ali, "position:x", ali_final_pos, TWEEN_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished


func disappear_shop() -> void:
	create_tween().tween_property(shop_menu, "modulate", Color.TRANSPARENT, 0.5)
	toggle_shop(false)
	shop_menu.disable()


func appear_shop() -> void:
	await create_tween().tween_property(shop_menu, "modulate", Color.WHITE, 0.5).finished
	shop_menu.enable()


func _on_shop_menu_item_clicked(item_name: String) -> void:
	handle_cutscene(CUTSCENE_TYPE.ITEM, item_name)


func handle_shop_item(item_name: String):
	var dialogue: Array = ItemData.item_data[item_name].dialogue
	if item_name == "ena":
		await handle_dialogue(dialogue, "talking_ena")
	else:
		await handle_dialogue(dialogue)


func handle_dialogue(dialogue: Array, animation: String = "talking"):
	ali.play_animation(animation)
	disappear_shop()
	for dialogue_data: Dictionary in dialogue:
		await dialogue_box.show_text(dialogue_data)
		await Utils.sleep(2)
	appear_shop()
	ali.play_animation("idle")
	dialogue_box.clear()
	

func handle_cutscene(cutscene_type: CUTSCENE_TYPE, key: String):
	if not can_interact:
		return
	
	if key == "thorn_ring":
		cutscene_type = CUTSCENE_TYPE.SEQUENCE
	
	CursorStopper.show()
	
	can_interact = false
	match cutscene_type:
		CUTSCENE_TYPE.ITEM:
			await handle_shop_item(key)
		CUTSCENE_TYPE.SEQUENCE:
			await handle_sequence(key)
	can_interact = true
	
	CursorStopper.hide()
	
	# Resets the cursor after the cursor_stopper has disappeared.
	Input.parse_input_event(InputEventMouseMotion.new()) 


func _on_ali_sign_left_hand() -> void:
	sign_animation_player.play("throw_sign")


func _on_button_pressed() -> void:
	goto_arcade.emit()
