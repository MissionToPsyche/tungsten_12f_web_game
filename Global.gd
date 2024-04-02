# Global.gd
extends Node

# Preload the SatellitePart script file
const SatelliteParts = preload("res://Classes/SatellitePart.gd")

# Score variable to keep track of the player's score
var score: int = 0
var current_satellite: Satellite
var input_allowed = true


var decision_tree_state = {
	"current_position": "start",
	"path_history": [],
	"next_position": null,
	"is_first_load": true,
}

func set_input_allowed(allowed):
	input_allowed = allowed

func _init():
	# Initialize the current satellite
	current_satellite = Satellite.new()
#
#	# Create individual parts with example data
#	var comm_part = SatelliteParts.CommunicationsPart.new({"name": "Basic Comm", "weight": 50, "cost": 1000.0, "base_health": 100.0})
#	var payload_part = SatelliteParts.PayloadPart.new({"name": "Standard Payload", "weight": 150, "cost": 5000.0, "base_health": 200.0, "research_ability": "Basic Research"})
#	var power_part = SatelliteParts.PowerSystemPart.new({"name": "Solar Panels", "weight": 75, "cost": 3000.0, "base_health": 150.0, "fuel": 100.0})
#	var propulsion_part = SatelliteParts.PropulsionPart.new({"name": "Ion Drive", "weight": 200, "cost": 10000.0, "base_health": 250.0, "fuel_consumption": 0.5, "thrust": 5.0})
#	var bus_part = SatelliteParts.SpacecraftBusPart.new({"name": "Standard Bus", "weight": 500, "cost": 8000.0, "base_health": 400.0, "bonus_health": 100.0})
#
#	# Add parts to the satellite
#	current_satellite.add_part(comm_part)
#	current_satellite.add_part(payload_part)
#	current_satellite.add_part(power_part)
#	current_satellite.add_part(propulsion_part)
#	current_satellite.add_part(bus_part)
