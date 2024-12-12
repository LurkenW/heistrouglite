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

func _physics_process(delta: float) -> void:
	if (self.global_position.distance_to(target_player.global_position) < 100):
		SPEED = 50
	else:
		SPEED = 100
	if alerted == true:
		look_at(target_player.global_position)
	move_and_slide()
	if player_in_range == true:
		sight_check()

func alert_status() -> void:
	if alerted == true:
		movement_timer = Timer.new()
		add_child(movement_timer)
		movement_timer.wait_time = movement_delay
		movement_timer.timeout.connect(_on_timer_timeout)
		movement_timer.name = "MovementTimer"
		movement_timer.start()
	else:
		movement_timer.stop()

func _on_timer_timeout():
	movement_timer.wait_time = movement_delay
	make_movement_decision(target_player)

func make_movement_decision(target):
	if (self.global_position.distance_to(target_player.global_position) < 100):
		movement_delay = 0.5
		_move_to_target(target)
	else:
		var rng = randi_range(0,2)
		match rng:
			0:
				movement_delay = 1.0
				_move_to_target(target)
			1:
				movement_delay = 1.0
				strafe_target_right(target)
			2:
				movement_delay = 1.0
				strafe_target_left(target)

func _move_to_target(target):
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * SPEED
	
func strafe_target_right(target):
	var direction = global_position.direction_to(target.global_position)
	direction = direction.rotated(PI/4)
	velocity = direction * SPEED

func strafe_target_left(target):
	var direction = global_position.direction_to(target.global_position)
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
		print("player in range: ", player_in_range)


func _on_sight_body_exited(body):
	if body == target_player:
		player_in_range = false
		print("player in range: ", player_in_range)

func sight_check():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_player.global_position)
	var sight_check = space_state.intersect_ray(query)
	if sight_check:
		if sight_check.collider.name == target_player.name:
			player_in_sight = true
			if alert_timer == null:
				alert_timer = Timer.new()
				add_child(alert_timer)
				alert_timer.wait_time = 3
				alert_timer.one_shot = true
				alert_timer.timeout.connect(_on_alert_timer_timeout)
				alert_timer.name = "AlertTimer"
				alert_timer.start()
		else:
			player_in_sight = false

func _on_alert_timer_timeout():
	if player_in_sight == true:
		alerted = true
		alert_status()
	
