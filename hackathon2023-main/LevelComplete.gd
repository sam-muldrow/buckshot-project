extends Control

func LevelComplete(time):
	get_node("ScoreText").text = "Your Time: " + str(time);
	get_node("LevelCompleteText").visible = true
	get_node("ScoreText").visible = true
	get_node("ColorRect").visible = true
	var level_name = get_tree().get_current_scene().get_name()
	get_node("MarginContainer").visible = true
	var server = get_node("/root/ServerAuto")
	server.writeUserScoreToDB({"time": time}, level_name)
	
	
	return
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("LevelCompleteText").visible = false
	get_node("ScoreText").visible = false
	get_node("ColorRect").visible = false
	get_node("MarginContainer").visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_next_level_button_pressed():
	get_tree().change_scene_to_file("res://LevelSelection.tscn")
	pass # Replace with function body.


func _on_view_leader_board_button_pressed():
	get_tree().change_scene_to_file("res://Leaderboard.tscn")
	pass # Replace with function body.
	


func _on_view_leader_board_button_2_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	pass # Replace with function body.
