extends Node


var playlist = "https://script.google.com/macros/s/AKfycbyZ66tLErbKtftxOI1ZOrMX2RdgooybrDZEZdePmtHa-pacsQA/exec"


func _ready() -> void:
	
	var headers = [
	"User-Agent: Pirulo/1.0 (Godot)",
	"Accept: */*"
	]
	
	$HTTPRequest.request(playlist,headers)
	pass # Replace with function body.


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	print(body.get_string_from_utf8())
	pass # Replace with function body.
