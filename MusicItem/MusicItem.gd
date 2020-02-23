extends MarginContainer

var values = {
	"name":"",
	"link":"",
	"duration":"",
	"cover":""
}

var vcover = "https://firebasestorage.googleapis.com/v0/b/father-of-all.appspot.com/o/Covers%2F116%20-%20O'%20Come%20feat.%20Tedashii%20%26%20Nobigdyl.%20%20%20The%20Gift%20Live%20Sessions.jpg?alt=media&token=0cc34916-28b0-47f4-83cd-cd1c78258edb"

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var image = Image.new()
	image.load_jpg_from_buffer(body)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$PanelContainer/OuterMargin/PC/ItemBody/TextureMargin/TextureRect.texture = texture

func set_values( name , link , duration , cover ):
	values.name = name
	values.link = link
	values.duration = duration
	values.cover = cover
	
	$PanelContainer/OuterMargin/PC/ItemBody/TextMargin/Label.text = values.name
	$HTTPRequest.request(values.cover)
