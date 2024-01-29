extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Black_in")
	await get_tree().create_timer(6).timeout
	$AnimationPlayer.play("Black-out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://TitleScene/main.tscn")
