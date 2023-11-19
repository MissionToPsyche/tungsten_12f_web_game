# satellite-lab.gd
extends Node2D

var satellite_parts = {} # Dictionary to hold the parts currently on the satellite, keyed by type
var available_parts = {} # Dictionary of available parts for the player to choose from, keyed by type
var current_visible_vbox = null

func _ready():
	initialize_parts()
	update_ui()

func initialize_parts():
	# Load parts from a file or create them here
	# Structure the parts into categories
	available_parts["Power System"] = [Part1, Part2] # Replace with actual part instances
	available_parts["Power System"] = [Part1, Part2]
	# ... Do this for all categories

func update_ui():
	# Reset all VBoxContainers to be hidden
	for vbox in get_node("Categories").get_children():
		vbox.hide()
	# Hide currently visible vbox if any
	if current_visible_vbox:
		current_visible_vbox.hide()
	pass

func show_components_for_category(category):
	update_ui() # Hide all vboxes
	var vbox = get_node("Categories/" + category)
	vbox.show()
	current_visible_vbox = vbox

func _on_CategoryButton_pressed(category):
	show_components_for_category(category)

func add_part_to_satellite(category, part):
	# Assume part is an instance of SatellitePart
	if part.is_compatible_with_current_configuration():
		satellite_parts[category] = part
		update_ui()

func remove_part_from_satellite(category):
	if category in satellite_parts:
		satellite_parts.erase(category)
		update_ui()

func select_part_button(button: Button, category: String):
	# Deselect any other selected button in this category
	for btn in get_node("Categories/" + category).get_children():
		btn.modulate = Color(1, 1, 1) # Normal color
		btn.get_child(0).add_color_override("font_color", Color(0, 0, 0)) # Normal text color
	button.modulate = Color(0.5, 1, 0.5) # Light green for selected
	button.get_child(0).add_color_override("font_color", Color(0.5, 0.5, 0.5)) # Gray text for selected

func _on_ComponentButton_pressed(button: Button, category: String, part: SatellitePart):
	select_part_button(button, category)
	add_part_to_satellite(category, part)
