extends Tween

#func _ready() -> void:
	

func start():
	var p = get_parent()
	var _ret : int
	_ret = stop_all()
	_ret = remove_all()
	_ret = interpolate_property( p, "rotation", \
		0.0, 0.2, 0.025, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0 )
	_ret = interpolate_property( p, "rotation", \
		0.2, -0.2, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.025 )
	_ret = interpolate_property( p, "rotation", \
		-0.2, 0.2, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.075 )
	_ret = interpolate_property( p, "rotation", \
		0.2, 0.0, 0.025, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.125 )
	_ret = .start()
