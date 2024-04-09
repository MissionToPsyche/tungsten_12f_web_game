extends Node

var spaceRock = preload("res://Minigame2/spaceRock.tscn")
var gameEnded : bool = false
@export var maxRocks: float = 5

func _ready():
	$Craft.connect("message_sent",$HUD.signalManager)
	$Timer.start()
	$Craft.connect("message_sent",self.pauseCheck)
	$HUD.connect("message_sent", self.pauseCheck)
	


func _on_timer_timeout():
	if gameEnded:
		return
		
	var rock_count = 0
	for child in get_children():
		if child.is_in_group("damageObj"):
			rock_count = rock_count + 1
			
	if rock_count < maxRocks:
		var rock = spaceRock.instantiate()
		rock.connect("message_sent",$HUD.signalManager)
		rock.position.x = randf_range(1000, 140)
		rock.position.y = -150
		rock.z_index = 1
		var randSclae = randf_range(0.5,1.5)
		rock.scale = Vector2(randSclae,randSclae)
		add_child(rock)

func pauseCheck(message):
	if message == "died":
		$AudioStreamPlayer2D.stop()
		clearScene("damageObj")
		var gameover: Node = find_node_by_name(get_tree().current_scene, "GameOver")
		gameover.visible = true
		gameover.DisplayScore($HUD.currentScore)
	elif message == "completed":
		$AudioStreamPlayer2D.stop()
		clearScene("damageObj")
		var gameover: Node = find_node_by_name(get_tree().current_scene, "GameCompleted")
		gameover.visible = true
		gameover.DisplayScore($HUD.currentScore)
		
	
func clearScene(groupname: String):
	for i in range(get_child_count()):
		var node = get_child(i)
		if node.is_in_group(groupname):
			node.queue_free()
	
	$Timer.stop()
		


func find_node_by_name(node: Node, name: String) -> Node:
	if node.name == name:
		return node
	
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		var result = find_node_by_name(child, name)
		if result != null:
			return result
	return null
