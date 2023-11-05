# SatellitePart.gd
extends Node
class_name SatellitePart

var part_name = "Generic Part"
var type = "None"
var is_required = false
var dependencies = []

func _ready():
	pass

func is_compatible_with(other_part: SatellitePart) -> bool:
	# Define logic to check compatibility between parts
	return true
