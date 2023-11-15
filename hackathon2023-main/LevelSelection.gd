extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	pass # Replace with function body.


func _on_level_selection_button_pressed():
	get_tree().change_scene_to_file("res://level_one.tscn")
	pass # Replace with function body.


func _on_level_selection_button_2_pressed():
	get_tree().change_scene_to_file("res://level_two.tscn")
	pass # Replace with function body.


func _on_level_selection_button_3_pressed():
	get_tree().change_scene_to_file("res://level_three.tscn")
	pass # Replace with function body.


func _on_level_selection_button_4_pressed():
	get_tree().change_scene_to_file("res://level_four.tscn")
	pass # Replace with function body.


func _on_level_selection_button_5_pressed():
	get_tree().change_scene_to_file("res://level_five.tscn")
	pass # Replace with function body.
