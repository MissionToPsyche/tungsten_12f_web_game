# Character.gd
extends Sprite2D

var stats = {
	"Robotics and Automation": 0,
	"Rocket Engineering": 0,
	"Astronomy and Astrophysics": 0,
	"Simulator Training": 0
}

var traits = {
	"Teamwork": 0,
	"Determination": 0,
	"Intelligence": 0,
	"Attitude": 0
}

func _ready():
	randomize_stats_and_traits()
	# Save data immediately
	CharacterManager.add_character_data(name, {"stats": stats, "traits": traits})

func randomize_stats_and_traits() -> void:
	for key in stats.keys():
		stats[key] = randi() % 10  # Random number between 0 and 9
	for key in traits.keys():
		traits[key] = randi() % 10  # Random number between 0 and 9

# Implement the logic for when the character is selected
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("character 3 chosen")
