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

## The reload time (in seconds).
@export var reloadCooldown: float = 1

@export_group("Burst")
## Enables burst-fire mode
@export var burstFire: bool = false
## Number of shots fired in a single burst
@export var burstShots: int = 3
## Time (in seconds) between shots in a burst.
@export var burstCooldown: float = 0.05

var _recoilTimer: Timer # Internal Timer instance used for handling the time between shots.
var _isShooting: bool = false # Tracks whether the gun is currently in a shooting state.
var _isRecoiling: bool = false # Tracks whether the gun is currently reloading.

var _burstTimer: Timer # Internal Timer instance used for handling the time between shots in a burst.
var _shotsInCurrentBurst: int = 0 # Counts the number of shots that has been shot in the current burst.

func _ready() -> void:
	_checkRequired() # Ensures all required variables are properly set.

	# Initialize and configure the recoil timer.
	_recoilTimer = Timer.new()
	add_child(_recoilTimer)
	_recoilTimer.wait_time = fireCooldown
	_recoilTimer.timeout.connect(_on_recoilTimer_timeout)
	_recoilTimer.one_shot = true
	_recoilTimer.name = "RecoilTimer"

	# Initialize and configure the burst timer.
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

# Handles the shooting logic by instantiating and firing a shot.
func _shootOnce() -> void:
	
	if _isShootingThroughWall():
		return
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

# Start the burst shooting sequence
func _shootBurst():
	_recoilTimer.start() # Starts the burst timer.
	_burstTimer.start()
	_isRecoiling = true # Marks the gun as reloading.
	
	_shootOnce()


# Callback for the recoil timer's timeout signal. Resumes shooting if required or ends reloading.
func _on_recoilTimer_timeout():
	if _isShooting:
		_recoilTimer.start() # Starts the recoil timer.
		if burstFire:
			_shootBurst()
		else:
			_shootOnce() # Continue shooting if the gun is in the shooting state.
	else:
		_isRecoiling = false # Otherwise, end the reloading state.

# Callback for the burst timer's timeout signal. Resumes shooting if required or ends the burst.
func _on_burstTimer_timeout():
	_shotsInCurrentBurst += 1
	
	if _shotsInCurrentBurst < burstShots:
		_shootOnce()
		_isRecoiling = true # Marks the gun as reloading.
		_burstTimer.start()
		
	else:
		_shotsInCurrentBurst = 0

## Starts the shooting process. Shoots immediately if the gun is not reloading.
func startShooting() -> void:
	_isShooting = true # Mark the gun as shooting.
	
	if not _isRecoiling:
		_recoilTimer.start() # Starts the reload timer.
		_isRecoiling = true
		if burstFire:
			_shootBurst()
		else:
			_shootOnce() # Fire a bullet if not in the middle of a reload.

## Stops the shooting process.
func stopShooting() -> void:
	_isShooting = false # Mark the gun as not shooting.

## Determines if the shooitngPoint and the player are on opposite sides on a wall
func _isShootingThroughWall() -> bool:
	# Create raycast that shoots between the character and the shootingPoint
	var raycast = RayCast2D.new()
	add_child(raycast)
	raycast.target_position = shootingPoints[0].position
	raycast.enabled = true
	
	# Check if raycast collided 
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		# Check if it collided with a wall
		if collider.is_in_group("walls"):
			raycast.queue_free()
			return true
	
	raycast.queue_free()
	return false
