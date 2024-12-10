extends Node
class_name Gun

@export var damage: int 
@export var shootingPoint: Marker2D
@export var fireCooldown: int


func shoot() -> void:
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_damage(damage)
	
	new_bullet.global_position = $WeaponPivot/Icon/ShootingPoint.global_position
	new_bullet.global_rotation = $WeaponPivot/Icon/ShootingPoint.global_rotation
	
	get_node("/root").add_child(new_bullet)
	 
