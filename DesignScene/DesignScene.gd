# DesignScene.gd
extends Node2D

var satellite_parts = {}  # Holds the actual part instances
var available_parts = {}  # Holds the metadata from the JSON file

var PowerSystemPart = preload("res://Classes/PowerSystemPart.gd")
var PayloadPart = preload("res://Classes/PayloadPart.gd")
var CommunicationsPart = preload("res://Classes/CommunicationsPart.gd")
var SpacecraftBusPart = preload("res://Classes/SpacecraftBusPart.gd")
var PropulsionPart = preload("res://Classes/PropulsionPart.gd")

# Keep track of the currently visible VBoxContainer
var current_visible_vbox = null  

# Import the File module
var File = preload("res://DesignScene/all_parts.json")

func _ready():
	# Assuming your category buttons are direct children of a node called "Categories"
	var category_buttons = get_node("Control/Categories")
	for button in category_buttons.get_children():
		if button is Button:
			# button.connect("pressed", self, "_on_CategoryButton_pressed", [button.name])
			# button.pressed.connect(self._on_CategoryButton_pressed)
			button.pressed.connect(self._on_CategoryButton_pressed.bind(button.name))

	initialize_parts()
	update_ui()

func initialize_parts():
	var file = FileAccess.open("res://DesignScene/all_parts.json", FileAccess.READ)
	if file.get_error() == OK:  # This checks if the file was opened without errors
		var json_text = file.get_as_text()
		file.close()

		# Create an instance of the JSON class
		var json = JSON.new()
		var json_result = json.parse(json_text, true)
		# json_result is a Dictionary with 'error' and 'result' keys
		if json_result == OK:
			var data = json.get_data()  # This is the parsed JSON data

			# Create instances of parts based on the JSON data
			for category in data.keys():
				available_parts[category] = []
				var category_vbox_path = "Control/Categories/" + category + "/" + category
				if has_node(category_vbox_path):
					var category_vbox = get_node(category_vbox_path)
					
					# Clear existing buttons if any
					for child in category_vbox.get_children():
						if child is Button:
							child.queue_free()
					
					for part_data in data[category]:
						var part = create_part_instance(category, part_data)
						available_parts[category].append(part)
						
						# Create a button for the part
						var part_button = Button.new()
						part_button.text = part_data["name"]
						part_button.call_deferred("pressed", self, "_on_PartButton_pressed", [part_button, category, part])
						
						# Add the button to the VBoxContainer
						category_vbox.add_child(part_button)
				else:
					print("Category VBoxContainer path not found: " + category_vbox_path)
		else:
			print("JSON Parse Error: ", json.get_error_message())

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
	for vbox in get_node("Control/Categories").get_children():
		for category_vbox in vbox.get_children():
			category_vbox.hide()
	pass

func show_components_for_category(category):
	# Hide all VBoxContainers
	for a_category in get_node("Control/Categories").get_children():
		a_category.hide()

	# Show the selected category's VBoxContainer
	var vbox = get_node("Control/Categories/" + category)
	vbox.show()
	current_visible_vbox = vbox

# This function gets called when a category button is pressed
func _on_CategoryButton_pressed(category_name: String):
	# Hide all other categories
	for a_category in get_node("Control/Categories").get_children():
		if a_category.name != category_name and a_category is VBoxContainer:
			a_category.hide()

	# Show or populate the category's VBox with parts
	var category_vbox_path = "Control/Categories/" + category_name
	if has_node(category_vbox_path):
		var category_vbox = get_node(category_vbox_path)
		if category_vbox.is_hidden():
			populate_category_vbox(category_vbox, category_name)
			category_vbox.show()
		else:
			category_vbox.hide()


# This function populates a given VBoxContainer with buttons for each part in a category
func populate_category_vbox(vbox: VBoxContainer, category_name: String):
	# Clear existing buttons
	for child in vbox.get_children():
		child.queue_free()  # Proper way to remove nodes

	# Add new buttons based on available parts
	for part_data in available_parts[category_name]:
		var part_button = Button.new()
		part_button.text = part_data["name"]
		# Use Callable for the second argument in connect() in Godot 4.0
		part_button.connect("pressed", self._on_PartButton_pressed.bind(part_data["name"]))
		vbox.add_child(part_button)


#func _on_CategoryButton_pressed(button: Button):
	# Now you can use the 'button' directly
	#show_components_for_category(button.name)

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
	for btn in get_node("Control/Categories/" + category).get_children():
		btn.modulate = Color(1, 1, 1) # Normal color
		btn.get_child(0).add_color_override("font_color", Color(0, 0, 0)) # Normal text color
	button.modulate = Color(0.5, 1, 0.5) # Light green for selected
	button.get_child(0).add_color_override("font_color", Color(0.5, 0.5, 0.5)) # Gray text for selected
	
# This function gets called when a part button is pressed
func _on_PartButton_pressed(part_data: Dictionary):
	# Extract category from part_data
	var category = part_data["category"]
	select_part_button(part_data)
	add_part_to_satellite(category, part_data)
	# Refresh the UI if necessary
