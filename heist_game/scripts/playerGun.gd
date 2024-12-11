extends Node2D

var gun_damage = 15
var fireCooldown = 1

var isShooting: bool = false
var isReloading: bool = false

var reloadTimer: Timer

func _ready() -> void:
	reloadTimer = Timer.new()
	add_child(reloadTimer)
	reloadTimer.wait_time = fireCooldown
	reloadTimer.timeout.connect(_on_timer_timeout)
	reloadTimer.name = "ReloadTimer"


func startShooting() -> void:
	isShooting = true
	
	if not isReloading:
		_shoot()

func stopShooting() -> void:
	isShooting = false
	print("HEJ")

func _shoot():
	
	reloadTimer.start()
	isReloading = true
	
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_damage(gun_damage)
	
	new_bullet.global_position = $WeaponPivot/Icon/ShootingPoint.global_position
	new_bullet.global_rotation = $WeaponPivot/Icon/ShootingPoint.global_rotation
	
	get_node("/root").add_child(new_bullet)

func _on_timer_timeout():
	
	if isShooting:
		_shoot()
	else:
		isReloading = false
		
	
