extends Node


var link = "https://script.google.com/macros/s/AKfycbyZ66tLErbKtftxOI1ZOrMX2RdgooybrDZEZdePmtHa-pacsQA/exec"
var music_item = load("res://MusicItem/MusicItem.tscn")

func _ready() -> void:
	
	var headers = [
	"User-Agent: Pirulo/1.0 (Godot)",
	"Accept: */*"
	]
	
	$HTTPRequest.request(link,headers)
	pass # Replace with function body.


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var playlist = JSON.parse( body.get_string_from_utf8() ).result
	for m in playlist.list:
		if m.name != "":
			var new_music_item = music_item.instance()
			$MainBody/PC/BodyMargin/Body/List/Musics.add_child(new_music_item)
			new_music_item.set_values(m.name , m.link , m.duration , m.cover)
	
	
