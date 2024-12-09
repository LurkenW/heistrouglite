extends CharacterBody2D

var SPEED = 100

func _physics_process(delta: float) -> void:
	
	## Movement
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * SPEED
	move_and_slide()
	
	## Rotation
	var cursorPosition = get_global_mouse_position()
	look_at(cursorPosition)
	
