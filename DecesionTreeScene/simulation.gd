extends TextureButton  # Assuming you're using TextureButton

# Path to the scene that should be loaded when this button is clicked
var scene_path = "res://path_to_your_scene.tscn"

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	get_tree().change_scene(scene_path)
