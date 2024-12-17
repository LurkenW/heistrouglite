extends CharacterBody2D

var SPEED: int = 125
var health: float = 100.0
var direction
var gun: Gun

func _ready() -> void:
	
	# Find players Gun
	for child in get_children():
		if child is Gun:
			gun = child

func _physics_process(delta: float) -> void:
	
	## Movement
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * SPEED
	move_and_slide()
	## Rotation
	var cursorPosition = get_global_mouse_position()
	look_at(cursorPosition)


func _process(delta):
	#Limiting the posible positions to ints
	position = position.round()
	
	
func  _input(event):
	#Sprinting
	if event.is_action_pressed("player_sprint_shift"):
		SPEED = 300
	if event.is_action_released("player_sprint_shift"):
		SPEED = 125
	
	if event.is_action_pressed("shoot_left_mouse"):
		gun.startShooting()
		
	if event.is_action_released("shoot_left_mouse"):
		gun.stopShooting()

func take_damage(dmg):
	health -= dmg
	print(health)
	if health <= 0:
		killed()

func killed():
	pass
