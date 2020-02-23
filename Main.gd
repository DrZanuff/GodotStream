extends Node


var link = "https://script.google.com/macros/s/AKfycbyZ66tLErbKtftxOI1ZOrMX2RdgooybrDZEZdePmtHa-pacsQA/exec"
var music_item = load("res://MusicItem/MusicItem.tscn")
onready var musicList = $MainBody/PC/BodyMargin/Body/List/Musics 
var is_playing = false

var select_values = {
	"name":"",
	"link":"",
	"duration":"",
	"cover":""
}

var play_values = {
	"name":"",
	"link":"",
	"duration":"",
	"cover":""
}

func _ready() -> void:
	
	var headers = [
	"User-Agent: Pirulo/1.0 (Godot)",
	"Accept: */*"
	]
	
	$HTTPRequest.request(link,headers)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var playlist = JSON.parse( body.get_string_from_utf8() ).result
	for m in playlist.list:
		if m.name != "":
			var new_music_item = music_item.instance() as MarginContainer
			musicList.add_child(new_music_item)
			new_music_item.set_values(m.name , m.link , m.duration , m.cover)
			var n = new_music_item.get_position_in_parent()
			new_music_item.get_node("Button").connect(
				"pressed",self,"item_select",[n]
				)
	

func item_select(n):
	deselect_all()
	musicList.get_child(n).get_node("Panel/Select").show()
	enable_play(true)
	select_values.name = musicList.get_child(n).values.name
	select_values.link = musicList.get_child(n).values.link
	select_values.duration = musicList.get_child(n).values.duration
	select_values.cover = musicList.get_child(n).values.cover
	$MainBody/PC/BodyMargin/Body/Player/Options/Select/PC/Body/TextM/TrackText.text = select_values.name

func deselect_all():
	for i in musicList.get_children():
		i.get_node("Panel/Select").hide()

func enable_play(b : bool):
	$MainBody/PC/BodyMargin/Body/Player/Options/Select/PC/Body/Play.disabled = !b

func enable_stop(b : bool):
	$MainBody/PC/BodyMargin/Body/Player/Options/Select/PC/Body/Stop.disabled = !b

func _on_Play_pressed() -> void:
	if is_playing == false:
		enable_stop(true)
		play_values.name = select_values.name
		play_values.link = select_values.link
		play_values.duration = play_values.duration
		play_values.cover = play_values.cover
		$MainBody/PC/BodyMargin/Body/Player.link = play_values.link 
		$MainBody/PC/BodyMargin/Body/Player._play()
		$MainBody/PC/BodyMargin/Body/Player/Options/Playing/TrackInfo/TrackName.text = play_values.name
		is_playing = true
	else:
		$MainBody/PC/BodyMargin/Body/Player._stop()
		enable_stop(true)
		play_values.name = select_values.name
		play_values.link = select_values.link
		play_values.duration = play_values.duration
		play_values.cover = play_values.cover
		$MainBody/PC/BodyMargin/Body/Player.link = play_values.link 
		$MainBody/PC/BodyMargin/Body/Player._play()
		$MainBody/PC/BodyMargin/Body/Player/Options/Playing/TrackInfo/TrackName.text = play_values.name
		is_playing = true
		

func _on_Stop_pressed() -> void:
	$MainBody/PC/BodyMargin/Body/Player._stop()
	enable_stop(false)
	is_playing = false

