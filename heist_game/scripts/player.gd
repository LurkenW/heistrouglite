extends CharacterBody2D

var SPEED = 125

func _physics_process(delta: float) -> void:
	
	## Movement
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * SPEED
	move_and_slide()
	
	## Rotation
	var cursorPosition = get_global_mouse_position()
	look_at(cursorPosition)
	
	
func  _input(event):
	#Sprinting
	if event.is_action_pressed("player_sprint_shift"):
		SPEED = 300
	if event.is_action_released("player_sprint_shift"):
		SPEED = 125
	
	if event.is_action_pressed("shoot_left_mouse"):
		$Gun.startShooting()
		
	if event.is_action_released("shoot_left_mouse"):
		$Gun.stopShooting()

func takeDamage():
	pass
