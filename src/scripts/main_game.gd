class_name MainGame
extends Node

#region CURSOR
const cursor_normal = preload("uid://favkw5srtb07")
const cursor_wait = preload("uid://cg7qrew34rpr")
const cursor_highlight = preload("uid://h8vim3ghdnwp")
#endregion


const SHOP: PackedScene = preload("uid://d36g6yvqkag6g")
const ARCADE: PackedScene = preload("uid://cj7mcrd10qgs")
const ARCADE_MACHINE: PackedScene = preload("uid://rjpjapc8643p")

@onready var world: Node2D = %World
@onready var transition: TextureRect = %Transition

var current_scene: Node2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_normal)
	Input.set_custom_mouse_cursor(cursor_wait, Input.CURSOR_WAIT)
	Input.set_custom_mouse_cursor(cursor_highlight, Input.CURSOR_POINTING_HAND)
	
	goto_scene(SHOP, false)
	if current_scene is Shop:
		current_scene.goto_arcade.connect(_on_game_goto_arcade)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if not OS.has_feature("web"):
			get_tree().quit()
	elif event is InputEventMouseButton:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func goto_scene(new_scene: PackedScene, fade: bool = true):
	const FADE_TIME = 0.7
	const SCENE_FADE_DISTANCE = 30
	const SCENE_TRANS = Tween.TRANS_QUAD
	const SCENE_EASE_START = Tween.EASE_IN
	const SCENE_EASE_END = Tween.EASE_OUT
	CursorStopper.show()
	
	if fade:
		SoundManager.fade_background(1, 0)
		transition.position.x = 650
		create_tween().tween_property(world, "position:x", -SCENE_FADE_DISTANCE, FADE_TIME).set_ease(SCENE_EASE_START).set_trans(SCENE_TRANS)
		await create_tween().tween_property(transition, "position:x", -75, FADE_TIME).set_ease(SCENE_EASE_START).set_trans(SCENE_TRANS).finished
		
	if current_scene:
		current_scene.queue_free()
	
	SoundManager.clear_background()
	var s = new_scene.instantiate()
	world.add_child(s)
	current_scene = s
	
	if fade:
		if SoundManager.has_background():
			SoundManager.fade_background(0, 1)
		world.position.x = SCENE_FADE_DISTANCE
		create_tween().tween_property(world, "position:x", 0, FADE_TIME).set_ease(SCENE_EASE_END).set_trans(SCENE_TRANS)
		await create_tween().tween_property(transition, "position:x",-650, FADE_TIME).set_ease(SCENE_EASE_END).set_trans(SCENE_TRANS).finished
	
	CursorStopper.hide()


func _on_game_goto_arcade() -> void:
	await goto_scene(ARCADE)
	if current_scene is Arcade:
		current_scene.goto_arcade_machine.connect(_on_arcade_goto_arcade_machine)
		current_scene.goto_shop.connect(_on_goto_shop)


func _on_arcade_goto_arcade_machine() -> void:
	await goto_scene(ARCADE_MACHINE)
	if current_scene is ArcadeMachine:
		current_scene.goto_arcade_pressed.connect(_on_game_goto_arcade)

func _on_goto_shop() -> void:
	await goto_scene(SHOP)
	if current_scene is Shop:
		current_scene.handle_sequence("remove_sign")
		current_scene.goto_arcade.connect(_on_game_goto_arcade)


func _fade_to_left_first_half() -> void:
	pass
