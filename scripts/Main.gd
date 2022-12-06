extends Node2D

# Preload All Scenes
# Separate into Arrays by Scene type?
var scenes = [preload("res://scenes/TutorialScreen.tscn").instance(), \
				preload("res://scenes/CombatArena_1.tscn").instance()]

var current_scene = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(scenes[current_scene])
	$Player.global_position = Vector2(0,-1)
	$Player.scene_manager = self

func change(scene_index):
	add_child(scenes[scene_index])
	remove_child(scenes[current_scene])
	current_scene = scene_index
	$Player.global_position = Vector2(0,-1)
