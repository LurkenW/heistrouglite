extends CharacterBody2D

@onready var target_player = get_node("/root/root/CharacterBody2D")

var SPEED = 100.0

var health = 100
var movement_delay = 1.0
var movement_timer: Timer

func _ready() -> void:
	movement_timer = Timer.new()
	add_child(movement_timer)
	movement_timer.wait_time = movement_delay
	movement_timer.timeout.connect(_on_timer_timeout)
	movement_timer.name = "MovementTimer"
	movement_timer.start()

func _physics_process(delta: float) -> void:
	if (self.global_position.distance_to(target_player.global_position) < 100):
		SPEED = 50
	else:
		SPEED = 100
	look_at(target_player.global_position)
	move_and_slide()

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
