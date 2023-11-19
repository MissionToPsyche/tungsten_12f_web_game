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

func _init(_part_name, _weight, _cost, _compatibility, _power_source, _solar_panel_efficiency, _battery_capacity, _battery_type, _voltage_regulation, _power_consumption, _energy_harvesting):
	super._init(_part_name, _weight, _cost, _compatibility)  # Call the parent constructor
	power_source = _power_source
	solar_panel_efficiency = _solar_panel_efficiency
	battery_capacity = _battery_capacity
	battery_type = _battery_type
	voltage_regulation = _voltage_regulation
	power_consumption = _power_consumption
	energy_harvesting = _energy_harvesting
