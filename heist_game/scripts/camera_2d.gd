extends Camera2D

var zoom_speed: float = 0.05
var minimum_zoom: Vector2 = Vector2(0.8, 0.8) 
var maximum_zoom: Vector2 = Vector2(1.2, 1.2)

func _input(event):
	#Camera zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(minimum_zoom, maximum_zoom)

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(minimum_zoom, maximum_zoom)

	#Dynamic camera movement 
	if event is InputEventMouseMotion:
		position.y = get_local_mouse_position().y
		position.x = clamp(get_local_mouse_position().x,-200, 200)

func shot():
	
	set_rotation_smoothing_speed(100)
	set_position_smoothing_speed(100)
	position.y += randf_range(-3,3)
	position.x += randf_range(-10,10)
	set_position_smoothing_speed(3)
	set_rotation_smoothing_speed(3)
	
