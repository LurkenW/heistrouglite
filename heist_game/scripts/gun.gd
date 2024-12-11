class_name Gun extends Node2D
## A class representing a gun
##
## The gun can fire bullets with a defined damage value and uses a cooldown mechanism to control the rate of fire.
## [br]
## It provides functionality to start and stop shooting.

## The amount of damage each bullet deals.
@export var damage: int = 10 

## The point from which bullets are fired.
@export var shootingPoint: Marker2D = null 

## The cooldown time (in seconds) between consecutive shots.
@export var fireCooldown: int = 1

var _reloadTimer: Timer # Internal Timer instance used for handling the reload cooldown.
var _isShooting: bool = false # Tracks whether the gun is currently in a shooting state.
var _isReloading: bool = false # Tracks whether the gun is currently reloading.


func _ready() -> void:
	_checkRequired() # Ensures all required variables are properly set.

	# Initialize and configure the reload timer.
	_reloadTimer = Timer.new()
	add_child(_reloadTimer)
	_reloadTimer.wait_time = fireCooldown
	_reloadTimer.timeout.connect(_on_timer_timeout)
	_reloadTimer.name = "ReloadTimer"

# Ensures that critical variables are assigned. Pushes an error if a required variable is missing.
func _checkRequired():
	if shootingPoint == null:
		push_error("The variable 'Shooting Point' must be set in the Inspector!")

# Handles the shooting logic by instantiating and firing a bullet.
func _shoot() -> void:
	_reloadTimer.start() # Starts the reload timer.
	_isReloading = true # Marks the gun as reloading.

	# Load and instantiate the bullet scene.
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_damage(damage) # Set the damage for the bullet.

	# Position the bullet at the shooting point.
	new_bullet.global_position = shootingPoint.global_position
	new_bullet.global_rotation = shootingPoint.global_rotation

	# Add the bullet to the scene tree for it to function.
	get_node("/root").add_child(new_bullet)

# Callback for the reload timer's timeout signal. Resumes shooting if required or ends reloading.
func _on_timer_timeout():
	if _isShooting:
		_shoot() # Continue shooting if the gun is in the shooting state.
	else:
		_isReloading = false # Otherwise, end the reloading state.

## Starts the shooting process. Shoots immediately if the gun is not reloading.
func startShooting() -> void:
	_isShooting = true # Mark the gun as shooting.

	if not _isReloading:
		_shoot() # Fire a bullet if not in the middle of a reload.

## Stops the shooting process.
func stopShooting() -> void:
	_isShooting = false # Mark the gun as not shooting.
