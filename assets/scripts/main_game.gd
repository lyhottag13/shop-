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
@onready var transition: ColorRect = %Transition

var current_scene: Node

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_normal)
	Input.set_custom_mouse_cursor(cursor_wait, Input.CURSOR_WAIT)
	Input.set_custom_mouse_cursor(cursor_highlight, Input.CURSOR_POINTING_HAND)
	
	goto_scene(SHOP, false)
	var game_scene = current_scene as Game
	game_scene.goto_arcade.connect(_on_game_goto_arcade)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if not OS.has_feature("web"):
			get_tree().quit()
	elif event is InputEventMouseButton:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func goto_scene(new_scene: PackedScene, fade: bool = true):
	const FADE_TIME = 1
	CursorStopper.show()
	
	if fade:
		SoundManager.fade_background(1, 0)
		await create_tween().tween_property(transition, "color", Color(0.0, 0.0, 0.0, 1.0), FADE_TIME).finished
	
	if current_scene:
		current_scene.queue_free()
	
	SoundManager.clear_background()
	var s = new_scene.instantiate()
	world.add_child(s)
	current_scene = s
	
	if fade:
		if SoundManager.has_background():
			SoundManager.fade_background(0, 1)
		await create_tween().tween_property(transition, "color", Color(0.0, 0.0, 0.0, 0.0), FADE_TIME).finished
		
	CursorStopper.hide()


func _on_game_goto_arcade() -> void:
	await goto_scene(ARCADE)
	var arcade_scene = current_scene as Arcade
	arcade_scene.goto_arcade_machine.connect(_on_arcade_goto_arcade_machine)
	arcade_scene.goto_shop.connect(_on_goto_shop)


func _on_arcade_goto_arcade_machine() -> void:
	await goto_scene(ARCADE_MACHINE)

func _on_goto_shop() -> void:
	await goto_scene(SHOP)
	var shop_scene = current_scene as Game
	shop_scene.handle_sequence("remove_sign")
	shop_scene.goto_arcade.connect(_on_game_goto_arcade)
