class_name Ali extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("closed")

func play_animation(animation_name: String):
	match animation_name:
		"emerging":
			animated_sprite_2d.offset.y = -142.5
		_:
			animated_sprite_2d.offset.y = -66
	animated_sprite_2d.play(animation_name)
	await animated_sprite_2d.animation_finished
