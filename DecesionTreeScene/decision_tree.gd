extends Node2D

var button_tweens = {}
var button_positions = []
var button_to_position_map = {}
var timer = null

func _ready():
	initialize_button_positions()
	initialize_arrow_size_and_direction()
	initialize_arrow_position()
	initialize_buttons()
	
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


func initialize_button_positions():
	# Assign your Marker2D nodes to the array
	button_positions = [$UI/pos1, $UI/pos2, $UI/pos3, $UI/pos4, $UI/pos5, $UI/pos6]
	button_to_position_map = {
		"Marketing": "pos1",
		"Simulation": "pos2",
		"Simulation2": "pos3",
		"Ore": "pos4",
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


func _on_marketing_pressed():
	print("ready to change scene, marketing button pressed")
	Global.player_path.append("Marketing")
	Global.current_position = "pos1"
	Global.active_arrows.append(1)
	Global.next_buttons = ["Simulation2", "Ore"]
	Global.next_arrows = [3, 4]
	get_tree().change_scene_to_file("res://world.tscn")


func _on_simulation_pressed():
	print("ready to change scene, simulation button pressed")
	Global.current_position = "pos2"
	Global.active_arrows.append(2)
	Global.next_buttons = ["Ore"]
	Global.next_arrows = [5]
	get_tree().change_scene_to_file("res://DecesionTreeScene/test_decision_tree_minigame.tscn")


func _on_simulation_2_pressed():
	print("ready to change scene, simulation2 button pressed")
	Global.player_path.append("Simulation2")
	Global.current_position = "pos3"
	Global.active_arrows.append(3)
	Global.next_buttons = ["Mystery"]
	Global.next_arrows = [6]
	get_tree().change_scene_to_file("res://DecesionTreeScene/test_decision_tree_minigame.tscn")


func _on_ore_pressed():
	print("ready to change scene, ore button pressed")
	Global.current_position = "pos4"
	if "Simulation" in Global.player_path:
		Global.active_arrows.append(4)
	else:
		Global.active_arrows.append(5)
	Global.next_buttons = ["Mystery", "Mystery2"]
	Global.next_arrows = [7, 8]
	get_tree().change_scene_to_file("res://DecesionTreeScene/test_decision_tree_minigame.tscn")


func _on_mystery_pressed():
	print("ready to change scene, marketing button pressed")
	Global.player_path.append("Mystery")
	Global.current_position = "pos5"
	
	if "Simulation2" in Global.player_path:
		Global.active_arrows.append(6)
	else:
		Global.active_arrows.append(7)

	Global.next_arrows = [9]
	var mystery_scenes = [
		'res://DecesionTreeScene/test_decision_tree_minigame.tscn', 
		'res://DecesionTreeScene/test_decision_tree_minigame.tscn', 
		'res://DecesionTreeScene/test_decision_tree_minigame.tscn'
	]
	mystery_scenes.shuffle()
	get_tree().change_scene_to_file(mystery_scenes[0])


func _on_mystery_2_pressed():
	print("ready to change scene, marketing button pressed")
	Global.player_path.append("Mystery2")
	Global.current_position = "pos6"
	Global.active_arrows.append(8)

	Global.next_arrows = [10]
	var mystery_scenes = [
		'res://DecesionTreeScene/test_decision_tree_minigame.tscn', 
		'res://DecesionTreeScene/test_decision_tree_minigame.tscn', 
		'res://DecesionTreeScene/test_decision_tree_minigame.tscn'
	]
	mystery_scenes.shuffle()
	get_tree().change_scene_to_file(mystery_scenes[0])
