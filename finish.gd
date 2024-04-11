extends Area2D

var manager_instance

func _ready():
	manager_instance = preload("res://game_manager.gd").new()

func _on_body_entered(body):
	if(body.name =="Player"):
		get_tree().change_scene_to_file("res://DecesionTreeScene/decision_tree.tscn")
		manager_instance.transfer_points_to_global()
