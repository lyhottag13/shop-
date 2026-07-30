class_name ArcadeSelector
extends Control

const GAME_BOX = preload("uid://c1omgjifhm7wc")

@onready var v_box_container: VBoxContainer = %VBoxContainer

func _ready() -> void:
	for game_data: Dictionary in ArcadeGames.games:
		var new_game_box = GAME_BOX.instantiate()
		v_box_container.add_child(new_game_box)
		new_game_box.set_image(game_data.image)
		new_game_box.set_text(game_data.title)
		new_game_box.set_link(game_data.link)
