# satellite-lab.gd
extends Node2D

var satellite_parts = {}  # Holds the actual part instances
var available_parts = {}  # Holds the metadata from the JSON file

func _ready():
	initialize_parts()
	update_ui()

func initialize_parts():
	var file = File.new()
	if file.open("res://path_to_your_file/parts.json", File.READ) == OK:
		var data = parse_json(file.get_as_text())
		file.close()

		# Create instances of parts based on the JSON data
		for category in data.keys():
			available_parts[category] = []
			for part_data in data[category]:
				var part = create_part_instance(category, part_data)
				available_parts[category].append(part)

func create_part_instance(category: String, part_data: Dictionary) -> SatellitePart:
	var part
	match category:
		"PowerSystem":
			part = PowerSystemPart.new(
				part_data["name"],
				part_data["weight"],
				part_data["cost"],
				part_data["compatibility"],
				# ... add all specific attributes here ...
			)
		# ... match other

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
