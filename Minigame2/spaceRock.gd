extends Area2D

@onready var hit_flash_player = $AnimationPlayer
@export var minSpeed: float = 10
@export var maxSpeed: float = 20
@export var minRotate: float = -10
@export var maxRotate: float = 10

@export var life: int = 5
signal message_sent(message)

var speed: float = 0
var rotationRate: float = 0

func _ready():
	speed = randf_range(minSpeed, maxSpeed)
	rotationRate = randf_range(minRotate,maxRotate)
	var scale = get_scale()
	life = calculate_life(scale.x)
	
func calculate_life(scale_factor):
	var min_life = 2
	var max_life = 7
	var scaled_factor = 0.5 + scale_factor * (1.5 - 0.5)
	return int(3 * scaled_factor)
	
	
func _physics_process(delta):
	rotation_degrees += rotationRate * delta
	position.y += speed * delta

func damage(ammount: int):
	if life <= 0 :
		return
	life -= ammount
	if life <= 0:
		if (hit_flash_player.is_playing()) and hit_flash_player.current_animation == "Explosion":
			return
		else:
			$RockDestroyed.play()
			hit_flash_player.play("Explosion")
			emit_signal("message_sent", "scored explosion")
	else:
		hit_flash_player.play("Hit_animation")


func _on_animation_finished(anim_name):
	if anim_name == "Explosion":
		queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Explosion":
		queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Player:
		hit_flash_player.play("Explosion")
		area.damage(1)
