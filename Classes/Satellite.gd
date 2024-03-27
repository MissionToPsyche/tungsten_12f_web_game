# Satellite.gd
extends Node

class_name Satellite

# Preload the SatellitePart script file
const SatelliteParts = preload("res://Classes/SatellitePart.gd")

var communications_part: SatelliteParts.CommunicationsPart
var payload_parts = []  # This can hold up to 3 payload parts
var power_system_part: SatelliteParts.PowerSystemPart
var propulsion_part: SatelliteParts.PropulsionPart
var spacecraft_bus_part: SatelliteParts.SpacecraftBusPart

var total_health: float = 0.0
var total_fuel: float = 0.0  # Total fuel might be relevant for power systems with batteries
var total_thrust: float = 0.0
var total_weight: float = 0.0
var total_cost: float = 0.0

func _init():
	pass  # Default constructor

# Method to add a part to the satellite
func add_part(part: SatellitePart):
	if part is SatelliteParts.CommunicationsPart:
		communications_part = part
	elif part is SatelliteParts.PowerSystemPart:
		power_system_part = part
	elif part is SatelliteParts.PropulsionPart:
		propulsion_part = part
	elif part is SatelliteParts.SpacecraftBusPart:
		spacecraft_bus_part = part
	elif part is SatelliteParts.PayloadPart:
		if payload_parts.size() < 3:
			payload_parts.append(part)
		else:
			print("Cannot add more than 3 payload parts.")
	else:
		print("Unknown part type: ", part)
	update_total_stats()

# Method to remove a part from the satellite, by type
func remove_part(part_type: String):
	match part_type:
		"CommunicationsPart":
			communications_part = null
		"PowerSystemPart":
			power_system_part = null
		"PropulsionPart":
			propulsion_part = null
		"SpacecraftBusPart":
			spacecraft_bus_part = null
		"PayloadPart":
			if payload_parts.size() > 0:
				payload_parts.pop_back()
		_:
			print("Unknown part type: ", part_type)
	update_total_stats()

# Method to update the total stats of the satellite
func update_total_stats():
	total_health = 0.0
	total_fuel = 0.0
	total_thrust = 0.0
	total_weight = 0.0
	total_cost = 0.0
	
	# Update stats based on each part
	if communications_part:
		total_weight += communications_part.weight
		total_health += communications_part.base_health
		total_cost += communications_part.cost
	
	if power_system_part:
		total_weight += power_system_part.weight
		total_health += power_system_part.base_health
		total_fuel += power_system_part.fuel
		total_cost += power_system_part.cost
	
	if propulsion_part:
		total_weight += propulsion_part.weight
		total_health += propulsion_part.base_health
		total_thrust += propulsion_part.thrust
		total_fuel -= propulsion_part.fuel_consumption
		total_cost += propulsion_part.cost
	
	if spacecraft_bus_part:
		total_weight += spacecraft_bus_part.weight
		total_health += spacecraft_bus_part.base_health + spacecraft_bus_part.bonus_health
		total_cost += spacecraft_bus_part.cost

	for payload_part in payload_parts:
		total_weight += payload_part.weight
		total_health += payload_part.base_health
		total_cost += payload_part.cost

# Method to get the research abilities from payload parts
func get_research_abilities():
	var abilities = []
	for payload_part in payload_parts:
		abilities += payload_part.research_abilities
	return abilities

# Method to check if the satellite has a particular part type
func has_part(part_type: String) -> bool:
	match part_type:
		"CommunicationsPart":
			return communications_part != null
		"PowerSystemPart":
			return power_system_part != null
		"PropulsionPart":
			return propulsion_part != null
		"SpacecraftBusPart":
			return spacecraft_bus_part != null
		"PayloadPart":
			return payload_parts.size() > 0
		_:
			print("Unknown part type: ", part_type)
			return false
			
# Method to get the string representation of the satellite
func get_string_representation() -> String:
	var representation = "Satellite Details:\n"
	if communications_part:
		representation += "Communications Part: " + communications_part.get_string_representation() + "\n"
	if power_system_part:
		representation += "Power System Part: " + power_system_part.get_string_representation() + "\n"
	if propulsion_part:
		representation += "Propulsion Part: " + propulsion_part.get_string_representation() + "\n"
	if spacecraft_bus_part:
		representation += "Spacecraft Bus Part: " + spacecraft_bus_part.get_string_representation() + "\n"

	representation += "Payload Parts: \n"
	for payload_part in payload_parts:
		representation += payload_part.get_string_representation() + "\n"

	representation += "Total Weight: %.2f kgs\n" % total_weight
	representation += "Total Cost: $%.2f\n" % total_cost
	representation += "Total Health: %.2f\n" % total_health
	representation += "Total Thrust: %.2f\n" % total_thrust
	representation += "Total Fuel: %.2f\n" % total_fuel
	return representation
