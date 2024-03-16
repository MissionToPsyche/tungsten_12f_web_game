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

# Derived class for communications parts
class CommunicationsPart extends SatellitePart:
	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)

# Derived class for payload parts
class PayloadPart extends SatellitePart:
	var research_abilities = []  # List of strings defining research abilities

	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		research_abilities = _data.research_abilities

# Derived class for power system parts
class PowerSystemPart extends SatellitePart:
	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)

# Derived class for propulsion parts
class PropulsionPart extends SatellitePart:
	var fuel_consumption = 0.0  # Rate of fuel consumption
	var thrust = 0.0  # Thrust for speed in minigames

	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		fuel_consumption = _data.fuel_consumption
		thrust = _data.thrust

# Derived class for spacecraft bus parts
class SpacecraftBusPart extends SatellitePart:
	var bonus_health = 0.0  # Bonus health added to the base health of other parts

	func _init(_data: Dictionary):
		super._init(_data.name, _data.weight, _data.cost, _data.base_health)
		bonus_health = _data.bonus_health
