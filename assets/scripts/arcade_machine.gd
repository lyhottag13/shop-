extends Node2D

@onready var arcade_machine_hum: AudioStreamPlayer = $ArcadeMachineHum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_background(Constants.BACKGROUNDS.ARCADE_MACHINE)
