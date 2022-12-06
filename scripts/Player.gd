extends KinematicBody2D

const Spell = preload("res://prefabs/Spell.tscn")

# Movement Variables
export var run_speed = 200
export var jump_speed = -600
export var cut_jump_height = 0.5
export var gravity = 1200
var velocity = Vector2()
var movement_enabled = true
# Jump Variables
var jumping = false
var jump_pressed_timer = 0.0
var remember_jump_pressed_time = 0.1
var grounded_timer = 0.0
var remember_grounded_time = 0.1
# Combat Variables
var blocking = false
# Combat Resources
var max_health = 100
var current_health = 100
var dying = false
var max_mana = 100
var current_mana = max_mana
var mana_regen_rate = 2.5
var max_power = 100
var current_power = 0
# Combat Stats
var melee_damage = 10
var attack_speed = 2
var fire_rate = 1.5
# Melee Attack Animation Vars
var sword_id = 0
var attack = false
var attack_type_1 = true
var attacking = false
var attack_anim_duration = .5
var time_since_attack = 0.0
# Ranged Attack Animation Vars
var spell_id = 0
var mana_cost = 5
export var reticle_radius = 28
var firing = false
var shoot = false
var time_since_fire = 0.0
# Super Attack Vars
var super_id = 0
# Stat Multipliers
var melee_dmg_mult = 1
var attack_speed_mult = 1
var ranged_dmg_mult = 1
var fire_rate_mult = 1
var proj_size_mult = 1
var proj_speed_mult = 1
var max_health_mult = 1
var mana_regen_mult = 1
# Scene Transition 
var scene_manager = null
var enable_transition = false
var next_scene = 0

var facing_right = true
var aim = 0
var enemies = Array()

func get_input():
	# Reset Variables
	blocking = false
	attack = false
	shoot = false
	velocity.x = 0
	# Get User Input
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var jump = Input.is_action_just_pressed("jump")
	var stop_jump = Input.is_action_just_released("jump")
	var guard = Input.is_action_pressed("guard")
	var melee = Input.is_action_just_pressed("melee")
	firing = Input.is_action_pressed("ranged")	
	var super = Input.is_action_pressed("super")
	#Input Effects
	if guard and is_on_floor():
		movement_enabled = false
		blocking = true
	if left and movement_enabled:
		velocity.x -= run_speed
	if right and movement_enabled:
		velocity.x += run_speed
	if up:
		aim = 270
	if down:
		aim = 90
	if right:
		aim = 0
	if left:
		aim = 180
	if up and right:
		aim = 315
	if up and left:
		aim = 225
	if down and right:
		aim = 45
	if down and left:
		aim = 135
	if jump and enable_transition:
		scene_manager.change(next_scene)
	if jump and movement_enabled:
		jump_pressed_timer = remember_jump_pressed_time
	if stop_jump and velocity.y < 0:
		velocity.y *= cut_jump_height
	if melee:
		attack = true
	
	


