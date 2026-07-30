class_name MainGame
extends Node

#region CURSOR
const cursor_normal = preload("uid://favkw5srtb07")
const cursor_wait = preload("uid://cg7qrew34rpr")
const cursor_highlight = preload("uid://h8vim3ghdnwp")
#endregion


const GAME: PackedScene = preload("uid://d36g6yvqkag6g")
const ARCADE: PackedScene = preload("uid://cj7mcrd10qgs")
const ARCADE_MACHINE: PackedScene = preload("uid://rjpjapc8643p")

@onready var world: Node2D = %World
@onready var transition: ColorRect = %Transition

var current_scene: Node

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_normal)
	Input.set_custom_mouse_cursor(cursor_wait, Input.CURSOR_WAIT)
	Input.set_custom_mouse_cursor(cursor_highlight, Input.CURSOR_POINTING_HAND)
	
	goto_scene(GAME, false)
	var game_scene = current_scene as Game
	game_scene.goto_arcade.connect(_on_game_goto_arcade)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	elif event is InputEventMouseButton:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func goto_scene(new_scene: PackedScene, fade: bool = true):
	const FADE_TIME = 1
	if fade:
		var out_tween = create_tween().tween_property(transition, "color", Color(0.0, 0.0, 0.0, 1.0), FADE_TIME)
		await out_tween.finished
	if current_scene:
		current_scene.queue_free()
	var s = new_scene.instantiate()
	world.add_child(s)
	current_scene = s
	if fade:
		var in_tween = create_tween().tween_property(transition, "color", Color(0.0, 0.0, 0.0, 0.0), FADE_TIME)
		await in_tween.finished


func _on_game_goto_arcade() -> void:
	await goto_scene(ARCADE)
	var arcade_scene = current_scene as Arcade
	arcade_scene.goto_arcade_machine.connect(_on_arcade_goto_arcade_machine)


func _on_arcade_goto_arcade_machine() -> void:
	await goto_scene(ARCADE_MACHINE)
