class_name Game extends Node

@onready var ali_shop_button: Button = %AliShopButton
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var background: TextureRect = $Background
@onready var ali: Ali = $Ali
@onready var ali_animation_player: AnimationPlayer = %AliAnimationPlayer
@onready var shop_fade_animation_player: AnimationPlayer = %ShopFadeAnimationPlayer
@onready var shop_slide_animation_player: AnimationPlayer = %ShopSlideAnimationPlayer
@onready var background_animation_player: AnimationPlayer = %BackgroundAnimationPlayer
@onready var sign_animation_player: AnimationPlayer = %SignAnimationPlayer
@onready var shop_menu: ShopMenu = %ShopMenu
@onready var music: AudioStreamPlayer = $Music
@onready var cursor_stopper: Control = %CursorStopper

#region CURSOR
const cursor_normal = preload("uid://favkw5srtb07")
const cursor_wait = preload("uid://cg7qrew34rpr")
const cursor_highlight = preload("uid://h8vim3ghdnwp")
#endregion

var can_interact := true

enum CUTSCENE_TYPE {
	ITEM,
	SEQUENCE
}


func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_normal)
	Input.set_custom_mouse_cursor(cursor_wait, Input.CURSOR_WAIT)
	Input.set_custom_mouse_cursor(cursor_highlight, Input.CURSOR_POINTING_HAND)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	elif event is InputEventMouseButton:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_interactable_pressed(sequence_key: String) -> void:
	handle_cutscene(CUTSCENE_TYPE.SEQUENCE, sequence_key)


func handle_sequence(key: String):
	match key:
		"remove_sign":
			background_animation_player.play("fade_to_yellow")
			ali_animation_player.play("light_up")
			ali.play_animation("removing_sign")
			await Utils.sleep(1)
			music.play()
			start_howdy_text()
			await ali.play_animation("emerging")
			appear_shop()
			ali.play_animation("idle")
			ali_shop_button.pressed.connect(_on_interactable_pressed.bind("banter"))
		"banter":
			var random_index = randi_range(0, 2)
			var dialogue: Array = Dialogue.dialogue["banter" + str(random_index)] as Array[Dictionary]
			await handle_dialogue(dialogue)
		"thorn_ring":
			disappear_shop()
			dialogue_box.clear()
			background.modulate = Color(1.0, 0.559, 0.559, 1.0)
			ali.play_animation("thorn_ring")
			music.volume_linear = 0
			await Utils.sleep(3)
			background.modulate = Color(1.0, 1.0, 1.0, 1.0)
			ali.play_animation("idle")
			music.volume_linear = 1
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
	
	if is_shop_menu_open:
		shop_slide_animation_player.play("slide_in")
		ali_animation_player.play("slide_ali")
	else:
		shop_slide_animation_player.play("slide_out")
		ali_animation_player.play("unslide_ali")
	
	await shop_slide_animation_player.animation_finished


func disappear_shop() -> void:
	shop_fade_animation_player.play("fade_shop")
	toggle_shop(false)
	shop_menu.disable()


func appear_shop() -> void:
	shop_fade_animation_player.play_backwards("fade_shop")
	await shop_fade_animation_player.animation_finished
	shop_menu.enable()


func _on_shop_menu_item_clicked(item_name: String) -> void:
	handle_cutscene(CUTSCENE_TYPE.ITEM, item_name)


func handle_shop_item(item_name: String):
	var dialogue: Array = ItemData.item_data[item_name].dialogue
	await handle_dialogue(dialogue)


func handle_dialogue(dialogue: Array):
	ali.play_animation("talking")
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
	
	cursor_stopper.show()
	
	can_interact = false
	match cutscene_type:
		CUTSCENE_TYPE.ITEM:
			await handle_shop_item(key)
		CUTSCENE_TYPE.SEQUENCE:
			await handle_sequence(key)
	can_interact = true
	
	cursor_stopper.hide()
	# Resets the cursor after the cursor_stopper has disappeared.
	Input.parse_input_event(InputEventMouseMotion.new()) 


func _on_ali_sign_left_hand() -> void:
	sign_animation_player.play("throw_sign")
