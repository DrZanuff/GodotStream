extends Node

#var link = "https://ia800203.us.archive.org/22/items/quran_960/038.ogg"
#var link = "https://w3g3a5v6.ssl.hwcdn.net/upload2/game/105112/1974778?GoogleAccessId=uploader@moonscript2.iam.gserviceaccount.com&Expires=1582274878&Signature=Cf9iQg07eLwmG5%2FzncEBzJth3ax0V%2FuuM2HNrWZUxtTd6MKTgmIgVefCszw36xisB1lYqeYT4dp%2BV0P4letVL8LGClGZ5Ibvh9Fa0ujnmV8jX9fpVSGnGaVlabBNCXF2xAmzxfts6KU4BkAfE3f%2BDj87VzI%2BMI77MFqm3fBq%2BD9wRvO3M5n4TqsL0uEMnF6%2B126N0ajQuJYyH7bL%2B03pNbXFu3IOSppstmkMbk%2Fy26mUPTMYQtaYvH9qk40QRR8uO5vf2%2FqnGj72yjVhxtiINWQQp%2B3tKiW01OGt17HPQI7HgYBWeSqcbKPTUIX4UbliY9HczpWiJq%2Bh0%2FHmJsjeEQ==&hwexp=1582275138&hwsig=4bee42396060d6424f96ede1fa3614a3"
#var link =  "https://srv-file10.gofile.io/download/QhkHfG/Sound.ogg"
#var link =  "https://raw.githubusercontent.com/DrZanuff/NoHumansInSpace/master/Sound.ogg"
var link =  "https://send.mu/file/download/er5oI/BY8VTN"

const BYTES = 8192 #8kb

var buffer : PoolByteArray = PoolByteArray() #buffer da data
var text = ""


func _ready() -> void:

	var thread_buffer = Thread.new()
	thread_buffer.start(self,"_stream")
	
	var thread_start = Thread.new()
	thread_start.start(self,"start_stream")


func start_stream(p):
	while len(buffer) < BYTES:
		OS.delay_msec(1000) 

	play_buffer()


func play_buffer(pos = 0):
	var sound = AudioStreamOGGVorbis.new()
	sound.data = buffer
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play(pos)
	

func _stream(p):
	var start = link.find("://") + 3
	var stop  = link.find("/" , start )
	
	var host = link.substr(start , stop - start) #Host é o servidor que vamos nos conectar
	var use_ssl = link.find("https://") > -1 #Verifica se o host é seguro
	var file = link.substr(stop, len(link)) #O arquivo que vamos acessar dentro do Host
	

	var http = HTTPClient.new()
	var error = http.connect_to_host(host,-1,use_ssl)
	
	
	while ( http.get_status() != HTTPClient.STATUS_CONNECTED):
		http.poll()
		OS.delay_msec(100)
	
	var headers = [
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]
	
	error = http.request(HTTPClient.METHOD_GET, file , headers)

	while( http.get_status() == HTTPClient.STATUS_REQUESTING ):
		http.poll()
		OS.delay_msec(100)

	if http.has_response():
		headers = http.get_response_headers_as_dictionary()
		while( http.get_status() == HTTPClient.STATUS_BODY ):
			http.poll()
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				OS.delay_msec(100)
			else:
				buffer.append_array(chunk)
#				$sLabel.text = "Streamed: " + str(len(buffer) / 1024.0 / 1024.0) + " mb"
#				text = ("Streamed: " + str(len(buffer) * 1024.0 * 1024.0) + " mb")


func _on_AudioStreamPlayer_finished() -> void:
	print( $AudioStreamPlayer.get_playback_position()  )
	play_buffer( $AudioStreamPlayer.get_playback_position() )
