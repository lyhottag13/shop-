extends Node2D

@onready var button: Button = $Button

var is_held = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if is_held:
		button.position = get_viewport().get_mouse_position()
	else:
		button.position = Vector2(0, 0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_held:
			button.position = event.position


func _on_button_button_down() -> void:
	is_held = true


func _on_button_button_up() -> void:
	is_held = false
