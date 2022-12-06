extends Node2D

const Projectile = preload("res://prefabs/Projectile.tscn")
const IceProj = preload("res://prefabs/IceProjectile.tscn")
const FireProj = preload("res://prefabs/FireProjectile.tscn")
const LightProj = preload("res://prefabs/LightningProjectile.tscn")

var spell_id = 0

var ranged_dmg_mult = 1
var proj_size_mult = 1
var proj_speed_mult = 1

var rng = RandomNumberGenerator.new()

var cast = false
var lifetime = 1.5
var life_timer = 0.0

var root

func _ready():
	root = get_tree().get_root()

func _physics_process(delta):
	if cast:
		life_timer += delta
	
	if life_timer > lifetime:
		queue_free()

func cast_spell():
	if spell_id == 0:
		var projectile = Projectile.instance()
		projectile.size = projectile.size * proj_size_mult
		projectile.speed = projectile.speed * proj_speed_mult
		projectile.damage = projectile.damage * ranged_dmg_mult
		projectile.rotation_degrees = self.rotation_degrees
		projectile.global_position = self.global_position
		projectile.ready_shot()
		root.add_child(projectile)
		projectile.fire()
	elif spell_id == 1:
		var projectile = IceProj.instance()
		projectile.size = projectile.size * proj_size_mult
		projectile.speed = projectile.speed * proj_speed_mult
		projectile.damage = projectile.damage * ranged_dmg_mult
		projectile.rotation_degrees = self.rotation_degrees
		projectile.global_position = self.global_position + 20 * Vector2(cos(rotation), sin(rotation))
		var projectile2 = IceProj.instance()
		projectile2.size = projectile2.size * proj_size_mult
		projectile2.speed = projectile2.speed * proj_speed_mult
		projectile2.damage = projectile2.damage * ranged_dmg_mult
		projectile2.rotation_degrees = self.rotation_degrees - 30
		projectile2.global_position = self.global_position + 20 * Vector2(cos(rotation - PI/6), sin(rotation - PI/6))
		var projectile3 = IceProj.instance()
		projectile3.size = projectile3.size * proj_size_mult
		projectile3.speed = projectile3.speed * proj_speed_mult
		projectile3.damage = projectile3.damage * ranged_dmg_mult
		projectile3.rotation_degrees = self.rotation_degrees + 30
		projectile3.global_position = self.global_position + 20 * Vector2(cos(rotation + PI/6), sin(rotation + PI/6))
		
		projectile.ready_shot()
		root.add_child(projectile)
		projectile.fire()
		projectile2.ready_shot()
		root.add_child(projectile2)
		projectile2.fire()
		projectile3.ready_shot()
		root.add_child(projectile3)
		projectile3.fire()
	elif spell_id == 2:
		var projectile = FireProj.instance()
		projectile.size = projectile.size * proj_size_mult
		projectile.speed = projectile.speed * proj_speed_mult
		projectile.damage = projectile.damage * ranged_dmg_mult
		projectile.rotation_degrees = self.rotation_degrees
		projectile.global_position = self.global_position
		projectile.ready_shot()
		root.add_child(projectile)
		projectile.fire()
	elif spell_id == 3:
		var projectile = LightProj.instance()
		projectile.size = projectile.size * proj_size_mult
		projectile.speed = projectile.speed * proj_speed_mult
		projectile.damage = projectile.damage * ranged_dmg_mult
		rng.randomize()
		projectile.rotation_degrees = self.rotation_degrees + rng.randi_range(-20, 20)
		projectile.global_position = self.global_position
		projectile.ready_shot()
		root.add_child(projectile)
		projectile.fire()
	cast = true
