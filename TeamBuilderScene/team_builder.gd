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
var character_labels = []
var team_count = 0

func _ready() -> void:
	character_labels = [get_node("Panel1/Label1"), get_node("Panel2/Label2"), get_node("Panel3/Label3")]
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
	# Cleanup previous characters and labels if any
	for child in get_children():
		if child is Sprite2D or child is Label:
			remove_child(child)
			child.queue_free()

	# Display new characters and setup labels
	for i in range(sprites.size()):
		var sprite_info = sprites[i]
		# Construct the script path dynamically. Adjust the path as necessary.
		var script_path = "res://TeamBuilderScene/character" + str(i + 1) + ".gd"
		var character_script = load(script_path)

		# Create a new Sprite2D instance and assign the dynamically loaded script.
		var character = Sprite2D.new()
		character.set_script(character_script)
		character.texture = sprite_info["texture"]
		character.position = positions[i] + Vector2(1000, 0)  # Start off-screen to the right
		character.connect("sprite_selected", Callable(self, "_on_sprite_selected"))
		add_child(character)

		# Properly use create_tween() for character animation into position
		var tween = character.create_tween()
		# Animate the character's position
		tween.tween_property(character, "position", positions[i], 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		# Animate the character's modulate property for a fade-in effect
		# Assuming you want to fade to fully opaque, you would use a Color value here
		var target_color = Color(1, 1, 1, 1)  # Fully opaque white
		tween.tween_property(character, "modulate", target_color, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	adjust_label_positions()

func adjust_label_positions():
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	var y_position = screen_height / 3  # 1/3 down the screen in the Y direction

	for i in range(character_labels.size()):
		var x_position = screen_width * (i + 1) / 4  # Calculate 1/4, 1/2, and 3/4 positions for each label
		character_labels[i].position = Vector2(x_position - character_labels[i].size.x / 2, y_position)  # Center labels at their positions


func fade_labels_in_out(fade_in: bool):
	for label in character_labels:
		var end_alpha = 1.0 if fade_in else 0.0
		var tween = create_tween()
		tween.tween_property(label, "modulate:a", end_alpha, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.connect("tween_all_completed", Callable(self, "_on_labels_fade_completed"), fade_in)

func _on_sprite_selected(sprite_name: String):
	# Determine which label corresponds to the clicked sprite, for example:
	var label_index = selected_character_names.find(sprite_name)
	if label_index != -1:  # Found the corresponding label
		fade_labels_in_out(character_labels[label_index])
	else:
		print("Label for sprite not found")


