extends Camera2D
class_name LinkedCamera

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

var _is_pan := false
var _pan_to : Vector2
var _pan_duration : float
var _pan_tween : Tween

var _target_node : Node2D
var _temporary_target_ref : Reference
var _is_temporary_target := false
var _temporary_target_timer := 0.0

var disable_target := false

func _ready():
	_target_node = get_parent()
	set_as_toplevel( true )
	global_position = _target_node.global_position
	
#	call_deferred( "_align_camera_now" )
	var _ret : int
	_ret = sigmgr.connect( "camera_shake", self, "_on_camera_shake" )
	_ret = sigmgr.connect( "camera_pan", self, "_on_pan_camera" )
	_ret = sigmgr.connect( "camera_temporary_target", self, "_on_camera_temporary_target" )
	_pan_tween = Tween.new()
	add_child( _pan_tween )
	
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = 0.05
	t.autostart = true
	_ret = t.connect( "timeout", self, "reset_smoothing" )
	add_child(t)
	


func _align_camera_now():
	yield( get_tree().create_timer(0.05), 'timeout' )
	reset_smoothing()

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

func _on_pan_camera( pan_to : Vector2, duration : float ):
	if pan_to.is_equal_approx(_pan_to ): return
	_is_pan = true
	var drag = Vector2( drag_margin_left, drag_margin_top )
	_pan_to = pan_to
	_pan_duration = duration
	
	var _ret : int
	_ret = _pan_tween.stop_all()
	_ret = _pan_tween.remove_all()
	var pan_target = 2 * pan_to / drag
	_ret = _pan_tween.interpolate_property(
		self, "offset_v", offset_v, pan_target.y, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	_ret = _pan_tween.start()
	drag_margin_v_enabled = false
	
	if _pan_to.is_equal_approx( Vector2.ZERO ):
		yield( _pan_tween, "tween_all_completed" )
		drag_margin_v_enabled = true



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

func _on_camera_temporary_target( target = null, duration : float = 1.0 ):
	if target:
		_temporary_target_ref = weakref( target )
		_temporary_target_timer = duration
		_is_temporary_target = true
	else:
		_is_temporary_target = false

func _physics_process( delta ):
	# shake camera
	if _compute_shake( delta ):
		offset = _shake_offset
	else:
		offset *= 0
	
	if not disable_target:
		if not _is_temporary_target:
			global_position = _target_node.global_position#.round()
		else:
			if _temporary_target_ref:
				global_position = _temporary_target_ref.get_ref().global_position
				if _temporary_target_timer > 0:
					_temporary_target_timer -= delta
					if _temporary_target_timer <= 0:
						_is_temporary_target = false
			else:
				_is_temporary_target = false
