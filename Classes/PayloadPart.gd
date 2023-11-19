# PayloadPart.gd
extends SatellitePart
class_name PayloadPart

var instrument_name = ""
var instrument_type = ""
var purpose = ""
var sensing_technology = ""
var spectral_range = ""
var resolution = ""
var field_of_view = 0.0
var detection_limit = 0.0
var data_output = ""
var sampling_rate = 0.0
var data_processing = ""
var calibration = ""
var power_consumption = 0.0

func _init(_data: Dictionary):
	super._init(_data.name, _data.weight, _data.cost, _data.compatibility)
	instrument_name = _data.instrument_name
	instrument_type = _data.instrument_type
	purpose = _data.purpose
	sensing_technology = _data.sensing_technology
	spectral_range = _data.spectral_range
	resolution = _data.resolution
	field_of_view = _data.field_of_view
	detection_limit = _data.detection_limit
	data_output = _data.data_output
	sampling_rate = _data.sampling_rate
	data_processing = _data.data_processing
	calibration = _data.calibration
	power_consumption = _data.power_consumption
