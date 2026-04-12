extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite
signal herb_died
signal change_scythe
signal change_mouse_idle
var herb_health : int
var damage : int = 5

func setup(frame : int):
	$Sprite.frame = frame

#determine herb hp scaling (changes to be made here)
func set_herb_health(frame : int):
	herb_health = 1 * (2 ** frame) #temporary value

#return how many herbs there are in the sprite sheet
func get_total_frame():
	return sprite.hframes * sprite.vframes

#recognize the input (click) on the herbs, and calls the take damage function
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_on_take_damage()
			

#register how much damage the herb take, killing it if the hp gets to 0
func _on_take_damage ():
	herb_health -= damage
	flash()
	if herb_health <= 0:
		herb_died.emit()
		queue_free()
		_on_area_2d_mouse_exited()

#flash the plant when it takes damage, the result is not the desired one it still need improvement
func flash():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite.material, 'shader_parameter/progress', 1.0, 0.2)
	tween.tween_property($Sprite.material, 'shader_parameter/progress', 0.0, 0.4)

func _on_area_2d_mouse_entered():
	change_scythe.emit()

func _on_area_2d_mouse_exited():
	change_mouse_idle.emit.call_deferred()
