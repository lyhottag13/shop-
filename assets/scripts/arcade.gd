class_name Arcade 
extends Node2D

signal screwdriver_collected
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
	SoundManager.play_background(Constants.BACKGROUNDS.ARCADE_AMBIENCE)
	await Utils.sleep(1)
	
	const ENDING_POSITION = Vector2(17, 220)
	create_tween().tween_property(goto_shop_button, "position", ENDING_POSITION, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)



func _on_screwdriver_button_pressed(source: Button) -> void:
	source.pressed.disconnect(_on_screwdriver_button_pressed)
	screwdriver_collected.emit()
	is_screwdriver_collected = true
	var new_position = Vector2(source.position) + Vector2(0, -20)
	await create_tween().tween_property(source, "position", new_position, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).finished
	source.queue_free()


func _on_screw_pressed(source: Button) -> void:
	if is_screwdriver_collected:
		source.pressed.disconnect(_on_screw_pressed)
		const UNSCREW_TIME = 1
		const DESIRED_SCALE = 1.4
		create_tween().tween_property(source, "rotation_degrees", 720, UNSCREW_TIME)
		await create_tween().tween_property(source, "scale", Vector2(DESIRED_SCALE, DESIRED_SCALE), UNSCREW_TIME).finished
		
		const DEVIATION = 20
		const TWEEN_TIME = 1
		var random_x: int = DEVIATION * [-1, 1].pick_random()
		var new_position := source.position + Vector2(random_x, 200)
		create_tween().tween_property(source, "position:x", new_position.x, TWEEN_TIME)
		create_tween().tween_property(source, "position:y", new_position.y, TWEEN_TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		
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
