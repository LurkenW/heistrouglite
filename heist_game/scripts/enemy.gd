extends CharacterBody2D

@onready var target = get_node("/root/root/CharacterBody2D")

const SPEED = 50.0

func _physics_process(delta: float) -> void:
#	if target != null:
#		_move_to_target(target)
	pass

	#Calculates porition of target and movees towards them
func _move_to_target(target):
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * SPEED
	look_at(target.global_position)
	move_and_slide()

func takeDamage():
	pass
