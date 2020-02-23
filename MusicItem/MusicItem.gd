extends MarginContainer

var values = {
	"name":"",
	"link":"",
	"duration":"",
	"cover":""
}

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var image = Image.new()
	image.load_jpg_from_buffer(body)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$Panel/OuterMargin/PC/ItemBody/TextureMargin/TextureRect.texture = texture

func set_values( name , link , duration , cover ):
	values.name = name
	values.link = link
	values.duration = duration
	values.cover = cover
	
	$Panel/OuterMargin/PC/ItemBody/TextMargin/Label.text = values.name
	$HTTPRequest.request(values.cover)
