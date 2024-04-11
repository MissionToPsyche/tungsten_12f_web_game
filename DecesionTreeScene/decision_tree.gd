extends Node2D

var button_tweens = {}
var button_positions = []
var shuffled_mystery_scenes = []
var button_to_position_map = {}
var timer = null


func _ready():
	shuffle_mystery_scenes()
	calculate_minigame_points()
	animate_score_increase()
	initialize_button_positions()
	initialize_arrow_size_and_direction()
	initialize_arrow_position()
	initialize_buttons()
	set_characters()
	
	$CharacterCanvas.layer = 0
	$ButtonCanvas.layer = -1
	#Disable all arrows
	for i in range(1, 11):
		set_arrow_state(i, false)
		
	for button in $UI/ButtonContainer.get_children():
		button.disabled = true
		
	for arrow_num in Global.active_arrows:
		set_arrow_state(arrow_num, true)
		
	for arrow_num in Global.next_arrows:
		set_arrow_state(arrow_num, true)
		
	for button_name in Global.next_buttons:
		enable_button(button_name)
	
	if "Mystery" in Global.player_path or "Mystery2" in Global.player_path:
		get_tree().change_scene_to_file("res://DesignScene/DesignScene.tscn")

	if not Global.button_states["button"]:
		$ButtonCanvas/CanvasModulate/Button.disabled = true
	if not Global.button_states["button2"]:
		$ButtonCanvas/CanvasModulate/Button2.disabled = true
	if not Global.button_states["button3"]:
		$ButtonCanvas/CanvasModulate/Button3.disabled = true

func shuffle_mystery_scenes():
	var mystery_scenes = [
		"Robotics",
		"Navigation",
		"Exploration"
	]
	mystery_scenes.shuffle()
	shuffled_mystery_scenes = mystery_scenes


func calculate_minigame_points():
	var current_score = Global.score
	var previous_score = Global.previous_score
	var score_difference = current_score - previous_score

	if score_difference > 0:
		$ScoreIncreaseTimer.stop()
		$ScoreIncreaseTimer.wait_time = 1
		$ScoreIncreaseTimer.start()  # Start the timer
	else:
		update_score_label(current_score)

	Global.previous_score = current_score

func get_relevant_skill_frame():
	var current_character_stats = Global.selected_mission_character_stats[-1]
	var current_position = Global.current_position

	match current_position:
		"pos1":
			return current_character_stats["Robotics"]
		"pos2":
			return current_character_stats["Navigation"]
		"pos3":
			return current_character_stats["Navigation"]
		"pos4":
			return current_character_stats["Exploration"]
		"pos5":
			return current_character_stats[shuffled_mystery_scenes[0]]
		"pos6":
			return current_character_stats[shuffled_mystery_scenes[1]]

	return 0
	
	
func animate_score_increase():
	var current_score = Global.score
	var previous_score = Global.previous_score
	var score_difference = current_score - previous_score

	if score_difference > 0:
		$ScoreIncreaseTimer.stop()
		$ScoreIncreaseTimer.wait_time = 1
	else:
		update_score_label(current_score)

func _on_score_increase_timer_timeout():
	var current_score = Global.score
	var previous_score = Global.previous_score

	if previous_score < current_score:
		previous_score += 1
		update_score_label(previous_score)
		Global.previous_score = previous_score
	else:
		$ScoreIncreaseTimer.stop()

func update_score_label(score):
	$UI/PointsTexture/Points.text = "Total Score: " + str(score)

func initialize_button_positions():
	# Assign your Marker2D nodes to the array
	button_positions = [$UI/pos1, $UI/pos2, $UI/pos3, $UI/pos4, $UI/pos5, $UI/pos6]
	button_to_position_map = {
		"Robotics": "pos1",
		"Navigation": "pos2",
		"Navigation2": "pos3",
		"Exploration": "pos4",
		"Mystery": "pos5",
		"Mystery2": "pos6"
	}
	
	for button_name in button_to_position_map:
		var position = button_to_position_map[button_name]
		var button_node = $UI/ButtonContainer.get_node(button_name)
		var marker_node = $UI.get_node(position)
		button_node.position = marker_node.position
		
	
