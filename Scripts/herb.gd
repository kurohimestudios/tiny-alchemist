extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite
signal herb_died

func setup(frame : int):
	$Sprite.frame = frame

func get_total_frame():
	return sprite.hframes * sprite.vframes

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			herb_died.emit()
			queue_free()
