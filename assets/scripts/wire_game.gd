extends Control

signal wires_finished

const TILE_SIZE = 35
const POSSIBLE_ROTATIONS = 4
const ROTATION_AMOUNT = 90
const LENGTH = 3
const HEIGHT = 4
const STARTING_X = 140
const STARTING_Y = 35
const ARCADE_WIRE_PUZZLE_TILES = preload("uid://daya30hjmffvp")

@onready var tile_container: Control = $TileContainer
var current_combo: Array[int] = []

func _ready() -> void:
	var index := 0
	for i in range(HEIGHT):
		for j in range(LENGTH):
			var new_atlas_texture = AtlasTexture.new()
			new_atlas_texture.atlas = ARCADE_WIRE_PUZZLE_TILES
			new_atlas_texture.region = Rect2(TILE_SIZE * j, TILE_SIZE * i, TILE_SIZE, TILE_SIZE)
			
			var new_tile = TextureButton.new()
			new_tile.texture_normal = new_atlas_texture
			new_tile.pivot_offset_ratio = Vector2(0.5, 0.5)
			new_tile.position = Vector2(TILE_SIZE * j, TILE_SIZE * i)
			new_tile.pressed.connect(_on_button_pressed.bind(index), CONNECT_APPEND_SOURCE_OBJECT)
			var random: int
			match index:
				0:
					random = randi_range(0, POSSIBLE_ROTATIONS - 3)
				_:
					random = randi_range(0, POSSIBLE_ROTATIONS - 1)
					
			new_tile.rotation_degrees = random *  ROTATION_AMOUNT
			
			current_combo.append(random)
			tile_container.add_child(new_tile)
			index += 1
	print(current_combo)

func _on_button_pressed(source: TextureButton, index: int) -> void:
	SoundManager.play_sfx(Constants.SFX.WIRE)
	
	source.rotation_degrees = ceilf(source.rotation_degrees / 90) * 90 # Keeps the tile in perfect 90 degree increments
	create_tween().tween_property(source, "rotation_degrees", source.rotation_degrees + ROTATION_AMOUNT, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	match index:
		0:
			current_combo[index] = (current_combo[index] + 1) % 2
		_:
			current_combo[index] = (current_combo[index] + 1) % POSSIBLE_ROTATIONS
		
	if current_combo.all(func(num: int) -> bool: return num == 0):
		await SoundManager.play_sfx(Constants.SFX.SPARKS)
		wires_finished.emit()
		queue_free()
