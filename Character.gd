extends Node2D

# Ensure to declare the signal in the script
signal sprite_selected(name, info)

# Character-specific information
var character_name := "Default Name"
var character_stats := {"Navigation": 0, "Exploration": 0, "Robotics": 0}
var chosen_skills = []
# AnimatedSprites for skills
var character_sprite: Sprite2D
var Skill1: AnimatedSprite2D
var Skill2: AnimatedSprite2D
var character_label: Label
var is_final_display = false

func _ready():
	if not is_final_display:
		randomize()
		randomize_stats()  # Set random stats for this character instance
		character_sprite = $CharacterSprite  # Assuming the Sprite2D is a direct child of this Node2D
		Skill1 = $Skill1
		Skill2 = $Skill2
		var Skill1Label = $Skill1Label
		var Skill2Label = $Skill2Label
		print("Character name:", character_name)
		print("Character stats:", character_stats)
		update_skill_frames()
		update_skill_labels()
		character_sprite.set_process_input(true)
		character_sprite.call_deferred("set_name", character_name)
		

func randomize_stats():
	# Randomize stats here
	character_stats["Navigation"] = randi() % 5
	character_stats["Exploration"] = randi() % 5
	character_stats["Robotics"] = randi() % 5
	print("Randomized stats:", character_stats)

func update_skill_frames():
	# Randomly pick 2 skills out of the 4 available skills
	var available_skills = ["Navigation", "Exploration", "Robotics"]
	chosen_skills = []
	for _i in range(2):
		var random_index = randi() % available_skills.size()
		chosen_skills.append(available_skills[random_index])
		available_skills.remove_at(random_index)

	# Update skill bar frames based on the chosen skills
	if chosen_skills[0] == "Navigation":
		Skill1.frame = 4 - character_stats["Navigation"]
	elif chosen_skills[0] == "Exploration":
		Skill1.frame = 9 - character_stats["Exploration"]
	else:
		Skill1.frame = 14 - character_stats["Robotics"]



	if chosen_skills[1] == "Navigation":
		Skill2.frame = 4 - character_stats["Navigation"]
	elif chosen_skills[1] == "Exploration":
		Skill2.frame = 9 - character_stats["Exploration"]
	else:
		Skill2.frame = 14 - character_stats["Robotics"]
		
	print("Chosen skills:", chosen_skills)
	print("Skill1 frame:", Skill1.frame)
	print("Skill2 frame:", Skill2.frame)

func update_skill_labels():
	var Skill1Label = $Skill1Label
	var Skill2Label = $Skill2Label
	if chosen_skills.size() >= 2:
		if chosen_skills[0] == "Navigation":
			Skill1Label.text = "Navigation"
			Skill1Label.add_theme_color_override("font_color", Color.DARK_TURQUOISE)
		elif chosen_skills[0] == "Exploration":
			Skill1Label.text = "Exploration"
			Skill1Label.add_theme_color_override("font_color", Color.LIME_GREEN)
		else:
			Skill1Label.text = "Robotics"
			Skill1Label.add_theme_color_override("font_color", Color.DARK_ORANGE)

		if chosen_skills[1] == "Navigation":
			Skill2Label.text = "Navigation"
			Skill2Label.add_theme_color_override("font_color", Color.DARK_TURQUOISE)
		elif chosen_skills[1] == "Exploration":
			Skill2Label.text = "Exploration"
			Skill2Label.add_theme_color_override("font_color", Color.LIME_GREEN)
		else:
			Skill2Label.text = "Robotics"
			Skill2Label.add_theme_color_override("font_color", Color.DARK_ORANGE)

	print("Skill1 label text:", Skill1Label.text)
	print("Skill1 label color:", Skill1Label.get_theme_color("font_color"))
	print("Skill2 label text:", Skill2Label.text)
	print("Skill2 label color:", Skill2Label.get_theme_color("font_color"))

func update_final_display(skill1_frame, skill2_frame):
	print("update_final_display called")
	print("Skill1 frame:", skill1_frame)
	print("Skill2 frame:", skill2_frame)

	# Update skill bar frames based on the provided skill frames
	if Skill1 != null:
		Skill1.frame = skill1_frame
	if Skill2 != null:
		Skill2.frame = skill2_frame
	update_skill_labels_final(skill1_frame, skill2_frame)

func update_skill_labels_final(skill1_frame, skill2_frame):
	var Skill1Label = $Skill1Label
	var Skill2Label = $Skill2Label
	
	print("Updating skill labels for final display")
	print("Skill1 frame:", skill1_frame)
	print("Skill2 frame:", skill2_frame)
	# Determine the skill names based on the frames
	var skill1 = get_skill_name(skill1_frame)
	var skill2 = get_skill_name(skill2_frame)

	# Set the skill labels and colors
	Skill1Label.text = skill1
	Skill1Label.add_theme_color_override("font_color", get_skill_color(skill1))
	Skill2Label.text = skill2
	Skill2Label.add_theme_color_override("font_color", get_skill_color(skill2))
	
func get_skill_name(frame): #changed
	if frame >= 0 and frame <= 4:
		return "Navigation"
	elif frame >= 5 and frame <= 9:
		return "Exploration"
	elif frame >= 10 and frame <= 14:
		return "Robotics"
	else:
		return ""

func get_skill_color(skill): #changed
	match skill:
		"Navigation":
			return Color.DARK_TURQUOISE
		"Exploration":
			return Color.LIME_GREEN
		"Robotics":
			return Color.DARK_ORANGE
		_:
			return Color.WHITE


# Getter method for character information
func get_character_info() -> Dictionary:
	print("get_character_info called")
	var info = {
		"name": character_name,
		"stats": character_stats,
		"skill1_frame": Skill1.frame,
		"skill2_frame": Skill2.frame
	}
	print("Returned character info:", info)
	return info


func _input(event):
	if Global.input_allowed and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if character_sprite and character_sprite.get_rect().has_point(character_sprite.to_local(event.position)):
			print("Inside sprite rect: ", character_name)  # Debug print
			emit_signal("sprite_selected", character_name, get_character_info())
			queue_free()
