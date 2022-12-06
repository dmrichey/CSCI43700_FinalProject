extends KinematicBody2D

export var size = .8
export var speed = 350
export var damage = 5

var velocity = Vector2()

var lifetime = 1.4
var life_timer = 0.0

func _physics_process(delta):
	life_timer += delta
	
	var collision = move_and_collide(velocity * delta)
	
	if collision != null:
		hit(collision.collider)
	
	if life_timer > lifetime:
		queue_free()

func ready_shot():
	scale *= size

func fire():
	var angle = self.rotation
	velocity = Vector2(cos(angle), sin(angle)) * speed

func hit(collider):
	# Check if Collision is with Enemy
	# # Apply Damage to Enemy 
	if collider is KinematicBody2D:
		collider.apply_damage(damage)
	
	# Hit Particle Effect?
	queue_free()
