class_name DialogueBox extends Control

signal dialogue_finished

@onready var text_sound_menu: AudioStreamPlayer = %TextSoundMenu
@onready var text_sound_dialogue: AudioStreamPlayer = %TextSoundDialogue
@onready var face_sprite: AnimatedSprite2D = %FaceSprite
@onready var face_container: Control = %FaceContainer
@onready var text_container: VBoxContainer = %TextContainer

const STAR_AND_LABEL_CONTAINER = preload("uid://q7c7r2ubg0t0")
const MENU_FONT: FontFile = preload("uid://ca24jgg6u6rnm")
const DIALOGUE_FONT: FontFile = preload("uid://m8wplwpahs")
var FONT_THEME = preload("uid://ue26txsnqiv2")

var skip: bool = false

var current_container: StarAndLabelContainer


func show_text(text_properties: Dictionary):
	for child in text_container.get_children():
		child.queue_free()
	
	current_container = STAR_AND_LABEL_CONTAINER.instantiate()
	text_container.add_child(current_container)
	var type = text_properties.get("type")
	var text = text_properties.get("text")
	var face = text_properties.get("face")
	print(face)
	
	if face != null:
		show_face()
		face_sprite.play("talking")
	
	var font_to_use = MENU_FONT if type == "menu" else DIALOGUE_FONT
	FONT_THEME.default_font = font_to_use
	
	for character in text:
		if character != "\n":
			current_container.label.text += character
			match type:
				"menu":
					text_sound_menu.play()
				_:
					text_sound_dialogue.play()
		
		
		if not skip:
			match character:
				"!", ".", "?":
					await Utils.sleep(0.3)
				"\n":
					await Utils.sleep(0.3)
					current_container = STAR_AND_LABEL_CONTAINER.instantiate()
					text_container.add_child(current_container)
				_:
					await Utils.sleep(0.03)
	
	if face != null:
		face_sprite.play("idling")
	
	dialogue_finished.emit()


func set_skip(enabled: bool):
	skip = enabled


func clear() -> void:
	show_text({text = ""})
	hide_face()

func hide_face() -> void:
	face_container.hide()

func show_face() -> void:
	face_container.show()
