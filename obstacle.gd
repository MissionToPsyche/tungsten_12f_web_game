extends Area2D


func _on_body_entered(body):
	if(body.name =="Player"):
		message_label.text = "GAME OVER! Try again"
		message_label.visible = true
