extends KinematicBody2D

const Projectile = preload("res://prefabs/EnemyProjectile.tscn")

var facing_right = true
var speed = 50
var move_time = 2.5
var move_timer = 0.0
var velocity = Vector2();

var shot_timer = 0.0
var fire_rate = 1
var rng = RandomNumberGenerator.new()

var health = 25

func _physics_process(delta):
	if health < 0:
		queue_free()
	
	move_timer += delta
	shot_timer += delta
	if move_timer > move_time:
		facing_right = !facing_right
		move_timer = 0.0
	
	if facing_right:
		velocity = Vector2.RIGHT
	else:
		velocity = Vector2.LEFT
	
	velocity *= speed
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	$AnimatedSprite.play()
	
	if shot_timer > (1/fire_rate):
		shot_timer = 0.0
		var projectile = Projectile.instance()
		rng.randomize()
		projectile.rotation_degrees = self.rotation_degrees + rng.randi_range(225, 315)
		projectile.global_position = self.global_position + (20 * Vector2(cos(projectile.rotation), sin(projectile.rotation))) + Vector2(0, -40)
		projectile.ready_shot()
		get_tree().get_root().add_child(projectile)
		projectile.fire()

func apply_damage(damage):
	health -= damage
