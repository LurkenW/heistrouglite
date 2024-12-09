extends Camera2D

var zoom_speed: float = 0.1
var minimum: Vector2 = Vector2(0.5, 0.5) 
var maximum: Vector2 = Vector2(1.5, 1.5)

#Camera zoom
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(minimum, maximum)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(minimum, maximum)
		
