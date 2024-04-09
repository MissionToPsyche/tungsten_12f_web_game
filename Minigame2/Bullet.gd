extends Area2D

var cam: Node = null

@export var speed: float = 500

func _physics_process(delta):
	position.y -= speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("damageObj"):
		area.damage(1)
		cam = find_node_by_name(get_tree().current_scene, "Cam")
		cam.shake(3)
		queue_free()

func find_node_by_name(node: Node, name: String) -> Node:
	if node.name == name:
		return node
	
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		var result = find_node_by_name(child, name)
		if result != null:
			return result
	return null
