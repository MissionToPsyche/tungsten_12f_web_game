extends Node2D

# Preload sprite textures and their corresponding names and stats
var sprite_scenes = [
	{"texture": preload("res://assets/sprites/team_builder_sprites/Alexa.png"), "name": "Alexa", "stats": {"Strength": 10, "Intelligence": 8}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Alexandra.png"), "name": "Alexandra", "stats": {"Strength": 9, "Intelligence": 9}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Andrew.png"), "name": "Andrew", "stats": {"Strength": 8, "Intelligence": 10}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Ava.png"), "name": "Ava", "stats": {"Strength": 7, "Intelligence": 9}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Caleb.png"), "name": "Caleb", "stats": {"Strength": 6, "Intelligence": 8}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Carter.png"), "name": "Carter", "stats": {"Strength": 8, "Intelligence": 7}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Emma.png"), "name": "Emma", "stats": {"Strength": 5, "Intelligence": 9}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Hannah.png"), "name": "Hannah", "stats": {"Strength": 9, "Intelligence": 6}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/John.png"), "name": "John", "stats": {"Strength": 7, "Intelligence": 8}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Jordan.png"), "name": "Jordan", "stats": {"Strength": 8, "Intelligence": 7}},
	{"texture": preload("res://assets/sprites/team_builder_sprites/Nick.png"), "name": "Nick", "stats": {"Strength": 10, "Intelligence": 5}}
]

var selected_character_names = []
var all_sprites = []
var team_count = 0

func _ready() -> void:
	display_initial_characters()


func calculate_positions() -> Array:
	var screen_width = get_viewport_rect().size.x
	return [
		Vector2(screen_width / 4, get_viewport_rect().size.y / 2),
		Vector2(screen_width / 2, get_viewport_rect().size.y / 2),
		Vector2(3 * screen_width / 4, get_viewport_rect().size.y / 2)
	]

func pick_random_sprites(amount: int) -> Array:
	var picked = []
	var available_indices = Array(range(sprite_scenes.size()))
	while picked.size() < amount:
		var index = available_indices[randi() % available_indices.size()]
		available_indices.erase(index)
		picked.append(sprite_scenes[index])
	return picked

func display_initial_characters():
	var positions = calculate_positions()
	var selected_sprites = pick_random_sprites(3)
	display_sprites(selected_sprites, positions)

func display_sprites(sprites: Array, positions: Array) -> void:
	# Cleanup previous character nodes if any
	for child in get_children():
		if child is Node2D:  # Check if it's the kind of Node2D we're using for characters
			remove_child(child)
		child.queue_free()
	all_sprites.clear()  # Adjust this as necessary for your new structure

	# Display new characters and setup labels
	for i in range(sprites.size()):
		var sprite_info = sprites[i]
		var character_node = Node2D.new()
		add_child(character_node)

		# Create and configure the sprite
		var character_sprite = Sprite2D.new()
		character_sprite.texture = sprite_info["texture"]
		# Load and assign the script dynamically based on the character's name
		var script_path = "res://TeamBuilderScene/character" + str(i + 1) + ".gd"
		character_sprite.set_script(load(script_path))
		character_node.add_child(character_sprite)
		character_sprite.sprite_selected.connect(_on_character_selected)

		await get_tree().process_frame
		var character_info = character_sprite.call("get_character_info")
		print("Character info for sprite: ", character_info)

		# Create and configure the label
		var character_label = Label.new()
		# Combine name and stats into the label text
		var stats_text = character_stats_to_text(character_info["stats"])  # Convert stats to text
		character_label.text = character_info["name"] + "\n" + stats_text
		character_node.add_child(character_label)
		character_label.global_position = Vector2(0, 350)  # Position label above sprite

		# Initial position off-screen to the right
		character_node.position = positions[i] + Vector2(1000, 0)

		# Use Godot 4's tween system for the animation
		var tween: = character_node.create_tween()
		tween.tween_property(character_node, "position", positions[i], 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		# If you want to animate the modulate property for a fade-in effect
		var target_color = Color(1, 1, 1, 1)  # Fully opaque white
		tween.tween_property(character_node, "modulate", target_color, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

		# Optionally, store a reference to the character_node for future use
		all_sprites.append(character_node)  # Consider adjusting 'all_sprites' as needed


func _on_character_selected(character_name: String, character_info: Dictionary) -> void:
	# Assuming there's a way to identify which label corresponds to the selected sprite,
	# For example, if labels are stored in an array or if you can identify them by name or position.
	for character_node in all_sprites:
		var label = character_node.get_node(("/team_builder/Node2D" + str(character_node+1) + "/Label"))#error here
		if label:  # If the label is found
			var stats_text = character_stats_to_text(character_info["stats"])
			label.text = character_name + "\n" + stats_text


func animate_sprites_off_screen():
	for sprite in all_sprites:
		var tween = sprite.create_tween()
		tween.tween_property(sprite, "position", sprite.position - Vector2(1000, 0), 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


var tweens_completed = 0

func _on_sprites_off_screen(_tween, _key):
	tweens_completed += 1
	if tweens_completed == all_sprites.size():
		tweens_completed = 0  # Reset the counter for the next round
		display_initial_characters()  # Load and display new characters

func find_sprite_index(character_name: String) -> int:
	for i in range(all_sprites.size()):
		if all_sprites[i].name == character_name:
			return i
	return -1 

func character_stats_to_text(stats: Dictionary) -> String:
	var stats_text = ""
	for key in stats.keys():
		stats_text += key + ": " + str(stats[key]) + "\n"
	return stats_text
