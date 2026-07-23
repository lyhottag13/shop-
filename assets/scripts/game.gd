extends Node

@onready var ali_shop_button: Button = %AliShopButton
@onready var dialogue_box: DialogueBox = %DialogueBox

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _on_ali_shop_button_pressed() -> void:
	dialogue_box.show_text("Gadzooks!")
