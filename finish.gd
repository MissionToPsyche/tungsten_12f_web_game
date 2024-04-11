extends Area2D

func _on_body_entered(body):
	if(body.name =="Player"):
		get_tree().change_scene_to_file("res://DecesionTreeScene/decision_tree.tscn")
		var final_score = int($UI/Panel/PointsLabel.text)
		Global.score += final_score

