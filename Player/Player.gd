extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -550.0
#var isMovementEnabled = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
@onready var anim = get_node("AnimationPlayer")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("shoot") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction == -1: 
		get_node("AnimatedSprite2D").flip_h = true 
	elif direction ==1: 
		get_node("AnimatedSprite2D").flip_h = false 
		
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
		if velocity.y == 0:
			anim.play("idle")
			
	if velocity.y > 0: 
		anim.play("fall")
			
	move_and_slide()
	


