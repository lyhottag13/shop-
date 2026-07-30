extends Node

#region CURSOR
const cursor_normal = preload("uid://favkw5srtb07")
const cursor_wait = preload("uid://cg7qrew34rpr")
const cursor_highlight = preload("uid://h8vim3ghdnwp")
#endregion

var current_scene: Node

const GAME: PackedScene = preload("uid://d36g6yvqkag6g")
const ARCADE: PackedScene = preload("uid://cj7mcrd10qgs")
const ARCADE_MACHINE: PackedScene = preload("uid://rjpjapc8643p")

@onready var world: Node2D = %World

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_normal)
	Input.set_custom_mouse_cursor(cursor_wait, Input.CURSOR_WAIT)
	Input.set_custom_mouse_cursor(cursor_highlight, Input.CURSOR_POINTING_HAND)
	current_scene = world.get_child(0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	elif event is InputEventMouseButton:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func goto_scene(new_scene: PackedScene):
	current_scene.queue_free()
	var s = new_scene.instantiate()
	world.add_child(s)
	current_scene = s


func _on_game_goto_arcade() -> void:
	goto_scene(ARCADE)
	var arcade_scene = current_scene as Arcade
	arcade_scene.goto_arcade_machine.connect(_on_arcade_goto_arcade_machine)


func _on_arcade_goto_arcade_machine() -> void:
	goto_scene(ARCADE_MACHINE)
