# SatelliteParts.gd
extends Node

# Base class for all satellite parts
class_name SatellitePart
var part_name = "Generic Part"
var weight = 0  # in kilograms
var cost = 0.0  # in USD
var base_health = 0.0  # Base health provided by the part

func _init(_part_name: String, _weight: int, _cost: float, _base_health: float):
	part_name = _part_name
	weight = _weight
	cost = _cost
	base_health = _base_health
	
func get_string_representation() -> String:
	var attributes = [
		"Part Name: %s" % part_name,
		"Weight: %d kgs" % weight,
		"Cost: $%.2f" % cost,
		"Health: %.2f" % base_health
	]
	return "\n".join(attributes)

func get_category() -> String:
		return "Generic"  # Replace with actual category for derived classes


# Derived class for communications parts
class CommunicationsPart extends SatellitePart:
	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		
	func get_string_representation() -> String:
		var base_str = super.get_string_representation()
		# Add any specific attributes for CommunicationsPart after base_str if needed
		return base_str
	
	func get_category() -> String:
		return "Communications"

# Derived class for payload parts
class PayloadPart extends SatellitePart:
	var research_ability = ""  # A single string defining the research ability

	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		research_ability = _data.research_ability  # Assuming the JSON key is also updated to 'research_ability'

	func get_string_representation() -> String:
		var base_str = super.get_string_representation()
		var research_str = "Research Ability: %s" % research_ability
		return "%s\n%s" % [base_str, research_str]
	
	func get_category() -> String:
		return "Payload"

# Derived class for power system parts
class PowerSystemPart extends SatellitePart:
	var fuel = 0.0 # Amount of fuel
	
	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		fuel = _data.fuel
		
	func get_string_representation() -> String:
		var base_str = super.get_string_representation()
		var fuel_str = "Fuel: %.2f" % fuel
		return "%s\n%s" % [base_str, fuel_str]
		
	func get_category() -> String:
		return "Power System"

# Derived class for propulsion parts
class PropulsionPart extends SatellitePart:
	var fuel_consumption = 0.0  # Rate of fuel consumption
	var thrust = 0.0  # Thrust for speed in minigames

	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		fuel_consumption = _data.fuel_consumption
		thrust = _data.thrust
		
	func get_string_representation() -> String:
		var base_str = super.get_string_representation()
		var propulsion_str = "Fuel Consumption: %.2f\nThrust: %.2f" % [fuel_consumption, thrust]
		return "%s\n%s" % [base_str, propulsion_str]
		
	func get_category() -> String:
		return "Propulsion"

# Derived class for spacecraft bus parts
class SpacecraftBusPart extends SatellitePart:
	var bonus_health = 0.0  # Bonus health added to the base health of other parts

	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		bonus_health = _data.bonus_health

	func get_string_representation() -> String:
		var base_str = super.get_string_representation()
		var bus_str = "Bonus Health: %.2f" % bonus_health
		return "%s\n%s" % [base_str, bus_str]
		
	func get_category() -> String:
		return "Spacecraft Bus"
		

