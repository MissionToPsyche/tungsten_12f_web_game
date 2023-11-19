extends TextureButton

# Preload the scene
var scene = preload("res://decision_tree.tscn")

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	get_tree().change_scene_to(scene)
