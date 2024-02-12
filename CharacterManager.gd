# CharacterManager.gd
extends Node

var characters_data = {}

func _ready():
	pass

func add_character_data(character_name: String, data: Dictionary) -> void:
	characters_data[character_name] = data

func get_character_data(character_name: String) -> Dictionary:
	return characters_data.get(character_name, {})

func randomize_stats_and_traits() -> Dictionary:
	var stats = ["Robotics and Automation", "Rocket Engineering", "Astronomy and Astrophysics", "Simulator Training"]
	var traits = ["Teamwork", "Determination", "Intelligence", "Attitude"]
	var data = {"stats": {}, "traits": {}}
	for stat in stats:
		data["stats"][stat] = randi() % 10  # Random number between 0 and 9
	for _trait in traits:
		data["traits"][_trait] = randi() % 10  # Random number between 0 and 9
	return data
