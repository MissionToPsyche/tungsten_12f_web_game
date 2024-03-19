extends Node2D
var minigame_buttons = {}
var button_positions = []
var current_position = "start"
var path_history = [] # To keep track of the paths taken
var button_to_position_map = {}
var progression_paths = {
	"start": {"next": ["pos1", "pos2"], "arrows": {"pos1": 1, "pos2": 2}},
	"pos1": {"next": ["pos3"], "arrows": {"pos3": 3}},
	"pos2": {"next": ["pos3", "pos4"], "arrows": {"pos3": 4, "pos4": 5}},
	"pos3": {"next": ["pos5"], "arrows": {"pos5": 6}},
	"pos4": {"next": ["pos5", "pos6"], "arrows": {"pos5": 7, "pos6": 8}},
	"pos5": {"next": ["end"], "arrows": {"end": 9}},
	"pos6": {"next": ["end"], "arrows": {"end": 10}}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_button_positions()
	assign_minigames_to_buttons()
	initialize_arrows()
	initialize_buttons()

func initialize_button_positions():
	# Assign your Marker2D nodes to the array
	button_positions = [$UI/pos1, $UI/pos2, $UI/pos3, $UI/pos4, $UI/pos5, $UI/pos6]

func assign_minigames_to_buttons():
	# Define fixed scenes for certain buttons
	minigame_buttons["Marketing"] = 'res://marketing_minigame.tscn'
	minigame_buttons["Simulation"] = 'res://simulation_minigame.tscn'
	minigame_buttons["Ore"] = 'res://ore_minigame.tscn'
	
	# Create a pool of minigame scenes for Mystery button excluding the fixed ones
	var mystery_scenes = [
		'res://marketing_minigame.tscn', 
		'res://simulation_minigame.tscn', 
		'res://ore_minigame.tscn'
	]
	
	# Remove fixed minigame scenes to avoid duplicates
	mystery_scenes.erase(minigame_buttons["Marketing"])
	mystery_scenes.erase(minigame_buttons["Simulation"])
	mystery_scenes.erase(minigame_buttons["Ore"])
	
	# Shuffle the remaining scenes and assign one to the Mystery button
	mystery_scenes.shuffle()
	minigame_buttons["Mystery"] = mystery_scenes[0]  # Assign the first random unique scene
	button_to_position_map.clear()
	for i in range(minigame_buttons.size()):
		var button_name = minigame_buttons.keys()[i]
		var position = "pos" + str(i + 1)  # Assuming the order of minigame_buttons matches your position naming
		button_to_position_map[button_name] = position


func initialize_arrows():
	# Initialize all arrows to their inactive state
	var number_of_arrows = 10
	for i in range(1, number_of_arrows+1):
		set_arrow_state(i, false)

	# Set the starting active arrows
	set_arrow_state(1, true)
	set_arrow_state(2, true)
	
func set_arrow_state(arrow_number, is_active):
	var arrow_active = $UI/TreeBackground.get_node("ArrowActive" + str(arrow_number))
	var arrow_inactive = $UI/TreeBackground.get_node("ArrowInactive" + str(arrow_number))
	arrow_active.visible = is_active
	arrow_inactive.visible = !is_active

func initialize_buttons():
	# Deactivate all buttons initially
	for button in $UI/ButtonContainer.get_children():
		button.disabled = true
		var button_name = button.name
		if minigame_buttons.has(button_name):
			button.pressed.connect([minigame_buttons[button_name]])
	
	enable_buttons_for_current_position()

func enable_buttons_for_current_position():
	# Disable all buttons first
	for button in $UI/ButtonContainer.get_children():
		button.disabled = true

	# Enable buttons that are reachable from the current position
	for next_pos in progression_paths[current_position]["next"]:
		if next_pos in button_positions:  # If the next_pos corresponds to a button
			var button_node = $UI/ButtonContainer.get_node(button_positions[next_pos].get_node("Button").name)
			button_node.disabled = false
			# Connect the button's pressed signal to a method if not already connected
			if not button_node.pressed.is_connected():
				button_node.pressed.connect([button_node.name])


func _on_Button_Pressed(button_name):
	if button_name in button_to_position_map:
		var next_position = button_to_position_map[button_name]
		handle_progression(next_position)
	else:
		print("Error: Button name not found in current mapping.")


func handle_progression(next_position):
	if next_position in progression_paths[current_position]["next"]:
		var arrow_index = progression_paths[current_position]["arrows"][next_position]
		toggle_arrows_based_on_path(current_position, next_position, arrow_index)
		current_position = next_position
		enable_buttons_for_current_position()
	else:
		print("Invalid move to: ", next_position)


func toggle_arrows_based_on_path(from_position, to_position, arrow_index):
	# Deactivate all arrows first
	for i in range(1, 11):  # Adjust based on your actual arrow range
		set_arrow_state(i, false)
	
	# Reactivate arrows based on path_history
	for path in path_history:
		if path in progression_paths:
			var arrows = progression_paths[path]["arrows"]
			for pos in arrows.keys():
				var arrow_num = arrows[pos]
				if arrow_num != null:
					set_arrow_state(arrow_num, true)

	# Activate the arrow for the current choice, if applicable
	if arrow_index != null:
		set_arrow_state(arrow_index, true)

	# Ensure the arrow leading to the current choice is active
	if to_position in progression_paths[from_position]["arrows"]:
		var active_arrow = progression_paths[from_position]["arrows"][to_position]
		set_arrow_state(active_arrow, true)

	# Add the current position to the path history, if it's not "end"
	if to_position != "end":
		path_history.append(to_position)


	
	
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
