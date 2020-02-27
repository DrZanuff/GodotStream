extends MarginContainer

var link = ""

const BYTES = 8192 #8kb
var buffer : PoolByteArray = PoolByteArray() #buffer da data
var http = HTTPClient.new()
var close_stream = false
var duration = 0

signal track_finished

func _play() -> void:

	var thread_buffer = Thread.new()
	thread_buffer.start(self,"_stream")
	
	var thread_start = Thread.new()
	thread_start.start(self,"start_stream")

func _stop():
	var sound = AudioStreamOGGVorbis.new()
	buffer = PoolByteArray()
	sound.data = buffer
	$AudioStreamPlayer.stream = sound
	http.close()
	close_stream = true

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
	#p is the link for the sound in FireBase
	var start = link.find("://") + 3
	var stop  = link.find("/" , start )
	
	var host = link.substr(start , stop - start) #Host é o servidor que vamos nos conectar
	var use_ssl = link.find("https://") > -1 #Verifica se o host é seguro
	var file = link.substr(stop, len(link)) #O arquivo que vamos acessar dentro do Host
	
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


func _on_AudioStreamPlayer_finished() -> void:
	if $AudioStreamPlayer.get_playback_position() < int(duration):
		play_buffer( $AudioStreamPlayer.get_playback_position() )
	else:
		$AudioStreamPlayer.stop()
		emit_signal("track_finished")
