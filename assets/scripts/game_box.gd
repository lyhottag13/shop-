class_name GameBox
extends MarginContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

var link: String


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if OS.has_feature("web"):
				JavaScriptBridge.eval('window.location.href = "' + link + '"')
			else:
				OS.shell_open(link)


func set_image(texture: CompressedTexture2D):
	texture_rect.texture = texture


func set_text(text: String):
	label.text = text


func set_link(link: String):
	self.link = link


func _on_mouse_entered() -> void:
	label.add_theme_color_override("font_color", Color(0.969, 1.0, 0.0, 1.0))

func _on_mouse_exited() -> void:
	label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
