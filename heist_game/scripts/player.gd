extends CharacterBody2D

var SPEED = 100

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction.normalized() * SPEED
	
	var cursorPosition = get_global_mouse_position()
	look_at(cursorPosition)
	
	move_and_slide()
