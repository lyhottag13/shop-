class_name AudioManager
extends Node

@onready var _background_sound: AudioStreamPlayer = %BackgroundSound
@onready var sfx_container: Node = %SFXContainer
var _audio_stream_players: Array[AudioStreamPlayer] = []

const _BACKGROUNDS: Dictionary[String, AudioStream] = {
	ARCADE_AMBIENCE = preload("uid://d0mhtm4n3w37i"),
	ARCADE_MACHINE = preload("uid://co0435k64myon"),
	SHOP = preload("uid://m3doq8rl38fn"),
}

const _SOUNDS: Dictionary[String, AudioStream] = {
	WIRE_ROTATE = preload("uid://dslyrtdntrlv3"),
	MENU = preload("uid://bfmamerromkdh"),
	DIALOGUE = preload("uid://ccpi3m1uvrff5"),
	STATIC = preload("uid://bxuyin5j8xg6r"),
	ELECTRIC_SPARKS = preload("uid://c435pm2buah0f"),
	
}

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


func _on_background_sound_finished(source: AudioStreamPlayer) -> void:
	source.play()

func stop_background() -> void:
	_background_sound.stop()


func clear_background() -> void:
	_background_sound.stream = null


func has_background() -> bool:
	return _background_sound.stream != null


func print() -> void:
	print(_background_sound.stream)


func fade_background(start: float, end: float, duration: float = 1):
	_background_sound.volume_linear = start
	create_tween().tween_property(_background_sound, "volume_linear", end, duration)


func _real_play_sfx(stream: AudioStream) -> void:
	for sfx_player in _audio_stream_players:
		if not sfx_player.playing:
			sfx_player.stream = stream
			sfx_player.play()
			await sfx_player.finished
			return
	
	# Failsafe in case there aren't enough sfx_players
	print("Made a new SFX player!")
	var new_sfx_player = AudioStreamPlayer.new()
	sfx_container.add_child(new_sfx_player)
	new_sfx_player.stream = stream
	new_sfx_player.play()
	await new_sfx_player.finished
	_audio_stream_players.append(new_sfx_player)


func play_sfx(sfx_name: Constants.SFX):
	var sound_to_play: AudioStream
	match sfx_name:
		Constants.SFX.WIRE:
			sound_to_play = _SOUNDS.WIRE_ROTATE
		Constants.SFX.MENU:
			sound_to_play = _SOUNDS.MENU
		Constants.SFX.DIALOGUE:
			sound_to_play = _SOUNDS.DIALOGUE
		Constants.SFX.STATIC:
			sound_to_play = _SOUNDS.STATIC
		Constants.SFX.SPARKS:
			sound_to_play = _SOUNDS.ELECTRIC_SPARKS
	
	if sound_to_play == null:
		print("No SFX to play! Insert it into the play_sfx() method.")
		return
	
	await _real_play_sfx(sound_to_play)
