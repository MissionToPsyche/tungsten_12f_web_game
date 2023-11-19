# satellite-lab.gd
extends Node2D

var satellite_parts = {}  # Holds the actual part instances
var available_parts = {}  # Holds the metadata from the JSON file

# Keep track of the currently visible VBoxContainer
var current_visible_vbox = null  

# Import the File module
var File = preload("res://DesignScene/all_parts.json")

func _ready():
	initialize_parts()
	update_ui()

func initialize_parts():
	var file = File.new()
	if file.open("res://DesignScene/all_parts.json", File.READ) == OK:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_text)
		if error == OK:
			var data = json.get_data()  # This is the parsed JSON data

			# Create instances of parts based on the JSON data
			for category in data.keys():
				available_parts[category] = []
				var category_vbox = get_node("Categories/" + category + "/" + category)
				category_vbox.queue_free() # Clear previous buttons if any
				var new_category_vbox = VBoxContainer.new() # Create a new VBoxContainer
				new_category_vbox.name = category
				
				for part_data in data[category]:
					var part = create_part_instance(category, part_data)
					available_parts[category].append(part)
					
					# Create a button for the part
					var part_button = Button.new()
					part_button.text = part_data["name"]
					part_button.call_deferred("pressed", self, "_on_PartButton_pressed", [part_button, category, part])
					
					# Add the button to the VBoxContainer
					new_category_vbox.add_child(part_button)
				
				# Add the new VBoxContainer to the scene
				get_node("Categories/" + category).add_child(new_category_vbox)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_text, " at line ", json.get_error_line())

func create_part_instance(category: String, part_data: Dictionary) -> SatellitePart:
	var part
	match category:
		"PowerSystem":
			part = PowerSystemPart.new(part_data)
		"Communications":
			part = CommunicationsPart.new(part_data)
		"Payload":
			part = PayloadPart.new(part_data)
		"Propulsion":
			part = PropulsionPart.new(part_data)
		"SpacecraftBus":
			part = SpacecraftBusPart.new(part_data)
		_:
			print("Unknown category: %s" % category)
	return part

func update_ui():
	# Reset all VBoxContainers to be hidden
	for vbox in get_node("Categories").get_children():
		for category_vbox in vbox.get_children():
			category_vbox.hide()
	pass

func show_components_for_category(category):
	update_ui() # Hide all vboxes
	var vbox = get_node("Categories/" + category + "/" + category)
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
	
func _on_PartButton_pressed(button: Button, category: String, part: SatellitePart):
	select_part_button(button, category)
	add_part_to_satellite(category, part)
