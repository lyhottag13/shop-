class_name Arcade 
extends Node2D

signal screwdriver_collected
signal wires_finished
signal goto_arcade_machine
signal goto_shop

const PANEL_SIZE = Vector2(90, 50)
const MAX_SCREWS = 4

@onready var screwdriver_button: Button = $ScrewdriverButton
@onready var screws: Control = %Screws
@onready var wires_panel: Control = $WiresPanel
@onready var goto_shop_button: TextureButton = %GotoShopButton

var screws_collected := 0
var is_screwdriver_collected := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	const ENDING_POSITION = Vector2(17, 220)
	create_tween().tween_property(goto_shop_button, "position", ENDING_POSITION, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)



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


func _on_wires_panel_wires_finished() -> void:
	goto_arcade_machine.emit()


func _on_goto_shop_button_pressed() -> void:
	goto_shop.emit()
