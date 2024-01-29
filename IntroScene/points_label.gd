extends RichTextLabel

func _ready():
	# Make sure BBCode is enabled
	set_use_bbcode(true)

	# Create the DynamicFont
	var dynamic_font = FontFile.new()

	# Load the TTF font data
	dynamic_font.font_data = load("res://IntroScene/m5x7.ttf")  # Make sure the path is correct

	# Set the font to the RichTextLabel
	self.add_theme_font_override("normal_font", dynamic_font)

	# Set initial text with global points variable

	#self.bbcode_text = "Research Points: " + str(Global.points)

	# Check if text is visible
	print("Is the text visible?", is_visible_in_tree())
