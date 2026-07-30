extends Node2D

@onready var arcade_machine_hum: AudioStreamPlayer = $ArcadeMachineHum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arcade_machine_hum.volume_linear = 0
	arcade_machine_hum.play()
	create_tween().tween_property(arcade_machine_hum, "volume_linear", 1, 0.3)
