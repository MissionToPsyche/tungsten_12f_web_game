extends Area2D

var tiles = []
var solved = []
var mouse = false
var tile = preload("res://PuzzleScene/tile.tscn")
var tile_h
var offset
var t
var movecounter = 0
var previous = ""
var num_rows
var num_cols

func _ready():
	start_game()
	$PointsTexture.z_index = 1
	$PointsTexture/JustPointsWord.z_index = 1
	$PointsTexture/PointsLabel.z_index = 1
	$PointsTexture/PointsLabel.text = "300"
	$Timer.wait_time = 1.0
	$Timer.start()
	

func start_game():
	var screen_size = get_window().get_size()
	var window_aspect_ratio = float(screen_size.x) / float(screen_size.y)
	var target_aspect_ratio = 16.0 / 9.0

	var viewport_size = screen_size
	if window_aspect_ratio > target_aspect_ratio:
		# Window is wider than the target aspect ratio
		viewport_size.x = screen_size.y * target_aspect_ratio
	else:
		# Window is taller than the target aspect ratio
		viewport_size.y = screen_size.x / target_aspect_ratio

	get_tree().get_root().set_content_scale_size(viewport_size)
	get_tree().get_root().set_content_scale_mode(Window.CONTENT_SCALE_MODE_VIEWPORT)
	get_tree().get_root().set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_EXPAND)

	num_cols = 5
	num_rows = 3
	tile_h = min(viewport_size.x / num_cols, viewport_size.y / num_rows)

	var image = Image.load_from_file("res://PuzzleScene/img/robot.jpg")
	var puzzle_aspect_ratio = float(image.get_width()) / float(image.get_height())
	var puzzle_width = viewport_size.x
	var puzzle_height = puzzle_width / puzzle_aspect_ratio
	if puzzle_height < viewport_size.y:
		puzzle_height = viewport_size.y
		puzzle_width = puzzle_height * puzzle_aspect_ratio
	image.resize(puzzle_width, puzzle_height)
	var texture = ImageTexture.create_from_image(image)
	$FullImage.texture = texture

	var greyimage = Image.load_from_file("res://PuzzleScene/img/greytile.png")
	greyimage.resize(tile_h, tile_h)
	var greytexture = ImageTexture.create_from_image(greyimage)

	var total_width = tile_h * num_cols + (num_cols - 1) * 2
	var start_x = (viewport_size.x - total_width) / 2

	for j in range(0, num_rows):
		for i in range(0, num_cols):
			var myregion = Rect2i(i * tile_h, j * tile_h, tile_h, tile_h)
			var newimage = image.get_region(myregion)
			var newtexture = ImageTexture.create_from_image(newimage)
			var newtile = tile.instantiate()
			newtile.position.x = start_x + tile_h * i + tile_h / 2 + i * 2
			newtile.position.y = tile_h * j + tile_h / 2 + j * 2
			newtile.tilename = "Tile" + str(j * num_cols + i + 1)
			if newtile.tilename == "Tile" + str(num_rows * num_cols):
				newtile.tiletexture = greytexture
				newtile.realtexture = newtexture
			else:
				newtile.tiletexture = newtexture
			add_child(newtile)
			tiles.append(newtile)

	solved = tiles.duplicate()
	shuffle_tiles()
	movecounter = 0
	adjust_full_image()

func shuffle_tiles():
	offset = tile_h + 2
	t = 0
	while t < 5:
		var atile = randi() % (num_rows * num_cols)
		if tiles[atile].tilename != "Tile" + str(num_rows * num_cols) and tiles[atile].tilename != previous:
			var rows = int(tiles[atile].position.y / offset)
			var cols = int(tiles[atile].position.x / offset)
			check_neighbours(rows, cols)


func adjust_full_image():
	var viewport_size = get_tree().get_root().get_content_scale_size()
	var image_aspect_ratio = $FullImage.texture.get_width() / $FullImage.texture.get_height()
	var new_width = viewport_size.x
	var new_height = new_width / image_aspect_ratio

	$FullImage.scale.x = new_width / $FullImage.texture.get_width()
	$FullImage.scale.y = new_height / $FullImage.texture.get_height()
	$FullImage.position = Vector2(viewport_size.x / 2, viewport_size.y / 2)


func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y / offset)
		var cols = int(mouse_copy.position.x / offset)
		check_neighbours(rows,cols)
		if tiles == solved and movecounter > 1:
			print("You win in ", str(movecounter, " moves!!"))
			var final_score = int($PointsTexture/PointsLabel.text)
			Global.score += final_score
			get_tree().change_scene_to_file("res://DecesionTreeScene/decision_tree.tscn")
			

func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * num_cols + cols
	while !empty and !done:
		var new_pos = tiles[pos].position
		if rows < num_rows - 1:
			new_pos.y += offset
			empty = find_empty(new_pos,pos)
			new_pos.y -= offset
		if rows > 0:
			new_pos.y -= offset
			empty = find_empty(new_pos,pos)
			new_pos.y += offset
		if cols < num_cols - 1:
			new_pos.x += offset
			empty = find_empty(new_pos,pos)
			new_pos.x -= offset
		if cols > 0:
			new_pos.x -= offset
			empty = find_empty(new_pos,pos)
			new_pos.x += offset
		done = true

func find_empty(position, pos):
	var new_rows = int(position.y / offset)
	var new_cols = int(position.x / offset)
	var new_pos = new_rows * num_cols + new_cols
	if tiles[new_pos].tilename == "Tile" + str(num_rows * num_cols) and tiles[new_pos].tilename != previous:
		swap_tiles(pos, new_pos)
		t += 1
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
	movecounter += 1
	previous = tiles[tile_dst].tilename


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event


func _on_timer_timeout():
	var current_score = int($PointsTexture/PointsLabel.text)
	current_score -= 1
	$PointsTexture/PointsLabel.text = str(current_score)
