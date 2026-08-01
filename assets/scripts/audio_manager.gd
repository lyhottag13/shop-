class_name AudioManager
extends Node

@onready var _background_sound: AudioStreamPlayer = %BackgroundSound
var _audio_stream_players: Array[AudioStreamPlayer] = []

const _BACKGROUNDS: Dictionary[String, AudioStream] = {
	ARCADE_AMBIENCE = preload("uid://d0mhtm4n3w37i"),
	ARCADE_MACHINE = preload("uid://co0435k64myon"),
	SHOP = preload("uid://m3doq8rl38fn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			_audio_stream_players.append(child)


func play_background(sound_name: Constants.BACKGROUNDS):
	var sound_to_play: AudioStream
	
	match sound_name:
		Constants.BACKGROUNDS.SHOP:
			sound_to_play = _BACKGROUNDS.SHOP
		Constants.BACKGROUNDS.ARCADE_AMBIENCE:
			sound_to_play = _BACKGROUNDS.ARCADE_AMBIENCE
		Constants.BACKGROUNDS.ARCADE_MACHINE:
			sound_to_play = _BACKGROUNDS.ARCADE_MACHINE
	
	_background_sound.stream = sound_to_play
	_background_sound.play()
	_background_sound.volume_linear = 0
	create_tween().tween_property(_background_sound, "volume_linear", 1, 1)


func _on_background_sound_finished(source: AudioStreamPlayer) -> void:
	source.play()

func stop_background() -> void:
	_background_sound.stop()