func initialize_arrow_size_and_direction():
	# Calculate the arrow size based on the screen size
	var screen_size = get_viewport().size
	var arrow_size = screen_size.x / 20.0
	
	var number_of_arrows = 10
	for i in range(1, number_of_arrows+1):
		set_arrow_size(i, arrow_size)
	set_arrow_direction()

func set_arrow_size(arrow_number, arrow_size):
	var arrow_active = $UI.get_node("ArrowActive" + str(arrow_number))
	var arrow_inactive = $UI.get_node("ArrowInactive" + str(arrow_number))

	# Calculate the arrow scale based on its texture size and the desired arrow size
	var arrow_texture_size = arrow_active.texture.get_size()
	var arrow_scale = arrow_size / max(arrow_texture_size.x, arrow_texture_size.y)

	# Apply the scale to both active and inactive arrows
	arrow_active.scale = Vector2(arrow_scale, arrow_scale)
	arrow_inactive.scale = Vector2(arrow_scale, arrow_scale)

func set_arrow_direction():
	var arrow_angles = {
		"ArrowActive1": 315, "ArrowInactive1": 315,
		"ArrowActive2": 45, "ArrowInactive2": 45,
		"ArrowActive3": 0, "ArrowInactive3": 0,
		"ArrowActive4": 45, "ArrowInactive4": 45,
		"ArrowActive5": 0, "ArrowInactive5": 0,
		"ArrowActive6": 0, "ArrowInactive6": 0,
		"ArrowActive7": 315, "ArrowInactive7": 315,
		"ArrowActive8": 0, "ArrowInactive8": 0,
		"ArrowActive9": 45, "ArrowInactive9": 45,
		"ArrowActive10": 315, "ArrowInactive10": 315,
	}
	
	for arrow_name in arrow_angles.keys():
		var arrow_node = $UI.get_node(arrow_name)
		if arrow_node:
			var angle_in_radians = deg2rad(arrow_angles[arrow_name])
			arrow_node.rotation = angle_in_radians
		else:
			print("Arrow node not found: ", arrow_name)

func deg2rad(degrees):
	return degrees * PI / 180.0


func initialize_arrow_position():
	var number_of_arrows = 10
	for i in range(1, number_of_arrows + 1):
		set_arrow_position(i)

func set_arrow_position(arrow_number):
	var arrow_active = $UI.get_node("ArrowActive" + str(arrow_number))
	var arrow_inactive = $UI.get_node("ArrowInactive" + str(arrow_number))
	var arrow_position_marker = $UI.get_node("arrowpos" + str(arrow_number))

	# Set the position of active and inactive arrows to the corresponding marker position
	arrow_active.position = arrow_position_marker.position
	arrow_inactive.position = arrow_position_marker.position

func initialize_buttons():
	var screen_size = get_viewport().size
	var max_button_size = screen_size.x / 20.0
	
	for button_name in button_to_position_map:
		var button_node = $UI/ButtonContainer.get_node(button_name)
		var button_texture_size = button_node.texture_normal.get_size()
		var button_scale = max_button_size / max(button_texture_size.x, button_texture_size.y)
		button_node.scale = Vector2(button_scale, button_scale)


func set_arrow_state(arrow_number, is_active):
	var arrow_active = $UI.get_node("ArrowActive" + str(arrow_number))
	var arrow_inactive = $UI.get_node("ArrowInactive" + str(arrow_number))
	arrow_active.visible = is_active
	arrow_inactive.visible = !is_active
	
	
func enable_button(button_name):
	var button_node = $UI/ButtonContainer.get_node(button_name)
	if button_node:
		button_node.disabled = false

		# Apply button rotation animation
		var tween = create_tween()
		tween.set_loops(-1)
		tween.tween_property(button_node, "rotation_degrees", -5, 0.2)
		tween.tween_property(button_node, "rotation_degrees", 10, 0.2)
		tween.tween_property(button_node, "rotation_degrees", -5, 0.2)
		tween.tween_property(button_node, "rotation_degrees", 0, 0.2)
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		button_node.pressed.connect(tween.kill)
		button_tweens[button_node.name] = tween
	else:
		print("Button node not found for position:", button_name)

