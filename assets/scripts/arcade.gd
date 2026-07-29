class_name Arcade 
extends Node2D

signal screwdriver_collected

@onready var screwdriver_button: Button = $ScrewdriverButton
@onready var screws: Control = %Screws
@onready var wires_panel: Control = $WiresPanel

const PANEL_SIZE = Vector2(90, 50)
const MAX_SCREWS = 4

var screws_collected := 0
var is_screwdriver_collected := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_screwdriver_button_pressed(source: Button) -> void:
	source.queue_free()
	screwdriver_collected.emit()
	is_screwdriver_collected = true


func _on_screw_pressed(source: Button) -> void:
	if is_screwdriver_collected:
		source.queue_free()
		screws_collected += 1
		
		if screws_collected == MAX_SCREWS:
			var new_button := Button.new()
			new_button.size = PANEL_SIZE
			new_button.position = Vector2(196, 156)
			new_button.pressed.connect(open_wires_panel, CONNECT_APPEND_SOURCE_OBJECT)
			add_child(new_button)


func open_wires_panel(source: Button):
	source.queue_free()
	wires_panel.show()
