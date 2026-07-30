class_name GameBox
extends MarginContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

var link: String


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			OS.shell_open(link)


func set_image(texture: CompressedTexture2D):
	texture_rect.texture = texture


func set_text(text: String):
	label.text = text


func set_link(link: String):
	self.link = link
