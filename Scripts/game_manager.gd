class_name GameManager
extends Node

var herb_scene = preload("res://scenes/herb_scene.tscn")

#this will be changed later
@export var herbs_per_wave : int = 5

func _ready() -> void:
	spawn_herb()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		kill_herb()

func spawn_herb ():
	var available_spots = $"../HerbSpawner".get_children().duplicate()
	available_spots.shuffle()
	
	for h in herbs_per_wave:
		var herb = herb_scene.instantiate()
		$"../Herbs".add_child(herb)
		herb.position = available_spots[h].position

func kill_herb():
	if $"../Herbs".get_children():
		$"../Herbs".get_children().pick_random().queue_free()
	else:
		spawn_herb()
