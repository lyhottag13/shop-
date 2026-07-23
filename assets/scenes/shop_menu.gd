class_name ShopMenu extends Control

@onready var open_shop_button: Button = %OpenShopButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SHOP_MENU_LENGTH := 243

var is_showing := false

func _ready() -> void:
	pass

func _on_open_shop_button_pressed() -> void:
	if is_showing:
		animation_player.play("hide")
	else:
		animation_player.play("show")
	is_showing = !is_showing
