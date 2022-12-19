extends Tween

var sprite# : Sprite
var duration : float
var count : int

func _prepare_tween():
	var parent = get_parent()
#	if not parent is Sprite: return
	sprite = parent
	var _ret : int
	_ret = stop_all()
	_ret = remove_all()
	var tstep = duration / float( count )
	for idx in range( count ):
		_ret = interpolate_property( sprite, "modulate", sprite.modulate, Color( 100, 100, 100 ), 0, \
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, float( idx ) * tstep )
		_ret = interpolate_property( sprite, "modulate", sprite.modulate, Color( 1, 1, 1 ), 0, \
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, float( idx ) * tstep + tstep * 0.5 )
	_ret = .start()

func start( new_duration : float = 0.3, new_count : int = 4 ):
	duration = new_duration
	count = new_count
	_prepare_tween()


func _on_flash_tween_tween_all_completed() -> void:
	sprite.modulate = Color( 1, 1, 1 )
