extends Control

signal wires_finished

func _on_wire_game_wires_finished() -> void:
	wires_finished.emit()
	queue_free()
