extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite
signal herb_died
var herb_health : int
var damage : int = 5

func setup(frame : int):
	$Sprite.frame = frame

func set_herb_health(frame : int):
	herb_health = 10 * (2 ** frame)

func get_total_frame():
	return sprite.hframes * sprite.vframes

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_on_take_damage()

func _on_take_damage ():
	herb_health -= damage
	if herb_health <= 0:
		herb_died.emit()
		queue_free()
