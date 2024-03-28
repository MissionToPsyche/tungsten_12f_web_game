extends Node2D

# Assuming you have a predefined list of character names
var character_names := ["Alexa", "Andrew", "Ava", "Caleb", "Carter", "Emma", "Haley", "Hannah", "John", "Jordan", "Nick"]

# Path to character sprites
var sprite_path = "res://assets/sprites/team_builder_sprites/"
var screen_positions = [Vector2(), Vector2(), Vector2()]  # Placeholder for screen positions to be calculated
var team_members_chosen := 0
var chosen_characters = []
var chosen_skill_frames = []
var ignore_clicks = false
var vibration_enabled = true

func _ready():
	$TeamStatusContainer/TeamStatus.text = "Team Members: " + str(team_members_chosen) + "/3"
	$ConfirmationContainer.show()
	animate_confirmation_label("You can click on a player to add them to your team.")
	display_random_characters()

func animate_confirmation_label(text):
	var typing_speed = 0.05
	$ConfirmationContainer/ConfirmationLabel.visible_characters = 0
	$ConfirmationContainer/ConfirmationLabel.text = text
	for i in range(text.length()):
		$ConfirmationContainer/ConfirmationLabel.visible_characters = i + 1
		await get_tree().create_timer(typing_speed).timeout


func display_random_characters():
	# Shuffle the array of names in-place
	character_names.shuffle()
	
	# Clear previous characters if any
	var hbox_container = $CharactersContainer
	hbox_container.queue_free_children()
	# Load and instance the first 3 characters after shuffling
	for i in range(3):
		var character_name = character_names[i]
		var character_instance = preload("res://character.tscn").instantiate()
		character_instance.character_name = character_name  # Set character's name
		
		var sprite = character_instance.get_node("CharacterSprite")
		sprite.texture = load(sprite_path + character_name + ".png")
		var character_label = character_instance.get_node("CharacterLabel")
		character_label.text = character_name
		
		set_character_position_and_size(character_instance, i)
		character_instance.sprite_selected.connect(_on_character_selected)
		hbox_container.add_child(character_instance)
		
		if vibration_enabled:
			start_vibration(character_instance, i)

func start_vibration(character_instance, index):
	await get_tree().create_timer(index).timeout
	while true and vibration_enabled:
		if is_instance_valid(character_instance):
			character_instance.rotation_degrees = -5
			await get_tree().create_timer(0.2).timeout

		if is_instance_valid(character_instance):
			character_instance.rotation_degrees = 10
			await get_tree().create_timer(0.2).timeout

		if is_instance_valid(character_instance):
			character_instance.rotation_degrees = -5
			await get_tree().create_timer(0.2).timeout

		if is_instance_valid(character_instance):
			character_instance.rotation_degrees = 0
			await get_tree().create_timer(9.4).timeout
		else:
			break

func _on_character_selected(name, info):
	vibration_enabled = false
	team_members_chosen += 1
	$ConfirmationContainer.hide()
	$TeamStatusContainer/TeamStatus.text = "Team Members: " + str(team_members_chosen) + "/3"
	chosen_characters.append(info)
	character_names.erase(name)
	var skill_frames = [info["skill1_frame"], info["skill2_frame"]]
	print("Chosen character:", name)
	print("Skill frames:", skill_frames)
	chosen_skill_frames.append(skill_frames)
	print("Chosen skill frames:", chosen_skill_frames)
	if team_members_chosen < 3:
		display_random_characters()
	else:
		var hbox_container = $CharactersContainer
		hbox_container.queue_free_children()
		var character_index = 0
		print("Displaying final team")
		print("Chosen characters:", chosen_characters)
		for i in range(3):

			var character_info = chosen_characters[i]
			var character_instance = preload("res://character.tscn").instantiate()
			character_instance.character_name = character_info["name"]
			character_instance.character_stats = character_info["stats"]
			
			character_instance.Skill1 = character_instance.get_node("Skill1")
			character_instance.Skill2 = character_instance.get_node("Skill2")
			
			character_instance.Skill1.frame = character_info["skill1_frame"]
			character_instance.Skill2.frame = character_info["skill2_frame"]
			character_instance.update_skill_labels_final(character_info["skill1_frame"], character_info["skill2_frame"])
			character_instance.is_final_display = true
			add_child(character_instance)

			print("Character instance created for:", character_info["name"])
			print("Skill1 frame:", character_instance.Skill1.frame)
			print("Skill2 frame:", character_instance.Skill2.frame)
			
			var sprite = character_instance.get_node("CharacterSprite")
			sprite.texture = load(sprite_path + character_info["name"] + ".png")
			var character_label = character_instance.get_node("CharacterLabel")
			character_label.text = character_info["name"]
			set_character_position_and_size(character_instance, character_index)
			hbox_container.add_child(character_instance)
			character_index += 1
		
		print("Final team displayed")
		Global.set_input_allowed(false) #no clicking
		# Show congratulations message and transition to next scene after delay
		$ConfirmationContainer/ConfirmationLabel.text = "Congratulations, you have your team"
		$ConfirmationContainer/ConfirmationLabel.show()
		$ConfirmationContainer.show()
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
