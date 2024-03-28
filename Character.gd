extends Node2D

# Ensure to declare the signal in the script
signal sprite_selected(name, info)

# Character-specific information
var character_name := "Default Name"
var character_stats := {"Simulator Training": 0, "Rocket Engineering": 0, "Robotics": 0, "Piloting": 0}
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
	character_stats["Simulator Training"] = randi() % 5
	character_stats["Rocket Engineering"] = randi() % 5
	character_stats["Robotics"] = randi() % 5
	character_stats["Piloting"] = randi() % 5
	print("Randomized stats:", character_stats)

func update_skill_frames():
	# Randomly pick 2 skills out of the 4 available skills
	var available_skills = ["Simulator Training", "Rocket Engineering", "Robotics", "Piloting"]
	chosen_skills = []
	for _i in range(2):
		var random_index = randi() % available_skills.size()
		chosen_skills.append(available_skills[random_index])
		available_skills.remove_at(random_index)

	# Update skill bar frames based on the chosen skills
	if chosen_skills[0] == "Simulator Training":
		Skill1.frame = 4 - character_stats["Simulator Training"]
	elif chosen_skills[0] == "Rocket Engineering":
		Skill1.frame = 9 - character_stats["Rocket Engineering"]
	elif chosen_skills[0] == "Robotics":
		Skill1.frame = 14 - character_stats["Robotics"]
	else:
		Skill1.frame = 19 - character_stats["Piloting"]

	if chosen_skills[1] == "Simulator Training":
		Skill2.frame = 4 - character_stats["Simulator Training"]
	elif chosen_skills[1] == "Rocket Engineering":
		Skill2.frame = 9 - character_stats["Rocket Engineering"]
	elif chosen_skills[1] == "Robotics":
		Skill2.frame = 14 - character_stats["Robotics"]
	else:
		Skill2.frame = 19 - character_stats["Piloting"]
	print("Chosen skills:", chosen_skills)
	print("Skill1 frame:", Skill1.frame)
	print("Skill2 frame:", Skill2.frame)

func update_skill_labels():
	var Skill1Label = $Skill1Label
	var Skill2Label = $Skill2Label
	if chosen_skills.size() >= 2:
		if chosen_skills[0] == "Simulator Training":
			Skill1Label.text = "Simulator Training"
			Skill1Label.add_theme_color_override("font_color", Color.SKY_BLUE)
		elif chosen_skills[0] == "Rocket Engineering":
			Skill1Label.text = "Rocket Engineering"
			Skill1Label.add_theme_color_override("font_color", Color.LIME)
		elif chosen_skills[0] == "Robotics":
			Skill1Label.text = "Robotics"
			Skill1Label.add_theme_color_override("font_color", Color.ORANGE_RED)
		else:
			Skill1Label.text = "Piloting"
			Skill1Label.add_theme_color_override("font_color", Color.WEB_PURPLE)

		if chosen_skills[1] == "Simulator Training":
			Skill2Label.text = "Simulator Training"
			Skill2Label.add_theme_color_override("font_color", Color.SKY_BLUE)
		elif chosen_skills[1] == "Rocket Engineering":
			Skill2Label.text = "Rocket Engineering"
			Skill2Label.add_theme_color_override("font_color", Color.LIME)
		elif chosen_skills[1] == "Robotics":
			Skill2Label.text = "Robotics"
			Skill2Label.add_theme_color_override("font_color", Color.ORANGE_RED)
		else:
			Skill2Label.text = "Piloting"
			Skill2Label.add_theme_color_override("font_color", Color.WEB_PURPLE)
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
		return "Simulator Training"
	elif frame >= 5 and frame <= 9:
		return "Rocket Engineering"
	elif frame >= 10 and frame <= 14:
		return "Robotics"
	elif frame >= 15 and frame <= 19:
		return "Piloting"
	else:
		return ""

func get_skill_color(skill): #changed
	match skill:
		"Simulator Training":
			return Color.SKY_BLUE
		"Rocket Engineering":
			return Color.LIME
		"Robotics":
			return Color.ORANGE_RED
		"Piloting":
			return Color.WEB_PURPLE
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
