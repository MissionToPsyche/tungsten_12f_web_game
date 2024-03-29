extends Node

@onready var points_label = %PointsLabel

var points = 0 

func add_point(): 
	points += 5 
	print(points)
	points_label.text = "POINTS:" + str(points) 
	
	
func lose_points(): 
	points -= 3 
	print(points)
	points_label.text = "POINTS:" + str(points)


