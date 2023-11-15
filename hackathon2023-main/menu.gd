extends Control

func getUserCredsFromFile():
	var save_game = FileAccess.open("user://user.save", FileAccess.READ)
	var json_string = save_game.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

	var node_data = json.get_data()
	print(node_data)

func makeUserCreateLogin():
	get_tree().change_scene_to_file("res://UserCreate.tscn")

func checkIfUserExists():
	if not FileAccess.file_exists("user://user.save"):
		makeUserCreateLogin()
		return
	else:
		getUserCredsFromFile()
		return
		
		

# Called when the node enters the scene tree for the first time.
func _ready():
	# remove comment to run begin game logic
	#checkIfUserExists()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://LevelSelection.tscn")
	pass # Replace with function body.


func _on_leaderboard_button_pressed():
	get_tree().change_scene_to_file("res://Leaderboard.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
