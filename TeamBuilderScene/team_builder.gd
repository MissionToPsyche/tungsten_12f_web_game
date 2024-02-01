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
var character_labels = [$Panel1/Label1, $Panel2/Label2, $Panel3/Label3]
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
	# Cleanup previous characters and labels if any
	for child in get_children():
		if child is Sprite2D or child is Label:
			remove_child(child)
			child.queue_free()

	# Display new characters and setup labels
	for i in range(sprites.size()):
		var sprite_info = sprites[i]
		var character = Sprite2D.new()
		character.texture = sprite_info["texture"]
		character.position = positions[i] + Vector2(1000, 0)  # Start off-screen to the right
		add_child(character)

		# Tween for character animation into position
		var tween = create_tween()
		add_child(tween)
		
		tween.interpolate_property(character, "position", 
			character.position, positions[i], 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

		# Setup labels for each character
		var label = character_labels[i]
		label.text = "%s\nStrength: %d\nIntelligence: %d" % [sprite_info["name"], sprite_info["stats"]["Strength"], sprite_info["stats"]["Intelligence"]]
		label.modulate = Color(label.modulate.r, label.modulate.g, label.modulate.b, 0)  # Start transparent
		# Tween for label fade in
		tween.interpolate_property(label, "modulate", 
			Color(label.modulate.r, label.modulate.g, label.modulate.b, 0), 
			Color(label.modulate.r, label.modulate.g, label.modulate.b, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)  # Delay start to sync with character arrival
		tween.start()