func _physics_process(delta):
	# Variable Reset
	movement_enabled = true
	if facing_right:
		aim = 180
	else:
		aim = 0
	
	# Timers
	jump_pressed_timer -= delta
	grounded_timer -= delta
	if is_on_floor():
		grounded_timer = remember_grounded_time
	time_since_attack += delta
	if time_since_attack > attack_anim_duration:
		attacking = false
	if attacking and is_on_floor():
		movement_enabled = false
	time_since_fire += delta
	
	# Resources Check
	if (current_mana + (mana_regen_rate * mana_regen_mult)) < max_mana:
		current_mana += (mana_regen_rate * mana_regen_mult)
	if current_health < 0:
		dying = true 
	
	# Get User Input
	if !dying:
		get_input()
	
	# Start Jump
	if jump_pressed_timer > 0 and grounded_timer > 0:
		jump_pressed_timer = 0
		grounded_timer = 0
		velocity.y = jump_speed
	
	# Velocity Application
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# Melee Attack Handling
	if time_since_attack > (1/(attack_speed * attack_speed_mult)) and attack:
		attacking = true
		attack_type_1 = !attack_type_1
		time_since_attack = 0
	else:
		attack = false
	
	# If Enemy In Attack Area when Player Attacks
	if attack and facing_right:
		enemies = $AttackArea1.get_overlapping_bodies()
		firing = false
	elif attack and !facing_right:
		enemies = $AttackArea2.get_overlapping_bodies()
		firing = false
	
	# Apply Melee Damage to Enemies
	for entity in enemies:
		if entity is KinematicBody2D:
			entity.apply_damage(melee_damage)
			if (current_power + 2) < max_power:
				current_power += 2
			else:
				current_power = max_power
	
	# Pickup Object
	if enemies.size() > 0:
		# Currently Not Returning Anything On Attack
		# GetOverlappingBodies Not Working Here?
		print(enemies)
	for entity in enemies:
		if entity is StaticBody2D:
			pickup_object(entity)
	
	# Ranged Attack Handling
	if time_since_fire > (1/(fire_rate * fire_rate_mult)) and firing and !attack:
		time_since_fire = 0
		shoot = true
	else:
		shoot = false
	
	# Reticle Positioning
	$Reticle.rotation_degrees = aim
	$Reticle/AnimatedSprite.play()
	if spell_id == 0:
		$Reticle/AnimatedSprite.animation = "default"
	elif spell_id == 1:
		$Reticle/AnimatedSprite.animation = "ice"
	elif spell_id == 2:
		$Reticle/AnimatedSprite.animation = "fire"
	elif spell_id == 3:
		$Reticle/AnimatedSprite.animation = "lightning"
	
	# Spawn Projectile
	if shoot and current_mana > mana_cost:
		var spell = Spell.instance()
		spell.spell_id = spell_id
		spell.ranged_dmg_mult = ranged_dmg_mult
		spell.proj_size_mult = proj_size_mult
		spell.proj_speed_mult = proj_speed_mult
		spell.rotation_degrees = aim
		$Reticle/AnimatedSprite.add_child(spell)
		spell.cast_spell()
		# current_mana -= mana_cost
	
	# Animated Sprite Handling
	$AnimatedSprite.play()
	if velocity.x != 0:
		facing_right = velocity.x < 0
	$AnimatedSprite.flip_h = facing_right
	if dying:
		$AnimatedSprite.animation = "death"
	elif attacking and !is_on_floor():
		$AnimatedSprite.animation = "attackAir"
	elif attacking and attack_type_1:
		$AnimatedSprite.animation = "attack1"
	elif attacking and !attack_type_1:
		$AnimatedSprite.animation = "attack2"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "jump"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "fall"
	elif velocity.x != 0:
		$AnimatedSprite.animation = "run"
	elif blocking:
		$AnimatedSprite.animation = "parryStance"
	else:
		$AnimatedSprite.animation = "idle"	

func apply_damage(dmg_to_take):
	if current_health - dmg_to_take < max_health:
		current_health -= dmg_to_take
		print(current_health)

func pickup_object(object):
	if object.type == 0:
		sword_id = object.id
		melee_damage = object.melee_damage
		attack_speed = object.attack_speed
	if object.type == 1:
		spell_id = object.id
		mana_cost = object.mana_cost
		fire_rate = object.fire_rate
	if object.type == 2:
		super_id = object.id
	if object.type == 3:
		melee_dmg_mult += object.melee_dmg_mult
		attack_speed_mult += object.attack_speed_mult
		ranged_dmg_mult += object.ranged_dmg_mult
		fire_rate_mult += object.fire_rate_mult
		proj_size_mult += object.proj_size_mult
		proj_speed_mult += object.proj_speed_mult
		max_health_mult += object.max_health_mult
		
	object.queue_free()
