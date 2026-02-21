class_name GameManager

extends Node

@onready var background_image : Sprite2D = $"../BushesBackground"
@onready var player : Sprite2D = $"../Player"
@onready var anim : AnimationPlayer = $"../Player/AnimationPlayer"

#this will be changed later
@export var herbs_per_wave : int = 10

var herb_scene = preload("res://scenes/herb_scene.tscn")
var background_texture = preload("res://assets/background/garden_background.jpg")

var current_frames : Array = [0, 1, 2]
var kill_count : int = 0
var current_level : int = 1
var required_kills : int = 1 #temporary value
var herb_probalities : Array = [100.0, 0.0, 0.0]
var alive_herbs : int = 0
var base_probability : float = 2.5
var prob_upgrade : float = 1.0 #will be used when upgrades be launched

func _ready() -> void:
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
		var herb_index = get_random_herb()
		herb.setup(herb_index)
		herb.set_herb_health(herb_index)
		herb.position = available_spots[h].position
		herb.herb_died.connect(kill_herb)
		herb.change_scythe.connect(change_player_sprite_scythe)
		herb.change_mouse_idle.connect(change_player_sprite_mouse)
	
#monitor how many herbs are alive to later respawn it when the alive reach 0
func kill_herb():
	alive_herbs -= 1
	if alive_herbs == 0: 
		kill_count += 1
		await get_tree().create_timer(0.2).timeout
		spawn_herb()

func change_player_sprite_scythe():
	anim.current_animation = "RESET"
	player.hframes = 1
	player.texture = load("res://assets/tools/Scythe_1.png")

func change_player_sprite_mouse():
	anim.current_animation = "mouse_idle"
	player.hframes = 4
	player.texture = load("res://assets/tools/Mouse_idle_1.png")

#change the level, changing the herb spawn, sprite, and also the background
func change_level ():
	current_level += 1
	#required_kills = current_level * 1.25
	kill_count = 0
	change_probability(current_level)

#get a herb depending on the probability for that, only possible for 3 different herb/level
func get_random_herb ():
	var total_weight = 0.0
	var index = 0
	
	for prob in herb_probalities:
		total_weight += prob
	
	var roll = randf_range(0, total_weight)
	var cursor = 0.0
	
	#need to normalize it so it will be always 100.0
	for p in herb_probalities:
		cursor += p
		if roll <= cursor:
			return current_frames[index]
		index += 1

#change the probalility depending in which level the player is.
func change_probability (level : int):
	if herb_probalities [0] < herb_probalities [2]:
		swap_probabilities()
	
	if level % 2 == 0:
		herb_probalities [0] -= base_probability * prob_upgrade
		herb_probalities [1] += base_probability * prob_upgrade

	if level % 3 == 0:
		herb_probalities [0] -= base_probability * prob_upgrade
		herb_probalities [2] += base_probability * prob_upgrade

#change the herb_probability and update the current_frames for new plants
func swap_probabilities ():
	var index = 0
	base_probability = base_probability/2
	
	herb_probalities [0] = herb_probalities [1] + herb_probalities [2]
	herb_probalities [1] = 100 - herb_probalities [0]
	herb_probalities [2] = 0
	
	while index < 3:
		current_frames [index] += 1
		index += 1
