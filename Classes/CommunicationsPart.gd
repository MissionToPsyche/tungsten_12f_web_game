# CommunicationsPart.gd
extends SatellitePart
class_name CommunicationsPart

var frequency_band = ""
var antenna_type = ""
var transceiver = {}
var signal_strength = 0.0
var data_rate = 0.0

func _init(_data: Dictionary):
	super._init(_data.name, _data.weight, _data.cost, _data.compatibility)
	frequency_band = _data.frequency_band
	antenna_type = _data.antenna_type
	transceiver = _data.transceiver
	signal_strength = _data.signal_strength
	data_rate = _data.data_rate
