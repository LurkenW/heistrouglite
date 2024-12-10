extends Node2D

var shootingPoint: Marker2D
var gun_damage = 15

func shoot() -> void:
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_damage(gun_damage)
	
	new_bullet.global_position = $WeaponPivot/Icon/ShootingPoint.global_position
	new_bullet.global_rotation = $WeaponPivot/Icon/ShootingPoint.global_rotation
	
	get_node("/root").add_child(new_bullet)
	 
