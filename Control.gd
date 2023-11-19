extends Control

var buttons = ["TextureButton1", "TextureButton2", "TextureButton3", "TextureButton4"]  # Adjust to your button node names
var positions = [Vector2(100, 100), Vector2(200, 100), Vector2(300, 100), Vector2(400, 100)]  # Replace with your desired positions

func _ready():
	randomize_button_positions()

func randomize_button_positions():
	positions.shuffle()  # Randomize the order of the positions
	for i in range(buttons.size()):
		var button = get_node(buttons[i]) as TextureButton  # Ensure you cast to TextureButton
		button.rect_position = positions[i]
