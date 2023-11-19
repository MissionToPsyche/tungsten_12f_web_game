# SpacecraftBusPart.gd
extends SatellitePart
class_name SpacecraftBusPart

var bus_type = ""
var structure = ""
var size = {}
var durability = 0

func _init(_data: Dictionary):
	super._init(_data.name, _data.weight, _data.cost, _data.compatibility)
	bus_type = _data.bus_type
	structure = _data.structure
	size = _data.size
	durability = _data.durability
