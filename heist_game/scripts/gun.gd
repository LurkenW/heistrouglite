extends Node2D
class_name Gun

@export var damage: int = 10
@export var shootingPoint: Marker2D = null
@export var fireCooldown: int = 1

var _reloadTimer: Timer
var _isShooting: bool = false
var _isReloading: bool = false

func _ready() -> void:
	
	_checkRequired()
	
	_reloadTimer = Timer.new()
	add_child(_reloadTimer)
	_reloadTimer.wait_time = fireCooldown
	_reloadTimer.timeout.connect(_on_timer_timeout)
	_reloadTimer.name = "ReloadTimer"

func _checkRequired():
	if shootingPoint == null:
		push_error("The variable 'Shooting Point' must be set in the Inspector!")

func _shoot() -> void:
	
	_reloadTimer.start()
	_isReloading = true
	
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_damage(damage)
	
	new_bullet.global_position = shootingPoint.global_position
	new_bullet.global_rotation = shootingPoint.global_rotation
	
	get_node("/root").add_child(new_bullet)

func _on_timer_timeout():
	
	if _isShooting:
		_shoot()
	else:
		_isReloading = false

func startShooting() -> void:
	_isShooting = true
	
	if not _isReloading:
		_shoot()

func stopShooting() -> void:
	_isShooting = false
