class_name DialogueBox extends Control

signal dialogue_finished

@onready var label: Label = %Label
@onready var text_sound_menu: AudioStreamPlayer = %TextSoundMenu
@onready var text_sound_dialogue: AudioStreamPlayer = %TextSoundDialogue
@onready var face_sprite: AnimatedSprite2D = %FaceSprite
@onready var face_container: Control = %FaceContainer

const MENU_FONT: FontFile = preload("uid://ca24jgg6u6rnm")
const DIALOGUE_FONT: FontFile = preload("uid://m8wplwpahs")

var skip: bool = false


func show_text(text_properties: Dictionary):
	label.text = ""
	var type = text_properties.get("type")
	var text = text_properties.get("text")
	var face = text_properties.get("face")
	print(face)
	
	if face != null:
		show_face()
		face_sprite.play("talking")
	
	
	if label.has_theme_font_override("font"):
		label.remove_theme_font_override("font")
	
	var font_to_use = DIALOGUE_FONT if type == "dialogue" else MENU_FONT
	label.add_theme_font_override("font", font_to_use)
	
	for character in text:
		match type:
			"dialogue":
				text_sound_dialogue.play()
			_:
				text_sound_menu.play()
		
		label.text += character
		
		if not skip:
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
