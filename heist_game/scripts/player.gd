extends CharacterBody2D

var speed: int = 100 ##Is the players base speed
var potential_speed: int = 100 ##Is the players potential speed
var movement_acc: int = 20  ## Is the rate for which the player accelerates
var direction 

var health: float = 100.0

var gun: Gun
	
enum character_state {  ##Set for different constants making it easier to switch between possible character states 
	normal, 
	sliding, 
	stunned, 
	running
	}
	
var current_state = character_state.normal 

func _ready() -> void:
	
	# Find players Gun
	for child in get_children():
		if child is Gun:
			gun = child

func _physics_process(delta: float) -> void:
	position = position.round()
	match current_state: 
		
		character_state.normal:
			_process_movement(delta)
		
		character_state.running:  
			
			_process_movement(delta)
	
		character_state.sliding:
			_sliding_event(delta)

	## Rotation
	var cursorPosition = get_global_mouse_position()
	look_at(cursorPosition)

func  _input(event):
	#Sprinting
	if event.is_action_pressed("player_sprint_shift"):
		current_state = character_state.running
		_update_character_state()
	if event.is_action_released("player_sprint_shift"):
		current_state = character_state.normal
		_update_character_state()
	
	if event.is_action_pressed("player_space_slide"):
		current_state = character_state.sliding
		_update_character_state()
	if event.is_action_released("player_space_slide"):
		current_state = character_state.normal
		_update_character_state()
	
	if event.is_action_pressed("shoot_left_mouse"):
		gun.startShooting()
		
	if event.is_action_released("shoot_left_mouse"):
		gun.stopShooting()
	
#Makes it possible to change the values for general movement by just looking at the state of the character and then changing accordingly
func _update_character_state():
	match current_state:
		
		character_state.normal:
			speed = 100
			potential_speed = 100
			movement_acc = 20
		
		character_state.running:
			speed = 100
			potential_speed = 300
			movement_acc = 25
		
		character_state.sliding:
			speed = speed + 100
			movement_acc = 1
		
		character_state.stunned:
			speed = 0
			potential_speed = 0
			movement_acc = 0
		
# Movement
func _process_movement(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * speed
	print(speed)
	speed = lerp(speed, potential_speed, movement_acc * delta) ##This Makes the player accelerate by comparing speed and potential speed and then adding or removing movement_acc * delta 
	
	move_and_slide()

func _sliding_event(delta):
	var des_acc = clamp(movement_acc * delta, 0,1) #Calculates the decrease 
	speed = lerp(speed, 0, des_acc)
	velocity = direction * speed
	move_and_slide()

func take_damage(dmg):
	health -= dmg
	print(health)
	if health <= 0:
		killed()

func killed():
	pass
