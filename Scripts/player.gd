extends Sprite2D

@onready var anim : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	anim.current_animation = "mouse_idle"

func _process(_delta):
	global_position = get_global_mouse_position() + Vector2(0,0)
