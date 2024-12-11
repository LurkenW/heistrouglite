class_name Gun extends Node2D
## A class representing a gun
##
## The gun can fire bullets with a defined damage value and uses a cooldown mechanism to control the rate of fire.
## [br]
## It provides functionality to start and stop shooting.

## The amount of damage each bullet deals.
@export var damage: int = 10 

## An array of all the points from which bullets are fired. Rotation is preserved.
@export var shootingPoints: Array[Marker2D] = []

## The cooldown time (in seconds) between consecutive shots.
@export var fireCooldown: float = 1

@export_group("Burst")
@export var burstFire: bool = false
@export var burstShots: int = 3
@export var burstCooldown: float = 0.05

var _reloadTimer: Timer # Internal Timer instance used for handling the reload cooldown.
var _isShooting: bool = false # Tracks whether the gun is currently in a shooting state.
var _isReloading: bool = false # Tracks whether the gun is currently reloading.

var _burstTimer: Timer
var _burstShots: int = 0

func _ready() -> void:
	_checkRequired() # Ensures all required variables are properly set.

	# Initialize and configure the reload timer.
	_reloadTimer = Timer.new()
	add_child(_reloadTimer)
	_reloadTimer.wait_time = fireCooldown
	_reloadTimer.timeout.connect(_on_reloadTimer_timeout)
	_reloadTimer.one_shot = true
	_reloadTimer.name = "ReloadTimer"


	_burstTimer = Timer.new()
	add_child(_burstTimer)
	_burstTimer.wait_time = burstCooldown
	_burstTimer.timeout.connect(_on_burstTimer_timeout)
	_burstTimer.one_shot = true
	_burstTimer.name = "BurstTimer"

# Ensures that critical variables are assigned. Pushes an error if a required variable is missing.
func _checkRequired():
	if shootingPoints.size() > 1:
		push_error("The variable 'Shooting Point' must be set in the Inspector!")

# Handles the shooting logic by instantiating and firing a bullet.
func _shootOnce() -> void:
	# Load and instantiate the bullet scene.
	const BULLET = preload("res://scenes/bullet.tscn")
	# For every shootingPoint, shoot a bullet
	for shootingPoint in shootingPoints:
		
		var new_bullet = BULLET.instantiate()
		new_bullet.set_damage(damage) # Set the damage for the bullet.

		# Position the bullet at the shooting point.
		new_bullet.global_position = shootingPoint.global_position
		new_bullet.global_rotation = shootingPoint.global_rotation

		# Add the bullet to the scene tree for it to function.
		get_node("/root").add_child(new_bullet)
	
func _shootBurst():
	_reloadTimer.start() # Starts the burst timer.
	_burstTimer.start()
	_isReloading = true # Marks the gun as reloading.
	
	_shootOnce()


# Callback for the reload timer's timeout signal. Resumes shooting if required or ends reloading.
func _on_reloadTimer_timeout():
	
	if _isShooting:
		_reloadTimer.start() # Starts the reload timer.
		if burstFire:
			_shootBurst()
		else:
			_shootOnce() # Continue shooting if the gun is in the shooting state.
	else:
		_isReloading = false # Otherwise, end the reloading state.

func _on_burstTimer_timeout():
	_burstShots += 1
	
	if _burstShots < burstShots:
		_shootOnce()
		_isReloading = true # Marks the gun as reloading.
		_burstTimer.start()
		
	else:
		_burstShots = 0

## Starts the shooting process. Shoots immediately if the gun is not reloading.
func startShooting() -> void:
	_isShooting = true # Mark the gun as shooting.
	
	if not _isReloading:
		_reloadTimer.start() # Starts the reload timer.
		_isReloading = true
		if burstFire:
			_shootBurst()
		else:
			_shootOnce() # Fire a bullet if not in the middle of a reload.

## Stops the shooting process.
func stopShooting() -> void:
	_isShooting = false # Mark the gun as not shooting.
