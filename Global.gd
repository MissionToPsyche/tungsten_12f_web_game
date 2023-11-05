extends Node
class_name Global

var points = 0
var milestones = {10: "Item1", 20: "Item2", 30: "Item3"}
var points_label_path = "/root/MainScene/PointsLabel"  # The node path to your points display label.

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
	# Check if the player has enough points to buy the cheapest item
	for cost in milestones.keys():
		if points >= cost:
			# Notify the player
			show_notification("You can buy " + milestones[cost] + "!")
			break

func show_notification(message: String):
	# This function should show the notification to the player.
	# You could use a Popup, or a dedicated notification area in your UI.
	print("Notification: ", message)  # Placeholder for actual notification logic

func update_points_display():
	# Check if the points_label node exists
	var points_label = get_node_or_null(points_label_path)
	if points_label:
		points_label.text = str(points)
	else:
		print("Error: PointsLabel node not found at path: ", points_label_path)

# You might want to add a function to handle purchasing items.
func purchase_item(cost: int):
	if points >= cost:
		points -= cost
		update_points_display()
		# You would also need to handle the logic for what happens when the item is purchased.
	else:
		print("Not enough points to purchase the item.")
