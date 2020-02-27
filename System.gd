extends Node

func convert_time(time):
	var minutes = time / 60
	var seconds = time % 60
	var str_elapsed = "%02d:%02d" % [minutes, seconds]
	return str_elapsed
