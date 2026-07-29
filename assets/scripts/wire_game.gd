extends Node2D

signal wires_finished

@onready var control: Control = $Control
const WIRE_TILES = preload("uid://c8epqq1s8h4cg")
const TILE_SIZE = 40
const POSSIBLE_ROTATIONS = 4
const ROTATION_AMOUNT = 90

var current_combo: Array[int] = []

func _ready() -> void:
	var index := 0
	for child in control.get_children():
		if child is TextureButton:
			var new_atlas_texture = AtlasTexture.new()
			new_atlas_texture.atlas = WIRE_TILES
			new_atlas_texture.region = Rect2(TILE_SIZE * index, 0, TILE_SIZE, TILE_SIZE)
			child.texture_normal = new_atlas_texture
			child.size = Vector2(TILE_SIZE, TILE_SIZE)
			child.position = Vector2(index * TILE_SIZE % 120, floori(index / 3.0) * TILE_SIZE)
			child.pressed.connect(_on_button_pressed.bind(index), CONNECT_APPEND_SOURCE_OBJECT)
			var random: int
			match index:
				4, 6:
					random = randi_range(0, POSSIBLE_ROTATIONS - 3)
				_:
					random = randi_range(0, POSSIBLE_ROTATIONS - 1)
					
			child.rotation_degrees = random *  ROTATION_AMOUNT
			current_combo.append(random)
			
			index += 1
	print(current_combo)

func _on_button_pressed(source: TextureButton, index: int) -> void:
	source.rotation_degrees += ROTATION_AMOUNT
	match index:
		4, 6:
			current_combo[index] = (current_combo[index] + 1) % 2
		_:
			current_combo[index] = (current_combo[index] + 1) % POSSIBLE_ROTATIONS
	print(current_combo)
	if current_combo.all(func(num: int) -> bool: return num == 0):
		wires_finished.emit()
		queue_free()
