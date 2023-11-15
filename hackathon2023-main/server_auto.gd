extends Node

var http_request

func _ready():
	http_request = HTTPRequest.new()
	await add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func writeUserScoreToDB(scoreObj, levelId):
		# Get saved user info
		var save_game = FileAccess.open("user://user.save", FileAccess.READ)
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

		var node_data = json.get_data()
		var userObj = get_node("/root/GlobalVars")
		var stringScoreObject = JSON.new().stringify(scoreObj)

		# Add 'Content-Type' header:
		var headers = ["Content-Type: application/json"]
		var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/addScoreToLevel?userId=%s&password=%s&scoreValue=%s&levelId=%s"
		var actualUrl = requestUrlFormat % [userObj.userId, userObj.password,stringScoreObject, levelId]
		await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "0")
		return
		
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(result)


