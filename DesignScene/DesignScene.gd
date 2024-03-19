# DesignScene.gd
extends Node2D

var satellite_parts = {}  # Holds the actual part instances
var available_parts = {}  # Holds the metadata from the JSON file

# Preload the SatellitePart script file
const SatelliteParts = preload("res://Classes/SatellitePart.gd")

# Keep track of the currently visible VBoxContainer
var current_visible_vbox = null  

# Import the File module
var File = preload("res://DesignScene/all_parts.json")

func _ready():
	initialize_parts()

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
						# part_button.call_deferred("pressed", self, "_on_PartButton_pressed", [part_button, category, part])
						part_button.connect("pressed", self._on_PartButton_pressed.bind(part_data["name"]))
						
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


