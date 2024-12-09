extends Area2D

var travelledDisance: float = 0
const SPEED: float = 1000
const RANGE: float = 15000

func _physics_process(delta: float) -> void:
	
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelledDisance = SPEED * delta
	if travelledDisance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("takeDamage"):
		body.takeDamage()
