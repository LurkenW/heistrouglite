extends Camera2D

<<<<<<< HEAD
var zoom_speed: float = 0.1
var minimum: Vector2 = Vector2(0.5, 0.5) 
var maximum: Vector2 = Vector2(1.5, 1.5)
=======
var zoom_speed: float = 0.05
var minimum_zoom: Vector2 = Vector2(0.8, 0.8) 
var maximum_zoom: Vector2 = Vector2(1.2, 1.2)

var maximum_position_x: float = 200
>>>>>>> fdd21de78c5175377e78274e5c9bc171a9803306

#Camera zoom
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
<<<<<<< HEAD
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(minimum, maximum)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(minimum, maximum)
		
=======
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(minimum_zoom, maximum_zoom)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(minimum_zoom, maximum_zoom)
	#Dynamic camera movement 
	if event is InputEventMouseMotion:
		position.y = get_local_mouse_position().y
		if get_local_mouse_position().x <= 200 and get_local_mouse_position().x >= -200:
			position.x = get_local_mouse_position().x
>>>>>>> fdd21de78c5175377e78274e5c9bc171a9803306
