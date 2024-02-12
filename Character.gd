# Character.gd
extends Sprite2D

func _ready():
	var data = CharacterManager.randomize_stats_and_traits()
	# Save data immediately using the node's name to ensure uniqueness
	CharacterManager.add_character_data(self.name, data)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Character chosen: ", self.name)
		var data = CharacterManager.get_character_data(self.name)
		print("Stats: ", data["stats"])
		print("Traits: ", data["traits"])
