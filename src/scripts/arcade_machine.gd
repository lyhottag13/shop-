class_name ArcadeMachine
extends Node2D

signal goto_arcade_pressed

@onready var goto_arcade_button: TextureButton = $GotoArcade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_background(Constants.BACKGROUNDS.ARCADE_MACHINE)
	await Utils.sleep(1)
	create_tween().tween_property(goto_arcade_button, "position:y", goto_arcade_button.position.y - 50, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_goto_arcade_pressed() -> void:
	goto_arcade_pressed.emit()
