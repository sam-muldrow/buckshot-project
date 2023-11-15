extends Node

var http_request

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func writeUserScoreToDB(scoreObj, levelId):
		http_request = HTTPRequest.new()
		await add_child(http_request)
		# Get saved user info
		var save_game = FileAccess.open("user://user.save", FileAccess.READ)
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

		var node_data = json.get_data()
		var userId = node_data.userId
		var password = node_data.password
	
		var stringScoreObject = JSON.new().stringify(scoreObj)

		# Add 'Content-Type' header:
		var headers = ["Content-Type: application/json"]
		var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/addOrEditUserData?userId=%s&password=%s&scoreValue=%s&levelId=%s"
		var actualUrl = requestUrlFormat % [userId, password, stringScoreObject, levelId]
		await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "0")
		return


func _on_button_2_pressed():
	var server = get_node("/root/ServerAuto")
	server.writeUserScoreToDB({"time": "600", "enemiesKilled": "100"}, "level_two")
	pass # Replace with function body.


func _on_button_pressed():
	pass # Replace with function body.
