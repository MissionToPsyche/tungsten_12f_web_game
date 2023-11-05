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
	# Reference the child nodes
	female_scientist = $female_nasa_scientist
	male_scientist = $male_nasa_scientist
	yes_button = $yes
	no_button = $no
	panel1 = $Panel1
	background = $lab_background

	# Initially hide the male scientist, buttons
	male_scientist.visible = false
	yes_button.visible = false
	no_button.visible = false

	# Connect the button signals using Callable with bind
	yes_button.connect("pressed", Callable(self, "_on_button_pressed").bind("yes"))
	no_button.connect("pressed", Callable(self, "_on_button_pressed").bind("no"))

	# Start the sequence after ready
	call_deferred("start_sequence")

func start_sequence():
	# Create a Timer to wait 5 seconds
	timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	print("Timer finished, hiding female scientist and panel1")
	# This function is called after the Timer times out
	female_scientist.visible = false
	panel1.visible = false

	print("Female Scientist Visible: ", female_scientist.visible)
	print("Panel1 Visible: ", panel1.visible)

	male_scientist.visible = true
	yes_button.visible = true
	no_button.visible = true

	# Magnify the background sprite by 20%
	background.scale *= Vector2(1.5, 1.5)
	male_scientist.scale *= Vector2(1.5, 1.5)

	# Remove the Timer node after we're done with it
	timer.queue_free()


func _on_button_pressed(choice):
	# Save the player's choice
	player_choice = choice
	# Do something with the choice here...
	print("Player chose: " + choice)
