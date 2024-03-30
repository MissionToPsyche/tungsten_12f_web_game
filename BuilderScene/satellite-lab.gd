# satellite_lab.gd
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_design_button_pressed():
	get_tree().change_scene_to_file("res://DesignScene/DesignScene.tscn")


func _on_launch_pressed():
	get_tree().change_scene_to_file("res://Minigame1-Rocketlaunch/node_2d.tscn")
