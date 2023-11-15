extends Control

func dead():
	get_node("ColorRect").visible = true
	get_node("Label").visible = true
	get_node("VBoxContainer").visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ColorRect").visible = false
	get_node("Label").visible = false
	get_node("VBoxContainer").visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_retry_button_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_leaderboard_button_pressed():
	get_tree().change_scene_to_file("res://Leaderboard.tscn")
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	pass # Replace with function body.
