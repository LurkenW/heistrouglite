extends Camera2D
const dead_zone = 100
var zoom_speed: float = 0.1
var minimum_zoom: Vector2 = Vector2(.5, .5) ## Don't have a lot of decimals as it might ruin the pixel rendering
var maximum_zoom: Vector2 = Vector2(1, 1)

func _input(event):
	#Camera zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(minimum_zoom, maximum_zoom)

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(minimum_zoom, maximum_zoom)
	
	
