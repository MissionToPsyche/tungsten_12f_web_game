# DesignScene.gd
extends Control

var satellite_parts = {}  # Holds the actual part instances
var available_parts = {}  # Holds the metadata from the JSON file

# This dictionary will track the parts added to the cart by category
var parts_in_cart = {}

# Preload the SatellitePart script file
const SatelliteParts = preload("res://Classes/SatellitePart.gd")

# Import the File module
var File = preload("res://Classes/all_parts.json")

var data_file_path = "res://Classes/all_parts.json"

func _ready():
	load_json_file(data_file_path)
	update_total_cost()  # Initialize the total cost label
	print(Global.current_satellite.get_string_representation())
	
func load_json_file(filePath: String) -> Dictionary:
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		dataFile.close()  # Don't forget to close the file after reading

		if parsedResult is Dictionary:
			for category in parsedResult.keys():
				satellite_parts[category] = []
				for part_data in parsedResult[category]:
					var part = create_part_instance(category, part_data)
					satellite_parts[category].append(part)
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist!")
	return {}  # Return an empty dictionary if the file doesn't exist or there's an error

func load_parts():
	var file = File.new()
	if file.open("res://Classes/all_parts.json", File.READ) == OK:
		var json_text = file.get_as_text()
		file.close()

		# Retrieve data
		var json = JSON.new()
		var error = json.parse(json_text)
		
		if error == OK:
			var data_received = json.data
			for category in data_received.keys():
				satellite_parts[category] = []
				for part_data in data_received[category]:
					var part = create_part_instance(category, part_data)
					satellite_parts[category].append(part)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_text, " at line ", json.get_error_line())
	else:
		print("Failed to open JSON file.")

func create_part_instance(category: String, part_data: Dictionary) -> SatellitePart:
	var part
	match category:
		"PowerSystem":
			part = SatelliteParts.PowerSystemPart.new(part_data)
		"Communications":
			part = SatelliteParts.CommunicationsPart.new(part_data)
		"Payload":
			part = SatelliteParts.PayloadPart.new(part_data)
		"Propulsion":
			part = SatelliteParts.PropulsionPart.new(part_data)
		"SpacecraftBus":
			part = SatelliteParts.SpacecraftBusPart.new(part_data)
		_:
			print("Unknown category: %s" % category)
	return part


# Method to add a part to the shop item list in the correct format
func add_part_to_shop_item_list(part: SatellitePart):
	# Use the part's name for the item list
	var text = part.part_name

	# Add the part name to the item list
	$Panel/ShopPanel/ShopItemList.add_item(text)

# Method to load parts into the ShopItemList based on category
func load_parts_into_shop_item_list(category: String):
	$Panel/ShopPanel/ShopItemList.clear()  # Clear the current list
	if category in satellite_parts:
		for part in satellite_parts[category]:
			print(part.get_string_representation())
			add_part_to_shop_item_list(part)
			
# Update the _on_add_to_cart_button_pressed function to call update_total_cost
func _on_add_to_cart_button_pressed():
	var selected_indices = $Panel/ShopPanel/ShopItemList.get_selected_items()
	for index in selected_indices:
		var part_name = $Panel/ShopPanel/ShopItemList.get_item_text(index)
		var part = find_part_by_name(part_name)
		if part:
			# Check if a part from this category has already been added
			if part.get_category() in parts_in_cart:
				print("A part from category " + part.get_category() + " has already been added.")
				continue  # Skip adding this part
			parts_in_cart[part.get_category()] = part_name
			$Panel/CartPanel/CartItemList.add_item(part.part_name)
			update_total_cost()  # Update the total cost whenever a part is added
		else:
			print("Part not found: " + part_name)

# To remove an item from the cart, you need a function that's called when the "remove from cart" button is pressed
# Update the _on_remove_from_cart_button_pressed function to call update_total_cost
func _on_remove_from_cart_button_pressed():
	var selected_indices = $Panel/CartPanel/CartItemList.get_selected_items()
	for index in selected_indices:
		var part_name = $Panel/CartPanel/CartItemList.get_item_text(index)
		# Find the category of the part to remove it from the parts_in_cart dictionary
		var part = find_part_by_name(part_name)
		if part:
			parts_in_cart.erase(part.get_category())
			$Panel/CartPanel/CartItemList.remove_item(index)
			update_total_cost()  # Update the total cost whenever a part is removed

