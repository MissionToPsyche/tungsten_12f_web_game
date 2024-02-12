extends Sprite2D

# Ensure to declare the signal in the script with the correct parameters
signal sprite_selected(name, stats)

# Character-specific information
var character_name := "Nick"
# Randomly generate character stats
var character_stats := {"Strength": randi() % 5, "Intelligence": randi() % 5}

func _ready():
	# Ensure the sprite can receive input events
	set_process_input(true)
	# Defer setting the Sprite's name property to avoid errors during parent setup
	call_deferred("set_name", character_name)
	# Initialize the random number generator
	randomize()

# Method to get character information, returning both name and stats
func get_character_info() -> Dictionary:
	return {"name": character_name, "stats": character_stats}

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Mouse button clicked")  # Debug print
		if get_rect().has_point(to_local(event.position)):
			print("Inside sprite rect: ", character_name)  # Debug print
			emit_signal("sprite_selected", character_name, get_character_info())
