class_name GameManager

extends Node

var herb_scene = preload("res://scenes/herb_scene.tscn")
var current_frame : int = 0

#this will be changed later
@export var herbs_per_wave : int = 5
var alive_herbs : int = 0

func _ready() -> void:
	spawn_herb()

func spawn_herb ():
	var available_spots = $"../HerbSpawner".get_children().duplicate()
	available_spots.shuffle()
	
	alive_herbs = herbs_per_wave
	
	for h in herbs_per_wave:
		var herb = herb_scene.instantiate()
		$"../Herbs".add_child(herb)
		herb.setup(current_frame)
		herb.set_herb_health(current_frame)
		herb.position = available_spots[h].position
		herb.herb_died.connect(kill_herb)
	

func kill_herb():
	alive_herbs -= 1
	if alive_herbs == 0: 
		current_frame += 1
		spawn_herb()
