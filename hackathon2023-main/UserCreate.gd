extends Control
var userId = ""
var password = ""
var http_request 
# Called when the node enters the scene tree for the first time.
func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func makeUserIdOnServer():
	
	return

func _on_user_id_text_changed(new_text):
	userId = new_text
	pass # Replace with function body.


func _on_password_text_changed(new_text):
	password = new_text
	pass # Replace with function body.


func _on_button_pressed():
	if (password.length() > 0 and userId.length() > 0):
		var save_game = FileAccess.open("user://user.save", FileAccess.WRITE)
		var userObj = {
			"password": password,
			"userId": userId,
		}
		var globalVars = get_node("/root/GlobalVars")
		globalVars.setUser(userId, password)
		var json_string = JSON.stringify(userObj)
		save_game.store_line(json_string)
		var body = JSON.new().stringify({ "userId": userId, "password": password })

		var query = JSON.stringify(body)
		# Add 'Content-Type' header:
		var headers = ["Content-Type: application/json"]
		var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/createUser?userId=%s&password=%s"
		var actualUrl = requestUrlFormat % [userId, password]
		await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, query)
		
	pass # Replace with function body.


func _on_button_button_down():
	pass # Replace with function body.
	
	
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	get_tree().change_scene_to_file("res://menu.tscn")
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(result)


func _on_button_2_pressed():
	var server = get_node("/root/server_auto.gd")
	server.writeUserScoreToDB({"time": "100.11234", "enemiesKilled": "100"}, "level_one")
	pass # Replace with function body.