func set_characters():
	for i in range(3):
		var character_info = Global.chosen_characters[i]
		var character_instance = preload("res://character.tscn").instantiate()
		
		character_instance.character_name = character_info["name"]
		character_instance.character_stats = character_info["stats"]

		character_instance.Skill1 = character_instance.get_node("Skill1")
		character_instance.Skill2 = character_instance.get_node("Skill2")

		character_instance.Skill1.frame = character_info["skill1_frame"]
		character_instance.Skill2.frame = character_info["skill2_frame"]
		character_instance.update_skill_labels_final(character_info["skill1_frame"], character_info["skill2_frame"])
		character_instance.is_final_display = true

		var skill1_label = character_instance.get_node("Skill1Label")
		var skill2_label = character_instance.get_node("Skill2Label")
		var skill1_sprite = character_instance.get_node("Skill1")
		var skill2_sprite = character_instance.get_node("Skill2")
		var sprite = character_instance.get_node("CharacterSprite")
		
		skill1_label.visible = false
		skill2_label.visible = false
		skill1_sprite.visible = false
		skill2_sprite.visible = false
		
		sprite.texture = load("res://assets/sprites/team_builder_sprites/" + character_info["name"] + ".png")
		sprite.visible = false  # Set the sprite to be invisible initially
		
		set_character_position_and_size(character_instance,i)
		character_instance.sprite_selected.connect(_on_CharacterSprite_pressed.bind(character_instance, i))
		$CharacterCanvas/CharacterContainer.add_child(character_instance)

	$CharacterCanvas/PromptTexture/PromptLabel.visible = false  # Set the prompt label to be invisible initially
	$CharacterCanvas/PromptTexture.visible = false


func set_character_position_and_size(character_instance, position_index):
	var screen_size = get_viewport_rect().size
	var target_height = screen_size.y / 2
	var sprite = character_instance.get_node("CharacterSprite")

	var scale_factor = target_height / sprite.texture.get_height()
	sprite.scale = Vector2(scale_factor, scale_factor)

	var positions = [
		Vector2(screen_size.x / 4, screen_size.y / 2),
		Vector2(screen_size.x / 2, screen_size.y / 2),
		Vector2(screen_size.x * 3 / 4, screen_size.y / 2)
	]
	character_instance.position = positions[position_index]



func _on_robotics_pressed():
	print("ready to change scene, Robotics button pressed")
	Global.player_path.append("Robotics")
	Global.current_position = "pos1"
	Global.active_arrows.append(1)
	Global.next_buttons = ["Navigation2", "Exploration"]
	Global.next_arrows = [3, 4]
	decision_button_pressed("Robotics")


func _on_navigation_pressed():
	print("ready to change scene, Navigation button pressed")
	Global.current_position = "pos2"
	Global.active_arrows.append(2)
	Global.next_buttons = ["Exploration"]
	Global.next_arrows = [5]
	decision_button_pressed("Navigation")


func _on_navigation_2_pressed():
	print("ready to change scene, Navigation2 button pressed")
	Global.player_path.append("Navigation2")
	Global.current_position = "pos3"
	Global.active_arrows.append(3)
	Global.next_buttons = ["Mystery"]
	Global.next_arrows = [6]
	decision_button_pressed("Navigation")


func _on_exploration_pressed():
	print("ready to change scene, ore button pressed")
	Global.current_position = "pos4"
	if "Navigation" in Global.player_path:
		Global.active_arrows.append(4)
	else:
		Global.active_arrows.append(5)
	Global.next_buttons = ["Mystery", "Mystery2"]
	Global.next_arrows = [7, 8]
	decision_button_pressed("Exploration")


