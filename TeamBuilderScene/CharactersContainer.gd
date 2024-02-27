extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func queue_free_children():
	# This is a helper function to clear the HBoxContainer children
	for child in get_children():
		child.queue_free()
