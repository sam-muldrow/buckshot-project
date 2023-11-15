extends Node2D

var time = 0.0
var runTimer = true

func getTime():
	return time;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(runTimer):
		time += delta
	pass


func _on_area_2d_body_entered(body):
	runTimer = false
	self.position.y = -600
	self.position.x = 0
	time = snapped(time, 0.01)
	get_tree().get_current_scene().get_node("LevelCompleteDisplay").LevelComplete(time);
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.Stop = true
	get_node("ColorRect").visible = false
	pass # Replace with function body.
