extends "res://scripts/Projectile.gd"


func _physics_process(delta):
	velocity.y += 1200 * delta
