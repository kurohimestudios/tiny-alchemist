extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite
signal herb_died
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
	if herb_health <= 0:
		herb_died.emit()
		queue_free()
