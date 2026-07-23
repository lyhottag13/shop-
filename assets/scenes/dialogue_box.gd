class_name DialogueBox extends Control

@onready var label: Label = %Label

func show_text(text: String) -> void:
	label.text = "* " + text
