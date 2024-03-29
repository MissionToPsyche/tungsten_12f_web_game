extends Node2D
@onready var animation = $SceneAnimator

# Called when the node enters the scene tree for the first time.
func _ready():
	var child_node = $ParallaxBackground/GameLayer
	var camera = $SceneCamera
	camera.is_current()
	#camera.zoom = Vector2(2,2)
	child_node.connect("rocketLaunched",afterRocketLaunch)


func afterRocketLaunch():
	animation.play("RocketLauncCameraPan")

