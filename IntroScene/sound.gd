extends TextureButton

var music_playing: bool = true
var audio_stream_player

func _ready():
	scale = Vector2(0.1, 0.1)  # Scale down to 1/10th
	audio_stream_player = get_node("../AudioStreamPlayer")
	connect("pressed", Callable(self, "_on_sound_pressed"))  # Connect the pressed signal to the function

	if music_playing:
		audio_stream_player.play()
	else:
		audio_stream_player.stop()


func _on_sound_pressed():
	music_playing = not music_playing
	print("Button pressed. Music playing:", music_playing)

	if music_playing:
		print("Attempting to play music")
		audio_stream_player.play()  # Start playing music
	else:
		print("Attempting to stop music")
		audio_stream_player.stop()  # Stop playing music

	# Further debugging output
	print("AudioStreamPlayer is playing:", audio_stream_player.is_playing())


func _on_pressed():
	pass # Replace with function body.
