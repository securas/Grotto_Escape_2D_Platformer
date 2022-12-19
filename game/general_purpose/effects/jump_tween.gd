extends Tween

export( float ) var height := 6.0
export( float ) var duration := 0.8
export( bool ) var autostart := true

func _ready() -> void:
	var parent = get_parent()
#	if not parent is Node2D: return
	var initial_height = parent.position.y
	var _ret : int
	_ret = interpolate_property( parent, "position:y", \
		initial_height, initial_height - height, duration * 0.5, \
		Tween.TRANS_SINE, Tween.EASE_OUT, 0.0 )
	_ret = interpolate_property( get_parent(), "position:y", \
		initial_height - height, initial_height, duration * 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN, 0.5 )
	if autostart:
		call_deferred( "start" )
