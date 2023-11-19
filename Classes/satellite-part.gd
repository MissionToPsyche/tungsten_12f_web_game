# SatellitePart.gd
extends Node
class_name SatellitePart

var part_name  = "Generic Part"
var weight = 0  # in kilograms
var cost = 0.0  # in USD
var compatibility = []  # list of names of compatible parts

func _init(_part_name , _weight, _cost, _compatibility):
	part_name = part_name 
	weight = _weight
	cost = _cost
	compatibility = _compatibility

func is_compatible_with(other_part: SatellitePart) -> bool:
	# Checks if 'other_part.name' is in the compatibility list
	return other_part.name in compatibility

