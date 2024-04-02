extends Node2D
var minigame_buttons = {}
var button_positions = []
var path_history = [] # To keep track of the paths taken
var button_to_position_map = {}
var button_tweens = {}
signal switch_scene(scene_path)

var progression_paths = {
	"start": {"next": ["pos1", "pos2"], "arrows": {"pos1": 1, "pos2": 2}},
	"pos1": {"next": ["pos3", "pos4"], "arrows": {"pos3": 3, "pos4": 4}},
	"pos2": {"next": ["pos4"], "arrows": {"pos4": 5}},
	"pos3": {"next": ["pos5"], "arrows": {"pos5": 6}},
	"pos4": {"next": ["pos5", "pos6"], "arrows": {"pos5": 7, "pos6": 8}},
	"pos5": {"next": ["end"], "arrows": {"end": 9}},
	"pos6": {"next": ["end"], "arrows": {"end": 10}}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("This is the value of is_first_load 1: ",Global.decision_tree_state["is_first_load"])
	initialize_button_positions()
	assign_minigames_to_buttons()
	initialize_arrow_size_and_direction()
	initialize_arrow_position()
	initialize_buttons()
	if Global.decision_tree_state["is_first_load"]:
		initialize_arrows()
		Global.decision_tree_state["is_first_load"] = false
	else:
		print("This is the value of next_position upon reload: ",Global.decision_tree_state["next_position"])
		handle_progression(Global.decision_tree_state["next_position"])
	print("This is the value of is_first_load 2: ",Global.decision_tree_state["is_first_load"])
	switch_scene.connect(self._on_switch_scene)

func initialize_button_positions():
	# Assign your Marker2D nodes to the array
	button_positions = [$UI/pos1, $UI/pos2, $UI/pos3, $UI/pos4, $UI/pos5, $UI/pos6]

func assign_minigames_to_buttons():
	# Define fixed scenes for certain buttons
	minigame_buttons["Marketing"] = 'res://Minigame1-Rocketlaunch/node_2d.tscn'
	minigame_buttons["Simulation"] = 'res://main.tscn'  #greeshma mini game 
	minigame_buttons["Simulation2"] = 'res://main.tscn'
	minigame_buttons["Ore"] = 'res://Minigame1-Rocketlaunch/Minigame2.tscn'
	
	# Create a pool of minigame scenes for Mystery button excluding the fixed ones
	var mystery_scenes = [
		'res://Minigame1-Rocketlaunch/node_2d.tscn', 
		'res://main.tscn', 
		'res://Minigame1-Rocketlaunch/Minigame2.tscn'
	]
	
	# Shuffle the remaining scenes and assign one to the Mystery button
	mystery_scenes.shuffle()
	minigame_buttons["Mystery"] = mystery_scenes[0]
	minigame_buttons["Mystery2"] = mystery_scenes[1]
	button_to_position_map.clear()
	
	for i in range(minigame_buttons.size()):
		var button_name = minigame_buttons.keys()[i]
		var position = "pos" + str(i + 1)  # Assuming the order of minigame_buttons matches your position naming
		button_to_position_map[button_name] = position
	print("minigame_buttons dictionary:", minigame_buttons)


func initialize_arrows():
	# Initialize all arrows to their inactive state
	var number_of_arrows = 10
	for i in range(1, number_of_arrows+1):
		set_arrow_state(i, false)

	# Set the starting active arrows
	set_arrow_state(1, true)
	set_arrow_state(2, true)

	
func set_arrow_state(arrow_number, is_active):
	var arrow_active = $UI.get_node("ArrowActive" + str(arrow_number))
	var arrow_inactive = $UI.get_node("ArrowInactive" + str(arrow_number))
	arrow_active.visible = is_active
	arrow_inactive.visible = !is_active
	
func initialize_arrow_size_and_direction():
	# Calculate the arrow size based on the screen size
	var screen_size = get_viewport().size
	var arrow_size = screen_size.x / 20.0

	# Set the size and direction of all arrows
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
	# Define your arrow angles here, arranged in the pattern: Active, Inactive, Active, Inactive, ...
	# The angles are specified in degrees for each pair of arrows.
	var arrow_angles = {
		"ArrowActive1": 315,
		"ArrowInactive1": 315,
		"ArrowActive2": 45,
		"ArrowInactive2": 45,
		"ArrowActive3": 0,
		"ArrowInactive3": 0,
		"ArrowActive4": 45,
		"ArrowInactive4": 45,
		"ArrowActive5": 0,
		"ArrowInactive5": 0,
		"ArrowActive6": 0,
		"ArrowInactive6": 0,
		"ArrowActive7": 315,
		"ArrowInactive7": 315,
		"ArrowActive8": 0,
		"ArrowInactive8": 0,
		"ArrowActive9": 45,
		"ArrowInactive9": 45,
		"ArrowActive10": 315,
		"ArrowInactive10": 315,
	}
	
	# Iterate through the arrow_angles dictionary to set each arrow's rotation
	for arrow_name in arrow_angles.keys():
		var arrow_node = $UI.get_node(arrow_name)
		if arrow_node:
			# Convert the angle from degrees to radians since Godot uses radians for rotations
			var angle_in_radians = deg2rad(arrow_angles[arrow_name])
			arrow_node.rotation = angle_in_radians
		else:
			print("Arrow node not found: ", arrow_name)

# Helper function to convert degrees to radians
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
	# Deactivate all buttons initially
	for button in $UI/ButtonContainer.get_children():
		button.disabled = true
		var button_name = button.name
		if minigame_buttons.has(button_name):
			button.pressed.connect(self._on_Button_Pressed.bind(button_name))
			
	var screen_size = get_viewport().size
	var max_button_size = screen_size.x / 20.0
	
	for button_name in button_to_position_map:
		var position = button_to_position_map[button_name]
		var button_node = $UI/ButtonContainer.get_node(button_name)
		var marker_node = $UI.get_node(position)
		button_node.position = marker_node.position
		
		# Calculate the button scale based on its texture size and the maximum button size
		var button_texture_size = button_node.texture_normal.get_size()
		var button_scale = max_button_size / max(button_texture_size.x, button_texture_size.y)
		button_node.scale = Vector2(button_scale, button_scale)
	enable_buttons_for_current_position()

func enable_buttons_for_current_position():
	print("Enabling buttons for current position:", Global.decision_tree_state["current_position"])
	for button in $UI/ButtonContainer.get_children():
		button.disabled = true
		
		if button.name in button_tweens:
			var tween = button_tweens[button.name]
			tween.kill()  # Stop and free the tween
			button_tweens.erase(button.name)

	# Enable buttons that are reachable from the current position
	for next_pos in progression_paths[Global.decision_tree_state["current_position"]]["next"]:
		for button_name in button_to_position_map:
			if button_to_position_map[button_name] == next_pos:
				var button_node = $UI/ButtonContainer.get_node(button_name)
				button_node.disabled = false
				print("Enabled button:", button_name)
				# Start the button vibration animation
				var tween = create_tween()
				tween.set_loops(-1)  # Set the animation to loop indefinitely
				tween.tween_property(button_node, "rotation_degrees", -5, 0.2)
				tween.tween_property(button_node, "rotation_degrees", 10, 0.2)
				tween.tween_property(button_node, "rotation_degrees", -5, 0.2)
				tween.tween_property(button_node, "rotation_degrees", 0, 0.2)
				tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)  # Pause the animation when the button is disabled
				
				# Connect the button's pressed signal to stop the animation for all buttons
				button_node.pressed.connect(tween.kill)

				# Store the tween as a child of the button node
				button_tweens[button_node.name] = tween


