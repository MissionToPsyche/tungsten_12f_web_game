extends Node2D

# Preload sprite scenes or textures
var sprite_scenes = [preload("res://assets/sprites/team_builder_sprites/Alexa.png"), 
preload("res://assets/sprites/team_builder_sprites/Alexandra.png"), 
preload("res://assets/sprites/team_builder_sprites/Andrew.png"), 
preload("res://assets/sprites/team_builder_sprites/Ava.png"), 
preload("res://assets/sprites/team_builder_sprites/Caleb.png"), 
preload("res://assets/sprites/team_builder_sprites/Carter.png"), 
preload("res://assets/sprites/team_builder_sprites/Emma.png"), 
preload("res://assets/sprites/team_builder_sprites/Hannah.png"), 
preload("res://assets/sprites/team_builder_sprites/John.png"), 
preload("res://assets/sprites/team_builder_sprites/Jordan.png"), 
preload("res://assets/sprites/team_builder_sprites/Nick.png")]

# Position for sprites on screen
var positions = [Vector2(100, 200), Vector2(300, 200), Vector2(500, 200)]

# Structure to hold sprite data
class SpriteData:
	var instance
	var money
	var materials
	var science

func _ready():
	var selected_sprites = pick_random_sprites(3)
	display_sprites(selected_sprites)

func pick_random_sprites(amount):
	var picked = []
	var available_indices = range(sprite_scenes.size())

	for i in range(amount):
		var index = available_indices[randi() % available_indices.size()]
		available_indices.erase(index)
		var data = SpriteData.new()
		data.instance = sprite_scenes[index].instance()
		data.money = randi() % 100 # Randomize as per your stat range
		data.materials = randi() % 100
		data.science = randi() % 100
		picked.append(data)

	return picked

func display_sprites(sprites):
	for i in range(sprites.size()):
		var sprite = sprites[i].instance
		sprite.position = positions[i]
		add_child(sprite)
		# Display stats or store them as needed
