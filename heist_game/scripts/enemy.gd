extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var speed = 100.0
var health = 100
var movement_delay = 1.0
var attack_timer: Timer
var alert_timer: Timer

var target_player
var target_position

var alerted: bool

var player_in_range
var player_in_sight
var distance_to_player

func _ready():
	alert_timer = Timer.new()
	add_child(alert_timer)
	alert_timer.wait_time = 3.0
	alert_timer.timeout.connect(_on_alert_timer_timeout)
	alert_timer.one_shot = true
	alert_timer.name = "AlertTimer"
	
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = 2.5
	attack_timer.one_shot = true
	attack_timer.name = "AlertTimer"
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	target_player = get_node("/root/root/Player")
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame

func _physics_process(_delta: float) -> void:	
	if player_in_range == true:
		_sight_check()
	
	target_position = target_player.global_position
	distance_to_player = self.global_position.distance_to(target_position)
		
	if (alerted == true):
		var current_agent_position: Vector2 = self.global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		set_movement_target(target_player)
		
		if next_path_position:
			look_at(next_path_position)
	
		velocity = current_agent_position.direction_to(next_path_position) * speed
		move_and_slide()

func take_damage(dmg):
	health -= dmg
	if (health <= 0):
		_killed()

func _killed():
	queue_free()
	
func set_movement_target(target):
	navigation_agent.target_position = target_position
	
func _on_sight_body_entered(body):
	if body == target_player:
		player_in_range = true

func _on_sight_body_exited(body):
	if body == target_player:
		player_in_range = false
		
func _on_auto_detect_body_entered(body):
	if body == target_player && player_in_sight == true:
		alerted = true

func _sight_check():
	#Sets up a raycast that checks if the enemy has direct LOS to the player
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(self.global_position, target_player.global_position)
	var sight_check_result = space_state.intersect_ray(query)
	
	#If the cast succeeds, activate the alertness timer
	if sight_check_result:
		if sight_check_result.collider.name == target_player.name:
			if (alerted == false && alert_timer.time_left == 0):
				alert_timer.start()
			player_in_sight = true
			if distance_to_player < 80:
				attack_player()
		else:
			player_in_sight = false

func _on_alert_timer_timeout():
	if player_in_sight == true:
		alerted = true

func attack_player():
	if (attack_timer.time_left == 0):
		target_player.take_damage(8)
		attack_timer.start()
		print(target_player.health)
