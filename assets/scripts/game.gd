class_name Game extends Node

@onready var ali_shop_button: Button = %AliShopButton
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var background: ColorRect = $Background
@onready var ali: Ali = $Ali
@onready var ali_animation_player: AnimationPlayer = %AliAnimationPlayer
@onready var shop_fade_animation_player: AnimationPlayer = %ShopFadeAnimationPlayer
@onready var shop_slide_animation_player: AnimationPlayer = %ShopSlideAnimationPlayer
@onready var shop_menu: ShopMenu = %ShopMenu
@onready var music: AudioStreamPlayer = $Music

var dialogue_resource = Dialogue.new()

var can_interact := true

enum CUTSCENE_TYPE {
	ITEM,
	SEQUENCE
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()


func _on_interactable_pressed(sequence_key: String) -> void:
	handle_cutscene(CUTSCENE_TYPE.SEQUENCE, sequence_key)


func handle_sequence(key: String):
	match key:
		"remove_sign":
			dialogue_box.show_text({text = "Gadzooks!"})
			background.color = Color(1.0, 0.881, 0.0, 1.0)
			ali.play_animation("removing_sign")
			await Utils.sleep(1)
			ali_shop_button.pressed.connect(_on_interactable_pressed.bind("emerge"), ConnectFlags.CONNECT_ONE_SHOT)
		"emerge":
			music.play()
			await ali.play_animation("emerging")
			appear_shop()
			ali.play_animation("idle")


func _on_shop_menu_toggle_shop() -> void:
	if not can_interact:
		return
	
	can_interact = false
	await toggle_shop()
	can_interact = true


var is_shop_menu_open


# Used when the open shop button is clicked
func toggle_shop(enabled = null) -> void:
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
	var dialogue: Array = dialogue_resource.dialogue[item_name]
	disappear_shop()
	await handle_dialogue(dialogue)
	appear_shop()
	dialogue_box.clear()


func handle_dialogue(dialogue: Array):
	for dialogue_data: Dictionary in dialogue:
		await dialogue_box.show_text(dialogue_data)
		await Utils.sleep(2)


func handle_cutscene(cutscene_type: CUTSCENE_TYPE, key: String):
	if not can_interact:
		return
	
	can_interact = false
	match cutscene_type:
		CUTSCENE_TYPE.ITEM:
			await handle_shop_item(key)
		CUTSCENE_TYPE.SEQUENCE:
			await handle_sequence(key)
	can_interact = true
