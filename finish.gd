extends Area2D

@onready var message_label = %message_label

func _on_body_entered(body):
	if(body.name =="Player"):
		message_label.text = "LEVEL COMPLETE!"
		message_label.visible = true
