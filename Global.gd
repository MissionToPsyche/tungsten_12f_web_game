# Global.gd
extends Node

# Preload the SatellitePart script file
const SatelliteParts = preload("res://Classes/SatellitePart.gd")

# Toggles for the satellite lab and design scene
var showIntroLab = true
var showIntroDesign = true
var satelliteBuilt = false

# Score variable to keep track of the player's score
var score = 0
var previous_score = 0
var current_satellite: Satellite
var input_allowed = true


#Team Builder scene
#------------------
var chosen_characters = []
#Decision tree scene
#--------------------
var character_clicked = [false,false,false]
var selected_mission_character = []
var selected_mission_character_stats = []
var points_per_game = []
var active_arrows = []
var current_position = "start"
var next_buttons = ["Robotics", "Navigation"]  # Set initial next buttons
var next_arrows = [1, 2]  # Set initial next arrows
var player_path = []

var button_states = {
	"button": true,
	"button2": true,
	"button3": true
}

var points_per_minigame = []


func reset_decision_tree_state():
	active_arrows = []
	current_position = "start"
	next_buttons = ["Robotics", "Navigation"]  # Reset initial next buttons
	next_arrows = [1, 2]  # Reset initial next arrows
	player_path = []

func set_input_allowed(allowed):
	input_allowed = allowed

func _init():
	# Initialize the current satellite
	current_satellite = Satellite.new()
	
	
func add_points(points, skill_frame):
	var bonus_points = points + points * 10 * (skill_frame % 5)
	score += bonus_points
	points_per_minigame.append({"base_points": points, "bonus_points": bonus_points})
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
