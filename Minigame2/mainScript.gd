extends Node2D
@onready var animation = $SceneAnimator
@onready var button = $Button 

# Called when the node enters the scene tree for the first time.
func _ready():
	button.visible = false
	var child_node = $ParallaxBackground/GameLayer
	var camera = $SceneCamera
	camera.is_current()
	#camera.zoom = Vector2(2,2)
	child_node.connect("rocketLaunched",afterRocketLaunch)
	animation.connect("animation_finished", onRocketLaunchAnimationFinished)


func afterRocketLaunch():
	animation.play("RocketLauncCameraPan")

func onRocketLaunchAnimationFinished(anim_name):
	if anim_name == "RocketLauncCameraPan":
		# Show the button after the animation is complete
		button.visible = true
		button.connect("pressed", onButtonPressed)
		
func onButtonPressed():
	# Load the Minigame2 scene
	var minigame2_scene = preload("res://Minigame2.tscn")
	
	# Create an instance of the Minigame2 scene
	var minigame2_instance = minigame2_scene.instantiate()
	
	# Add the new instance to the scene tree
	get_tree().get_root().add_child(minigame2_instance)
	
	# Queue-free the current scene
	queue_free()
