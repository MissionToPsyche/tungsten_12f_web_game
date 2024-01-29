extends Popup

var message_label: Label

func _ready():
	# Get the Label node where the message will be displayed
	message_label = get_node("MessageLabel")  # Adjust the path to your Label node within the popup

func show_notification(message: String):
	# Set the message to the label
	message_label.text = message
	# Show the popup
	popup_centered()  # Or just .popup() if you don't want it centered

func hide_notification():
	# Hide the popup
	hide()

# Optional: You can connect button signals to close the popup if you have buttons on it
func _on_close_button_pressed():
	hide_notification()
