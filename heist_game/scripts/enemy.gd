extends CharacterBody2D

@onready var target_player = get_node("/root/root/CharacterBody2D")

var SPEED = 100.0
var health = 100
var movement_delay = 1.0
var movement_timer: Timer
var alert_timer: Timer

var alerted: bool

var player_in_range
var player_in_sight

func _ready():
	movement_timer = Timer.new()
	add_child(movement_timer)
	movement_timer.wait_time = movement_delay
	movement_timer.timeout.connect(_on_movement_timer_timeout)
	movement_timer.name = "MovementTimer"
	
	alert_timer = Timer.new()
	add_child(alert_timer)
	alert_timer.wait_time = 3.0
	alert_timer.timeout.connect(_on_alert_timer_timeout)
	alert_timer.one_shot = true
	alert_timer.name = "AlertTimer"

func _physics_process(delta: float) -> void:
	if (self.global_position.distance_to(target_player.global_position) < 100):
		SPEED = 50
	else:
		SPEED = 100
	if alerted == true:
		look_at(target_player.global_position)
	if player_in_range == true:
		sight_check()
	move_and_slide()

func _on_movement_timer_timeout():
	movement_timer.wait_time = movement_delay
	make_movement_decision(target_player)

func make_movement_decision(target):
	if (self.global_position.distance_to(target_player.global_position) < 110):
		movement_delay = 0.2
		_move_to_target(target)
	else:
		var rng = randi_range(0,3)
		match rng:
			0:
				movement_delay = 0.5
				strafe_target(target)
			_:
				movement_delay = 0.8
				_move_to_target(target)

	#Moves directly towards target
func _move_to_target(target):
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * SPEED
	
	#Picks a random direction to strafe
func strafe_target(target):
	var direction = global_position.direction_to(target.global_position)
	var rng = randi_range(0,1)
	match rng:
		0:
			direction = direction.rotated(PI/4)
		1:
			direction = direction.rotated(-PI/4)
	velocity = direction * SPEED

func take_damage(dmg):
	health -= dmg
	if (health < 0):
		killed()

func killed():
	queue_free()

func _on_sight_body_entered(body):
	if body == target_player:
		player_in_range = true

func _on_sight_body_exited(body):
	if body == target_player:
		player_in_range = false

func sight_check():
	#Sets up a raycast that checks if the enemy has direct LOS to the player
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_player.global_position)
	var sight_check = space_state.intersect_ray(query)
	
	#If the cast succeeds, activate the alertness timer
	if sight_check:
		if sight_check.collider.name == target_player.name:
			if (player_in_sight == false):
				alert_timer.start()
			player_in_sight = true
		else:
			player_in_sight = false
			_on_alert_timer_timeout() #Spit and scotch-tape ass way of doing it

func alert_status() -> void:
	if alerted == true:
		movement_timer.start()
	else:
		velocity = Vector2(0,0)
		movement_timer.stop()

func _on_alert_timer_timeout():
	if player_in_sight == true:
		alerted = true
		alert_status()
	else: 
		alerted = false
		alert_status()
	
func _on_auto_detect_body_entered(body):
	if body == target_player && player_in_sight == true:
		alerted = true
		alert_status()
