extends Area2D
class_name Player

signal message_sent(message)
var plBullet := preload("res://Minigame2/bullet.tscn")

@export var speed = 200
@export var maxTilt = 20
@onready var invinTimer = $InvincibilityTimer
@export var TiltSpeed = 1
var damageInvinTime: float = 2.0
@onready var collistion_rect: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shootSound = $shootsound
var life: int = 3
var cam: Node = null

var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_rect = get_viewport_rect()
	var screen_width = viewport_rect.size.x
	var screen_height = viewport_rect.size.y
	var sprite_size = sprite_2d.texture.get_size()
	position.x = screen_width / 2
	position.y = screen_height - sprite_size.y / 3
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_axis("move_left","move_right")
	
	if input > 0:
		direction = Vector2.RIGHT
		if(sprite_2d.rotation_degrees < maxTilt):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees + TiltSpeed
	elif input < 0:
		direction = Vector2.LEFT
		if(sprite_2d.rotation_degrees > -maxTilt):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees - TiltSpeed
	else:
		direction = Vector2.ZERO
		if(sprite_2d.rotation_degrees > 0.5):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees - TiltSpeed
		elif(sprite_2d.rotation_degrees < -0.5):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees + TiltSpeed
			
	if Input.is_action_just_pressed("shoot"):
		var bulletSprite = plBullet.instantiate()
		bulletSprite.position = position
		get_tree().current_scene.add_child(bulletSprite)
		shootSound.play()
	
	var delta_mvmt = speed * delta * direction.x
	position.x += delta_mvmt
	
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0 , viewRect.size.x)

func damage(amount: int):
	if !invinTimer.is_stopped():
		return
		
	invinTimer.start(damageInvinTime)
	emit_signal("message_sent", "hit")
	$AnimationPlayer.play("Player_hit")
	life -= amount
	if life <= 0:
		cam.shake(10)
		$deathSound.play()
		print("player died")
		emit_signal("message_sent", "died")
	else:
		cam = find_node_by_name(get_tree().current_scene, "Cam")
		$hitSound.play()
		cam.shake(10)
		
		
func find_node_by_name(node: Node, name: String) -> Node:
	if node.name == name:
		return node
	
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		var result = find_node_by_name(child, name)
		if result != null:
			return result
	
	return null