func find_part_by_name(part_name: String) -> SatellitePart:
	for category in satellite_parts.keys():
		for part in satellite_parts[category]:
			if part.part_name == part_name:
				return part
	return null

func _on_shop_item_selected(index: int):
	var part_name = $Panel/ShopPanel/ShopItemList.get_item_text(index)
	var part = find_part_by_name(part_name)
	if part:
		$Panel/ShopPanel/DescriptionLabel.text = part.get_string_representation()
	else:
		$Panel/ShopPanel/DescriptionLabel.text = "Part not found: " + part_name

# Use this function to update the total cost when a part is added or removed
func update_total_cost():
	var total_cost = 0.0
	for part_name in parts_in_cart.values():
		var part = find_part_by_name(part_name)
		if part:
			total_cost += part.cost
	# Format the total cost as a string with two decimal places
	var total_cost_str = "%.2f" % total_cost
	$Panel/CartPanel/TotalLabel.text = "Total: $" + total_cost_str

# This method checks if all categories are represented in the cart
# This method checks if all required categories have at least one part in the cart
func are_all_categories_represented() -> bool:
	# Define the required categories
	var required_categories = ["Communications", "Payload", "Power System", "Propulsion", "Spacecraft Bus"]
	
	# List to keep track of categories present in the cart
	var categories_in_cart = []

	# Iterate over each item in the CartItemList
	for i in range($Panel/CartPanel/CartItemList.get_item_count()):
		var part_name = $Panel/CartPanel/CartItemList.get_item_text(i)
		var part = find_part_by_name(part_name)
		if part:
			var category = part.get_category()
			if category not in categories_in_cart:
				categories_in_cart.append(category)
	print(categories_in_cart)
	# Check if each required category is present in the categories_in_cart list
	for category in required_categories:
		if category not in categories_in_cart:
			return false  # A required category is missing

	return true  # All required categories are represented

# This method constructs the satellite from selected parts
func build_satellite() -> Satellite:
	var satellite = Satellite.new()
	for category in parts_in_cart.keys():
		var part_name = parts_in_cart[category]
		var part = find_part_by_name(part_name)
		satellite.add_part(part)
	return satellite  # Return the constructed satellite object

# Shopping ItemList Populating Functions

func _on_communication_button_pressed():
	load_parts_into_shop_item_list("Communications")

func _on_propulsion_button_pressed():
	load_parts_into_shop_item_list("Propulsion")

func _on_power_system_button_pressed():
	load_parts_into_shop_item_list("PowerSystem")

func _on_spacecraft_bus_button_pressed():
	load_parts_into_shop_item_list("SpacecraftBus")

func _on_payload_button_pressed():
	load_parts_into_shop_item_list("Payload")
	
# This method is called when the CheckoutButton is pressed
func _on_checkout_button_pressed():
	if not are_all_categories_represented():
		$Panel/CartPanel/WarningLabel.text = "Need one part from every category!"
	else:
		$Panel/CartPanel/WarningLabel.text = ""
		$Panel/ConfirmPanel.show()

# This method is called when the NoButton inside ConfirmPanel is pressed
func _on_no_button_pressed():
	$Panel/ConfirmPanel.hide()

# This method is called when the YesButton inside ConfirmPanel is pressed
func _on_yes_button_pressed():
	var satellite = build_satellite()  # Construct the satellite and store it in a local variable
	Global.current_satellite = satellite  # Assign the constructed satellite to the global variable
	print(Global.current_satellite.get_string_representation())  # Optional: Print the satellite details for debugging
	get_tree().change_scene_to_file("res://BuilderScene/satellite-lab.tscn")
	
# Scene Navigation

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://BuilderScene/satellite-lab.tscn")


