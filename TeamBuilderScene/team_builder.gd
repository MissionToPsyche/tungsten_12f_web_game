extends Node2D

# Assuming you have a predefined list of character names
var character_names := ["Alexa", "Andrew", "Ava", "Caleb", "Carter", "Emma", "Haley", "Hannah", "John", "Jordan", "Nick"]

# Path to character sprites
var sprite_path = "res://assets/sprites/team_builder_sprites/"
var screen_positions = [Vector2(), Vector2(), Vector2()]  # Placeholder for screen positions to be calculated
var team_members_chosen := 0
var chosen_characters = []
var ignore_clicks = false

func _ready():
	$TeamStatus.text = "Team Members: " + str(team_members_chosen) + "/3"
	display_random_characters()

func display_random_characters():
	# Shuffle the array of names in-place
	character_names.shuffle()
	
	# Clear previous characters if any
	var hbox_container = $CharactersContainer
	hbox_container.queue_free_children()  # Custom function to free children
	# Load and instance the first 3 characters after shuffling
	for i in range(3):
		var character_name = character_names[i]
		var character_instance = preload("res://character.tscn").instantiate()
		character_instance.character_name = character_name  # Set character's name
		
		# Optionally set the character sprite based on the character name if necessary
		var sprite = character_instance.get_node("CharacterSprite")  # Adjust path as necessary
		sprite.texture = load(sprite_path + character_name + ".png")
		
		var character_label = character_instance.get_node("CharacterLabel")
		character_label.text = character_name
		
		set_character_position_and_size(character_instance, i)
		
		character_instance.sprite_selected.connect(_on_character_selected)
		# Add the character instance to the HBoxContainer
		hbox_container.add_child(character_instance)

func _on_character_selected(name, info):
		team_members_chosen += 1
		$TeamStatus.text = "Team Members: " + str(team_members_chosen) + "/3"
		chosen_characters.append(info)
		character_names.erase(name)
		if team_members_chosen < 3:
			display_random_characters()
		else:
			var hbox_container = $CharactersContainer
			hbox_container.queue_free_children()
			var character_index = 0
			for character_info in chosen_characters:
				var character_instance = preload("res://character.tscn").instantiate()
				character_instance.character_name = character_info["name"]
				var sprite = character_instance.get_node("CharacterSprite")
				sprite.texture = load(sprite_path + character_info["name"] +".png")
				
				var character_label = character_instance.get_node("CharacterLabel")
				character_label.text = character_info["name"]
				
				
				set_character_position_and_size(character_instance, character_index)
				hbox_container.add_child(character_instance)
				character_index += 1
			
			Global.set_input_allowed(false) #no clicking
			# Show congratulations message and transition to next scene after delay
			$ConfirmationLabel.text = "Congratulations, you have your team"
			$ConfirmationLabel.show()
			await get_tree().create_timer(3.0).timeout
			Global.set_input_allowed(true)
			get_tree().change_scene_to_file("res://DecesionTreeScene/decision_tree.tscn")
			#completion label and switch scenes

func set_character_position_and_size(character_instance, position_index):
	var screen_size = get_viewport_rect().size
	var target_height = screen_size.y / 2
	var sprite = character_instance.get_node("CharacterSprite")

	# Calculate and apply scale to maintain aspect ratio and match target height
	var scale_factor = target_height / sprite.texture.get_height()
	sprite.scale = Vector2(scale_factor, scale_factor)

	# Set the position based on the index
	var positions = [
		Vector2(screen_size.x / 4, screen_size.y / 2),
		Vector2(screen_size.x / 2, screen_size.y / 2),
		Vector2(screen_size.x * 3 / 4, screen_size.y / 2)
	]
	character_instance.position = positions[position_index]
