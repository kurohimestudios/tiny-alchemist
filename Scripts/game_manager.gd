class_name GameManager
extends Node

var herb_scene = preload("res://scenes/herb_scene.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		spawn_herb()

func spawn_herb ():
	var herb = herb_scene.instantiate()
	$"../Herbs".add_child(herb)
	herb.position = $"../HerbSpawner".get_children().pick_random().position
