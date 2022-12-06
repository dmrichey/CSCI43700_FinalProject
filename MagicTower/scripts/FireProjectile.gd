extends "res://scripts/Projectile.gd"


export var explosion_delay = .5
export var explosion_damage = 30
var explosion_timer = 0.0
var enemies = Array()
var explosion_time = 0.7

func _physics_process(delta):
	explosion_timer += delta
	
	if explosion_timer >= explosion_delay:
		velocity = Vector2(0,0)
		$AnimatedSprite.play("explosion")
		$Explosion/AnimatedSprite.global_rotation = 0
		$Explosion/AnimatedSprite.play("explosion")
		enemies = $Explosion.get_overlapping_bodies()
		# for enemy in enemies:
		#	if enemy is Enemy:
		#		enemy.apply_damage(explosion_damage)
		
		
	if explosion_timer > explosion_time:
		queue_free()
	
	
