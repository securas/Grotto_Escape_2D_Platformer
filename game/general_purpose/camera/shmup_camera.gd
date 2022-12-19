extends Camera2D


var screenshake_level := 3.0

var _duration := 0.0
var _period_in_ms := 0.0
var _amplitude := 0.0
var _timer := 0.0
var _last_shook_timer := 0.0
var _previous_x := 0.0
var _previous_y := 0.0
var _last_offset := Vector2.ZERO
var _shake_offset := Vector2.ZERO
var _shake_dir := Vector2.ZERO


func _ready() -> void:
	set_as_toplevel(true)
	position = get_parent().position
	reset_smoothing()
	var _ret : int
	_ret = sigmgr.connect( "camera_shake", self, "_on_camera_shake" )

func _on_camera_shake( duration : float, frequency : float, amplitude : float, direction : Vector2 = Vector2.ZERO ):
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_amplitude *= float( screenshake_level ) / 3.0
	_previous_x = rand_range(-1.0, 1.0)
	_previous_y = rand_range(-1.0, 1.0)
	_shake_offset -= _last_offset
	_last_offset = Vector2.ZERO
	_shake_dir = direction

func _compute_shake( delta : float ) -> bool:
	if _timer != 0:
		# Only shake on certain frames.
		_last_shook_timer = _last_shook_timer + delta
		# Be mathematically correct in the face of lag; usually only happens once.
		while _last_shook_timer >= _period_in_ms:
			_last_shook_timer = _last_shook_timer - _period_in_ms
			# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
			var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
			# Noise calculation logic from http://jonny.morrill.me/blog/view/14
			var new_x = rand_range(-1.0, 1.0)
			var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
			var new_y = rand_range(-1.0, 1.0)
			var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
			_previous_x = new_x
			_previous_y = new_y
			# Track how much we've moved the offset, as opposed to other effects.
			var new_offset = Vector2(x_component, y_component)
			_shake_offset -= _last_offset - new_offset
			_last_offset = new_offset
		# Reset the offset when we're done shaking.
		_timer = _timer - delta
		if _timer <= 0:
			_timer = 0
			_shake_offset -= _last_offset
		return true
	else:
		_shake_offset = _shake_offset.linear_interpolate( Vector2.ZERO, delta )
		return false

func _physics_process( delta: float ) -> void:
	position.x = get_parent().position.x
	# shake camera
	if _compute_shake( delta ):
		offset = _shake_offset
	else:
		offset *= 0
	
