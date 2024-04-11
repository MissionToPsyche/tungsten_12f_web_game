# satellite_lab.gd
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$WarningPanel.set_visible(false)
	if(Global.showIntroLab == false):
		$IntroPanel.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_design_button_pressed():
	get_tree().change_scene_to_file("res://DesignScene/DesignScene.tscn")


func _on_launch_pressed():
	if(Global.satelliteBuilt == false):
		$WarningPanel.set_visible(true)
	else:
		get_tree().change_scene_to_file("res://Minigame1-Rocketlaunch/node_2d.tscn")
	
func _on_continue_pressed():
	$IntroPanel.set_visible(false)
	Global.showIntroLab = false
