extends Node
class_name Global

var points = 0
var milestones = {10: "Item1", 20: "Item2", 30: "Item3", 40: "Item4", 50: "Item5"}
var points_label_path = "/root/Node2D/points_label"  # The node path to your points display label.
var last_milestone_reached = 0  # Keep track of the last milestone reached

func _ready():
	# Initialize any necessary data on game start
	update_points_display()  # Update points display at game start

func add_points(value):
	points += value
	# Trigger notification check
	check_for_notifications()
	# Update the UI
	update_points_display()

func check_for_notifications():
	# Sort the milestones' costs and check if the player has enough points to buy any items since last check
	var sorted_costs = milestones.keys()
	sorted_costs.sort()  # This will sort the array of keys
	for cost in sorted_costs:
		if points >= cost and cost > last_milestone_reached:
			# Notify the player
			show_notification("You have enough points to buy " + milestones[cost] + "!")
			last_milestone_reached = cost  # Update the last milestone reached
			break  # Exit the loop after the first notification


func show_notification(message: String):
	# Assuming the Popup is already in the scene tree
	var popup = get_node("/root/Node2D/Popup")  # Adjust the path to your popup node
	if popup:
		popup.show_notification(message)
	else:
		print("Error: Popup node not found at path: /root/Node2D/Popup")

func update_points_display():
	# Check if the points_label node exists
	var points_label = get_node_or_null(points_label_path)
	if points_label:
		points_label.text = str(points)
	else:
		print("Error: points_label node not found at path: ", points_label_path)
