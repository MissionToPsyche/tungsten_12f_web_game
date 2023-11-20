# PropulsionPart.gd
extends SatellitePart
class_name PropulsionPart

var propulsion_type = ""
var thrust = 0.0
var specific_impulse = 0.0
var engine_lifespan = 0
var fuel_type = ""
var maneuverability = ""

func _init(_data: Dictionary):
	super._init(_data.name, _data.weight, _data.cost, _data.compatibility)
	propulsion_type = _data.propulsion_type
	thrust = _data.thrust
	specific_impulse = _data.specific_impulse
	engine_lifespan = _data.engine_lifespan
	fuel_type = _data.fuel_type
	maneuverability = _data.maneuverability
