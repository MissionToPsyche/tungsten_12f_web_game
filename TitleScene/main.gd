extends Node2D


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://IntroScene/node_2d.tscn")

func _on_credit_pressed():
	get_tree().change_scene_to_file("res://CreditsScene/CreditsScene.tscn")

