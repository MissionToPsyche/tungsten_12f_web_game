extends Node2D
	
var satellite_parts = [] # List to hold the parts currently on the satellite
var available_parts = [] # List of available parts for the player to choose from

func _ready():
	initialize_parts()
	update_ui()

func initialize_parts():
	# Load parts from a file or create them here
	pass

func update_ui():
	# Update the UI based on available parts and current satellite configuration
	pass

func add_part_to_satellite(part: SatellitePart):
	if part.is_compatible_with_current_configuration():
		satellite_parts.append(part)
		update_ui()

func remove_part_from_satellite(part: SatellitePart):
	satellite_parts.erase(part)
	update_ui()

func can_launch_satellite() -> bool:
	# Check if all required parts are present and compatible
	for part in satellite_parts:
		if part.is_required and not part.is_compatible_with_current_configuration():
			return false
	return true

func launch_satellite():
	if can_launch_satellite():
		# Proceed with launch
		print("Launching satellite!")
	else:
		# Notify the player that the satellite is not ready
		print("Satellite is not ready to launch.")
