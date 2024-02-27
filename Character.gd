extends Node2D

# Ensure to declare the signal in the script
signal sprite_selected(name, info)

# Character-specific information
var character_name := "Default Name"
var character_stats := {"Simulator Training": 0, "Rocket Engineering": 0}

# AnimatedSprites for skills
var character_sprite: Sprite2D
var skill1_sprite: AnimatedSprite2D
var skill2_sprite: AnimatedSprite2D
var character_label: Label

func _ready():
	# Initialize the random number generator
	randomize()
	randomize_stats()  # Set random stats for this character instance

	character_sprite = $CharacterSprite  # Assuming the Sprite2D is a direct child of this Node2D
	skill1_sprite = $Skill1  # Adjust the path to match your node structure
	skill2_sprite = $Skill2  # Adjust the path to match your node structure
	character_label = $CharacterLabel
	
	# Set the frames based on stats
	update_skill_frames()

	# Ensure the sprite can receive input events
	character_sprite.set_process_input(true)
	# Defer setting the Sprite's name property
	character_sprite.call_deferred("set_name", character_name)

func randomize_stats():
	# Randomize stats here
	character_stats["Simulator Training"] = randi() % 5
	character_stats["Rocket Engineering"] = randi() % 5

func update_skill_frames():
	# Update skill bar frames based on character stats
	skill1_sprite.frame = 4 - character_stats["Simulator Training"]
	skill2_sprite.frame = 4 - character_stats["Rocket Engineering"]

# Getter method for character information
func get_character_info() -> Dictionary:
	return {"name": character_name, "stats": character_stats}

func _input(event):
	if Global.input_allowed and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if character_sprite and character_sprite.get_rect().has_point(character_sprite.to_local(event.position)):
			print("Inside sprite rect: ", character_name)  # Debug print
			emit_signal("sprite_selected", character_name, get_character_info())
			queue_free()
