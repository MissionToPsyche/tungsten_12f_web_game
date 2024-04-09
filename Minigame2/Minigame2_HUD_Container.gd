extends Control
signal message_sent(message)
var PlifePng := preload("res://Minigame2/Minigame2_HUD.tscn")
@onready var lifeContainer := $LifeContainer
var currentLives : int = 3
var currentScore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	clearLives()
	setLives(currentLives)
	$Score.text = str(currentScore)
	
func _process(delta):
	if $Node2D/Progress.time_left <= 0.5:
		emit_signal("message_sent", "completed")
		
func clearLives():
	for child in lifeContainer.get_children():
		lifeContainer.remove_child(child)
		child.queue_free()
		
func setLives(lives: int):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(PlifePng.instantiate())
		
		
func signalManager(message):
	if message == "hit":
		lostHealth()
	elif message == "scored explosion":
		currentScore += 10
		$Score.text = str(currentScore)
	elif message == "died":
		$Node2D.alive = false
		
		
func lostHealth():
		currentLives = currentLives - 1
		clearLives()
		for i in range(currentLives):
			lifeContainer.add_child(PlifePng.instantiate())
			
