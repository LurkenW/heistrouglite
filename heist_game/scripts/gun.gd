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
## The magazine size
@export var magazineSize: int = 8

@export_group("Burst")
## Enables burst-fire mode
@export var burstFire: bool = false
## Number of shots fired in a single burst
@export var burstShots: int = 3
## Time (in seconds) between shots in a burst.
@export var burstCooldown: float = 0.05

var _isShooting: bool = false # Tracks whether the gun is currently in a shooting state.
var _isRecoiling: bool = false # Tracks whether the gun is currently recoiling.
var _isReloading: bool = false # Tracks whether the gun is currently reloading.

var _recoilTimer: Timer # Internal Timer instance used for handling the time between shots or bursts.
var _burstTimer: Timer # Internal Timer instance used for handling the time between shots in a burst.
var _reloadTimer: Timer # Internal Timer instance used for handling the reload time.

var _shotsInCurrentBurst: int = 0 # Counts the number of shots that has been shot in the current burst.
var _shotsInCurrentMagazine: int = 0 # Counts the number of shots that has been shot in the current magazine.


func _ready() -> void:
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
	
	# Initialize and configure the reload timer.
	_reloadTimer = Timer.new()
	add_child(_reloadTimer)
	_reloadTimer.wait_time = reloadCooldown
	_reloadTimer.timeout.connect(_on_reloadTimer_timeout)
	_reloadTimer.one_shot = true
	_reloadTimer.name = "ReloadTimer"

# Tries to shoot if possible
func _tryShoot() -> void:
	
	if not _isShooting:
		return

	if _isRecoiling:
		return

	if _isReloading:
		return
	
	if burstFire:
		_shootBurst()
		_checkReload()
		_burstTimer.start()
	else:
		_shootOnce()
		_checkReload()
		
		_recoilTimer.start()
		_isRecoiling = true

func _on_recoilTimer_timeout():
	_isRecoiling = false
	_tryShoot()

func _on_burstTimer_timeout():
	_shootBurst()

func _on_reloadTimer_timeout():
	_shotsInCurrentBurst = 0
	_shotsInCurrentMagazine = 0
	
	_isReloading = false
	_tryShoot()

# Handles the shooting logic and instantiate and fire a shot.
func _shootOnce() -> void:
	_shotsInCurrentMagazine += 1
	
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

# Handels the burst shooting logic
func _shootBurst():
	
	if _shotsInCurrentBurst < burstShots:
		_shotsInCurrentBurst += 1
		_shootOnce()
		_burstTimer.start()

	else:
		_shotsInCurrentBurst = 0
		_isRecoiling = true
		_recoilTimer.start()

# Check if needing to reload
func _checkReload():
	if _shotsInCurrentMagazine >= magazineSize:
		_isReloading = true
		_reloadTimer.start()
		

# Determines if the shooitngPoint and the player are on opposite sides on a wall
func _isShootingThroughWall() -> bool:
	# Create raycast that shoots between the character and the shootingPoint
	var raycast = RayCast2D.new()
	add_child(raycast)
	raycast.target_position = shootingPoints[0].position
	raycast.enabled = true
	
	# Check if raycast collided 
	raycast.force_raycast_update()
	if raycast.is_colliding():
		# var collider = raycast.get_collider() Might want to check what it collided with
		raycast.queue_free()
		return true
	
	raycast.queue_free()
	return false


## Starts the shooting process. Shoots immediately if the gun is not reloading.
func startShooting() -> void:
	_isShooting = true # Mark the gun as shooting.
	
	_tryShoot()

## Stops the shooting process.
func stopShooting() -> void:
	_isShooting = false # Mark the gun as not shooting.

## Reloads the weapon.
func reload() -> void:
	_isReloading = true
	_reloadTimer.start()
