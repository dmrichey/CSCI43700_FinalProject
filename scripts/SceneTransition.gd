extends Area2D


export var next_scene = 1

func body_entered(other):
	print(other)
	other.get_script().enable_transition = true
	other.get_script().next_scene = next_scene

func body_exited(other):
	other.get_script().enable_transition = false
