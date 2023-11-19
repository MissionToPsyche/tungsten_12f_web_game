# PowerSystemPart.gd
extends SatellitePart
class_name PowerSystemPart

var power_source = ""
var solar_panel_efficiency = 0.0
var battery_capacity = 0
var battery_type = ""
var voltage_regulation = false
var power_consumption = 0
var energy_harvesting = false

func _init(part_data: Dictionary):
	# Extract values from the part_data dictionary
	var _part_name = part_data["part_name"]
	var _weight = part_data["weight"]
	var _cost = part_data["cost"]
	var _compatibility = part_data["compatibility"]
	power_source = part_data["power_source"]
	solar_panel_efficiency = part_data["solar_panel_efficiency"]
	battery_capacity = part_data["battery_capacity"]
	battery_type = part_data["battery_type"]
	voltage_regulation = part_data["voltage_regulation"]
	power_consumption = part_data["power_consumption"]
	energy_harvesting = part_data["energy_harvesting"]

	# Call the parent constructor
	super._init(_part_name, _weight, _cost, _compatibility)
