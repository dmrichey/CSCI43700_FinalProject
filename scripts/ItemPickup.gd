extends StaticBody2D

export var type = 1
export var id = 0
export var mana_cost = 5
export var fire_rate = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if id == 0:
		$AnimatedSprite2.animation = "default"
	elif id == 1:
		$AnimatedSprite2.animation = "ice"
	elif id == 2:
		$AnimatedSprite2.animation = "fire"
	elif id == 3:
		$AnimatedSprite2.animation = "light"


