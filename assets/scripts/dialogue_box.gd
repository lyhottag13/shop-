class_name DialogueBox extends Control

signal dialogue_finished

@onready var label: Label = %Label
@onready var text_sound_menu: AudioStreamPlayer = %TextSoundMenu
@onready var text_sound_dialogue: AudioStreamPlayer = %TextSoundDialogue

var skip: bool = false

func show_text(text_properties: Dictionary):
	label.text = "* "
	for character in text_properties["text"]:
		match text_properties.get("type"):
			"dialogue":
				text_sound_dialogue.play()
			_:
				text_sound_menu.play()
		label.text += character
		if not skip:
			await Utils.sleep(0.03)
	dialogue_finished.emit()


func set_skip(enabled: bool):
	skip = enabled


func clear() -> void:
	show_text({text = ""})
