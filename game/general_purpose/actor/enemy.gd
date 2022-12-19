extends Actor
class_name Enemy

var energy := 3

func move_with_snap() -> void:
	vel = move_and_slide_with_snap( vel, Vector2.DOWN * 8, Vector2.UP, true )
