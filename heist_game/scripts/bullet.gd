extends Area2D


var travelledDisance: float = 0 # Tracks the total distance the bullet has traveled.
const SPEED: float = 2000 # The speed at which the bullet travels (units per second).
const RANGE: float = 10000 # The maximum distance the bullet can travel before it is removed.

var damage: int # The amount of damage the bullet deals when it hits a target.

# The initial direction of the bullet, determined by its rotation when spawned.
@onready var direction: Vector2 = Vector2.RIGHT.rotated(rotation)

# Called every frame to update the bullet's position and handle range checks.
func _physics_process(delta: float) -> void:
	# Move the bullet in its direction at the specified speed.
	position += direction * SPEED * delta
	
	# Track the distance traveled by the bullet.
	travelledDisance += SPEED * delta
	
	# Remove the bullet if it exceeds its range.
	if travelledDisance > RANGE:
		queue_free()

# Called when the bullet collides with another object.
func _on_body_entered(body: Node2D) -> void:
	# Remove the bullet from the scene.
	queue_free()
<<<<<<< Updated upstream
	
	# If the collided object has a takeDamage method, apply damage to it.
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
=======
	if body.has_method("take_damage"):
		body.take_damage(damage)
>>>>>>> Stashed changes

# Sets the damage value for the bullet.
func set_damage(dmg):
	damage = dmg
