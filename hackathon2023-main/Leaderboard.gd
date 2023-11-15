extends Control
var http_request
# Called when the node enters the scene tree for the first time.
func customComparison(a, b):
	return float(a.time) < float(b.time)

func actuallyBuildLevelFiveLeaderBoard(scoreData):
	var listOfTimes = []

	for score in scoreData.data:
		var data = JSON.parse_string(score.scoreVal)
		listOfTimes.append({"userId": score.userId, "time": data.time})

	listOfTimes.sort_custom(self.customComparison)
	print(listOfTimes)
	var idx=1
	for score in listOfTimes:
		var i=get_node("MarginContainer/VBoxContainer/TabContainer/Level Five/vbox1/"+str(idx)+"_levelOneScoreLine") 
		i.get_node("Place").text='#'+str(idx)
		i.get_node('UserId').text="User: " +score.userId
		i.get_node('Score').text="Time: " +str(score.time)
		#$vbox1.add_child(i)
		if(idx < 10):
			idx+=1
	
func buildLevelFiveLeaderBoard():
	var body = JSON.new().stringify({ "levelId": "level_five"})

	var query = JSON.stringify(body)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/getScoresForLevel?levelId=%s"
	var actualUrl = requestUrlFormat % ["level_five"]
	await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "query0")
	return

func actuallyBuildLevelFourLeaderBoard(scoreData):
	var listOfTimes = []

	for score in scoreData.data:
		var data = JSON.parse_string(score.scoreVal)
		listOfTimes.append({"userId": score.userId, "time": data.time})

	listOfTimes.sort_custom(self.customComparison)
	print(listOfTimes)
	var idx=1
	for score in listOfTimes:
		var i=get_node("MarginContainer/VBoxContainer/TabContainer/Level Four/vbox1/"+str(idx)+"_levelOneScoreLine") 
		i.get_node("Place").text='#'+str(idx)
		i.get_node('UserId').text="User: " +score.userId
		i.get_node('Score').text="Time: " +str(score.time)
		#$vbox1.add_child(i)
		if(idx < 10):
			idx+=1
	buildLevelFiveLeaderBoard()
	
func buildLevelFourLeaderBoard():
	var body = JSON.new().stringify({ "levelId": "level_four"})

	var query = JSON.stringify(body)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/getScoresForLevel?levelId=%s"
	var actualUrl = requestUrlFormat % ["level_four"]
	await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "query0")
	return

func actuallyBuildLevelThreeLeaderBoard(scoreData):
	var listOfTimes = []

	for score in scoreData.data:
		var data = JSON.parse_string(score.scoreVal)
		listOfTimes.append({"userId": score.userId, "time": data.time})

	listOfTimes.sort_custom(self.customComparison)
	print(listOfTimes)
	var idx=1
	for score in listOfTimes:
		var i=get_node("MarginContainer/VBoxContainer/TabContainer/Level Three/vbox1/"+str(idx)+"_levelOneScoreLine") 
		i.get_node("Place").text='#'+str(idx)
		i.get_node('UserId').text="User: " +score.userId
		i.get_node('Score').text="Time: " +str(score.time)
		#$vbox1.add_child(i)
		if(idx < 10):
			idx+=1
	buildLevelFourLeaderBoard()
	
func buildLevelThreeLeaderBoard():
	var body = JSON.new().stringify({ "levelId": "level_three"})

	var query = JSON.stringify(body)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/getScoresForLevel?levelId=%s"
	var actualUrl = requestUrlFormat % ["level_three"]
	await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "query0")
	return

func actuallyBuildLevelTwoLeaderBoard(scoreData):
	var listOfTimes = []

	for score in scoreData.data:
		var data = JSON.parse_string(score.scoreVal)
		listOfTimes.append({"userId": score.userId, "time": data.time})

	listOfTimes.sort_custom(self.customComparison)
	print(listOfTimes)
	var idx=1
	for score in listOfTimes:
		var i=get_node("MarginContainer/VBoxContainer/TabContainer/Level Two/vbox1/"+str(idx)+"_levelOneScoreLine") 
		i.get_node("Place").text='#'+str(idx)
		i.get_node('UserId').text="User: " +score.userId
		i.get_node('Score').text="Time: " +str(score.time)
		#$vbox1.add_child(i)
		if(idx < 10):
			idx+=1
	buildLevelThreeLeaderBoard()
	
func buildLevelTwoLeaderBoard():
	var body = JSON.new().stringify({ "levelId": "level_two"})

	var query = JSON.stringify(body)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/getScoresForLevel?levelId=%s"
	var actualUrl = requestUrlFormat % ["level_two"]
	await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "query0")
	return
	
func actuallyBuildLevelOneLeaderBoard(scoreData):
	var listOfTimes = []

	for score in scoreData.data:
		var data = JSON.parse_string(score.scoreVal)
		listOfTimes.append({"userId": score.userId, "time": data.time})

	listOfTimes.sort_custom(self.customComparison)
	print(listOfTimes)
	var idx=1
	for score in listOfTimes:
		var i=get_node("MarginContainer/VBoxContainer/TabContainer/Level One/vbox1/"+str(idx)+"_levelOneScoreLine") 
		i.get_node("Place").text='#'+str(idx)
		i.get_node('UserId').text="User: " +score.userId
		i.get_node('Score').text="Time: " +str(score.time)
		#$vbox1.add_child(i)
		if(idx < 10):
			idx+=1
	buildLevelTwoLeaderBoard()
func buildLevelOneLeaderBoard():
	var body = JSON.new().stringify({ "levelId": "level_one"})

	var query = JSON.stringify(body)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var requestUrlFormat = "https://us-central1-shot-buck.cloudfunctions.net/getScoresForLevel?levelId=%s"
	var actualUrl = requestUrlFormat % ["level_one"]
	await http_request.request(actualUrl, [], HTTPClient.METHOD_POST, "query0")
	return
	
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json)
	var response = json.get_data()
	if "levelId" in response:
		if(response.levelId == "level_one"):
			actuallyBuildLevelOneLeaderBoard(response) 
		if(response.levelId == "level_two"):
			actuallyBuildLevelTwoLeaderBoard(response) 
		if(response.levelId == "level_three"):
			actuallyBuildLevelThreeLeaderBoard(response)
		if(response.levelId == "level_four"):
			actuallyBuildLevelFourLeaderBoard(response)
		if(response.levelId == "level_five"):
			actuallyBuildLevelFiveLeaderBoard(response)
		print(response.data)


func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	buildLevelOneLeaderBoard()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	buildLevelOneLeaderBoard()
	pass # Replace with function body.