func _on_Button_Pressed(button_name):
	print("Button pressed:", button_name)
	if button_name in button_to_position_map:
		Global.decision_tree_state["next_position"] = button_to_position_map[button_name]
		print("Next position set to:", Global.decision_tree_state["next_position"])
		
		for button in $UI/ButtonContainer.get_children():
			button.rotation_degrees = 0
		
		if button_name in minigame_buttons:
			var minigame_scene = minigame_buttons[button_name]
			emit_signal("switch_scene", minigame_scene)
			print("Switch scene signal emitted for button:", button_name, "with scene path:", minigame_scene)
	else:
		print("Error: Button name not found in current mapping.")

func _on_switch_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)


func handle_progression(next_position):
	print("Handling progression for next position:", next_position)
	if next_position in progression_paths[Global.decision_tree_state["current_position"]]["next"]:
		var arrow_index = progression_paths[Global.decision_tree_state["current_position"]]["arrows"][next_position]
		print("Arrow index:", arrow_index)
		toggle_arrows_based_on_path(Global.decision_tree_state["current_position"], next_position, arrow_index)
		
		Global.decision_tree_state["current_position"] = next_position
		print("Current position updated to:", Global.decision_tree_state["current_position"])
		enable_buttons_for_current_position()
	else:
		print("Invalid move to: ", next_position)


func toggle_arrows_based_on_path(from_position, to_position, arrow_index):
	# Deactivate all arrows first
	for i in range(1, 11):  # Adjust based on your actual arrow range
		set_arrow_state(i, false)

	# Activate arrows based on the current path
	for path_entry in path_history:
		var current_pos = path_entry["position"]
		var arrow_num = path_entry["arrow"]
		set_arrow_state(arrow_num, true)

	# Activate the arrow representing the current move
	set_arrow_state(arrow_index, true)

	# Activate arrows for the next possible positions from the current position
	if to_position in progression_paths:
		var next_positions = progression_paths[to_position]["next"]
		for next_pos in next_positions:
			if next_pos in progression_paths[to_position]["arrows"]:
				var arrow_num = progression_paths[to_position]["arrows"][next_pos]
				set_arrow_state(arrow_num, true)

	# Add the current move to the path history, if it's not "end"
	if to_position != "end":
		path_history.append({"position": to_position, "arrow": arrow_index})

	
	
func toggle_arrow_visibility(arrow_number, is_active):
	# If is_active is true, show the active arrow and hide the inactive arrow, and vice versa
	var active_arrow_path = "ArrowActive" + str(arrow_number)
	var inactive_arrow_path = "ArrowInactive" + str(arrow_number)
	if is_active:
		$UI/TreeBackground.get_node(active_arrow_path).visible = true
		$UI/TreeBackground.get_node(inactive_arrow_path).visible = false
	else:
		$UI/TreeBackground.get_node(active_arrow_path).visible = false
		$UI/TreeBackground.get_node(inactive_arrow_path).visible = true
