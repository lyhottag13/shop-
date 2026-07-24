class_name Ali extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("closed")

func play_animation(animation_name: String):
	animated_sprite_2d.play(animation_name)
