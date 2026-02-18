class_name GameManager

extends Node

@onready var background_image : Sprite2D = $"../BushesBackground"

var herb_scene = preload("res://scenes/herb_scene.tscn")
var current_frame : int = 0
var kill_count : int = 0
var current_level : int = 1
var required_kills : int = 10

#this will be changed later
@export var herbs_per_wave : int = 5
var alive_herbs : int = 0

func _ready() -> void:
	set_brightness()
	spawn_herb()

#spawn herbs using random existing points and exact number depending where the game is
func spawn_herb ():
	var available_spots = $"../HerbSpawner".get_children().duplicate()
	available_spots.shuffle()
	
	if kill_count == required_kills:
		change_level()
	
	alive_herbs = herbs_per_wave
	
	for h in herbs_per_wave:
		var herb = herb_scene.instantiate()
		$"../Herbs".add_child(herb)
		herb.setup(current_frame)
		herb.set_herb_health(current_frame)
		herb.position = available_spots[h].position
		herb.herb_died.connect(kill_herb)
	
#monitor how many herbs are alive to later respawn it when the alive reach 0
func kill_herb():
	alive_herbs -= 1
	if alive_herbs == 0: 
		kill_count += 1
		await get_tree().create_timer(0.2).timeout
		spawn_herb()

#temporary function to deal with the background brightness
func set_brightness ():
	background_image.modulate = Color(0.8, 0.8, 0.8, 1)

#change the level, changing the herb spawn, sprite, and also the background
func change_level ():
	current_level += 1
	required_kills = current_level * 1.25
	kill_count = 0
	
	if current_level >= 5:
		current_frame += 1
		background_image.texture = load("res://assets/background/garden_background.jpg")
	
