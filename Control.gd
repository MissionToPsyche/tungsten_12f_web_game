extends Control

var buttonTypes = ["mystery", "marketing", "simulation", "ore"]  # Types of buttons
var positions = [Vector2(100, 100), Vector2(200, 100), Vector2(300, 100)]  # Positions for 3 buttons
var buttons = []  # This will store the actual button instances

func _ready():
	# Create button instances
	for i in range(3):  # Assuming you want 3 buttons at a time
		var button = Button.new()  # Change to TextureButton and set up textures if needed
		add_child(button)
		buttons.append(button)

	randomize_button_positions()

func randomize_button_positions():
	positions.shuffle()  # Randomize the order of the positions

	for i in range(buttons.size()):
		var button_type = buttonTypes[randi() % buttonTypes.size()]  # Randomly pick a button type
		var button = buttons[i]
		
		# Set up the button - position, text, etc.
		button.rect_position = positions[i]
		button.text = button_type.capitalize()  # Set the button's text to its type (optional)

		# Connect the button signal to a method (ensure this method exists and can handle the button type)
		button.disconnect("pressed", self, "_on_button_pressed")  # Disconnect previous connections to avoid duplicates
		button.connect("pressed", self, "_on_button_pressed", [button_type])
