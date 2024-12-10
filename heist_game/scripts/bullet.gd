extends Area2D

var travelledDisance: float = 0
const SPEED: float = 2000
const RANGE: float = 15000
var damage

@onready var direction: Vector2 = Vector2.RIGHT.rotated(rotation)


func _physics_process(delta: float) -> void:
	
	position += direction * SPEED * delta
	
	travelledDisance = SPEED * delta
	if travelledDisance > RANGE:
		queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("takeDamage"):
		body.takeDamage(damage)

func set_damage(dmg):
	damage = dmg
