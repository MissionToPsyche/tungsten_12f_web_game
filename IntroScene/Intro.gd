extends Node2D

var female_scientist
var male_scientist
var yes_button
var no_button
var panel1
var background
var timer
var player_choice = ""

func _ready():
	female_scientist = $female_nasa_scientist
	male_scientist = $male_nasa_scientist
	yes_button = $yes
	no_button = $no
	panel1 = $Panel1
	background = $lab_background

	male_scientist.visible = false
	yes_button.visible = false
	no_button.visible = false

	yes_button.connect("pressed", self, "_on_button_pressed", ["yes"])
	no_button.connect("pressed", self, "_on_button_pressed", ["no"])

	start_sequence()

func start_sequence():
	timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.connect("timeout", self, "_on_intro_end")
	add_child(timer)
	timer.start()

func _on_intro_end():
	get_tree().change_scene("res://TeamBuilderScene.tscn")

func _on_team_selected():
	male_scientist.visible = true
	yes_button.visible = true
	no_button.visible = true
	background.scale *= Vector2(1.5, 1.5)
	male_scientist.scale *= Vector2(1.5, 1.5)

func _on_button_pressed(choice):
	player_choice = choice
	print("Player chose: " + choice)
	if choice == "yes":
		print("Proceeding with the chosen team")
		# Load next scene or continue the game
	elif choice == "no":
		print("Returning to team selection")
		get_tree().change_scene("res://TeamBuilderScene.tscn")