func _on_mystery_pressed():
	print("ready to change scene, Robotics button pressed")
	Global.player_path.append("Mystery")
	Global.current_position = "pos5"
	
	if "Navigation2" in Global.player_path:
		Global.active_arrows.append(6)
	else:
		Global.active_arrows.append(7)

	Global.next_arrows = [9]
	decision_button_pressed("Mystery")


func _on_mystery_2_pressed():
	Global.player_path.append("Mystery2")
	Global.current_position = "pos6"
	Global.active_arrows.append(8)

	Global.next_arrows = [10]
	decision_button_pressed("Mystery")


func _on_button_pressed():
	parse_and_set_selected_mission_character(0)
	Global.character_clicked[0] = true
	Global.button_states["button"] = false
	_on_CharacterSprite_pressed()


func _on_button_2_pressed():
	parse_and_set_selected_mission_character(1)
	Global.character_clicked[1] = true
	Global.button_states["button2"] = false
	_on_CharacterSprite_pressed()


func _on_button_3_pressed():
	parse_and_set_selected_mission_character(2)
	Global.character_clicked[2] = true
	Global.button_states["button3"] = false
	_on_CharacterSprite_pressed()


func parse_and_set_selected_mission_character(index):
	var characters = Global.chosen_characters
	var name = characters[index]["name"]
	var stats = characters[index]["stats"]
	Global.selected_mission_character.append(name)
	Global.selected_mission_character_stats.append(stats)


func decision_button_pressed(button_name):
	$CharacterCanvas.layer = 2
	$ButtonCanvas.layer = 3
	for i in range(3):
		var character = $CharacterCanvas/CharacterContainer.get_child(i)
		var character_sprite = character.get_node("CharacterSprite")
		var skill1_label = character.get_node("Skill1Label")
		var skill2_label = character.get_node("Skill2Label")
		var skill1_sprite = character.get_node("Skill1")
		var skill2_sprite = character.get_node("Skill2")

		character_sprite.visible = true
		skill1_label.visible = true
		skill2_label.visible = true
		skill1_sprite.visible = true
		skill2_sprite.visible = true
		if Global.character_clicked[i]:
			character.modulate = Color(0.5, 0.5, 0.5)  # Gray out the clicked character
		else:
			character.modulate = Color(1, 1, 1)  # Set the character to normal color
	var scene_map = {
		"Robotics": "Robotics",
		"Navigation": "Navigation",
		"Navigation2": "Navigation",
		"Exploration": "Exploration",
		"Mystery": shuffled_mystery_scenes[0],
		"Mystery2": shuffled_mystery_scenes[1]
	}
	var scene_name = scene_map[button_name]
	$CharacterCanvas/PromptTexture/PromptLabel.text = "Choose a character to send on the " + scene_name + " mission:"
	$CharacterCanvas/PromptTexture/PromptLabel.visible = true
	$CharacterCanvas/PromptTexture.visible = true
	

func _on_CharacterSprite_pressed():
	$CharacterCanvas/PromptTexture.visible = false
	$CharacterCanvas/PromptTexture/PromptLabel.visible = false

	for i in range(3):
		var char_instance = $CharacterCanvas/CharacterContainer.get_child(i)
		char_instance.get_node("CharacterSprite").visible = false
		
	var scene_map = {
		"Robotics": "res://DecesionTreeScene/test_decision_tree_minigame.tscn",
		"Navigation": "res://Minigame2/Minigame2.tscn",
		"Exploration": "res://world.tscn"
	}	
	
	match Global.current_position:
		"pos1":
			get_tree().change_scene_to_file("res://PuzzleScene/main.tscn")
		"pos2":
			get_tree().change_scene_to_file("res://Minigame2/Minigame2.tscn")
		"pos3":
			get_tree().change_scene_to_file("res://Minigame2/Minigame2.tscn")
		"pos4":
			get_tree().change_scene_to_file("res://world.tscn")
		"pos5":
			get_tree().change_scene_to_file(scene_map[shuffled_mystery_scenes[0]])
		"pos6":
			get_tree().change_scene_to_file(scene_map[shuffled_mystery_scenes[1]])
