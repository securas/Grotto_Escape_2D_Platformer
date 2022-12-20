extends Node2D

signal half_cycle_started
signal half_cycle_finished
signal return_cycle_started
signal return_cycle_finished

enum TweenTrans {
	TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART,
	TRANS_QUAD, TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC,
	TRANS_CIRC, TRANS_BOUNCE, TRANS_BACK
}
enum TweenEase {
	EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN
}

export( bool ) var player_trigger := true
export( float ) var player_trigger_timer := 0.25
export( bool ) var start_immediately := true
export( bool ) var return_to_original := true
export( bool ) var keep_moving := true
export( float ) var wait_before_start := 0.0
export( float ) var half_cycle_duration := 1.0
export( float ) var wait_after_half_cycle := 0.5
export( float ) var return_cycle_duration := 1.0
export( float ) var wait_after_return_cycle := 0.0

export( TweenTrans ) var half_cycle_transition := TweenTrans.TRANS_SINE
export( TweenEase ) var half_cycle_ease := TweenEase.EASE_IN_OUT
export( TweenTrans ) var return_cycle_transition := TweenTrans.TRANS_SINE
export( TweenEase ) var return_cycle_ease := TweenEase.EASE_IN_OUT


var _platforms : Array
var _trigger_areas : Array
var _moving_elements : Array
var _tween : Tween
var _final_position : Vector2
var _start_timer : Timer
var _is_moving := false
var _is_triggered := false
var _trigger_timer := 0.0

func _ready():
	set_physics_process( false )
	for c in get_children():
		if c is KinematicBody2D:
			_platforms.append( { "node" : c, "pos" : c.position } )
		if c is Area2D:
			_trigger_areas.append( { "node" : c, "pos" : c.position } )
		if c is KinematicBody2D or c is Area2D:
			_moving_elements.append( { "node" : c, "pos" : c.position } )
		if c is Position2D:
			_final_position = c.position
			
	
	call_deferred( "_set_additional_elements" )
	if player_trigger:
		_set_trigger_elements()
	elif start_immediately:
		call_deferred( "_start_tween", true )

func start():
	call_deferred( "_start_tween", true )

func _start_tween( first_tween : bool = false ) -> void:
	_reset_tween( first_tween )
	var _ret = _tween.start()

func _set_additional_elements():
	_tween = Tween.new()
	_tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child( _tween )

func _set_trigger_elements():
	_is_triggered = false
	_is_moving = false
	set_physics_process( true )


func _physics_process(delta: float) -> void:
	if not _is_triggered:
		# check player
		for a in _trigger_areas:
			var c = a.node.get_overlapping_bodies()
			if c:
				_is_triggered = true
				_is_moving = false
				_trigger_timer = player_trigger_timer
				break
	else:
		if _trigger_timer > 0:
			_trigger_timer -= delta
			
			_is_triggered = false
			for a in _trigger_areas:
				var c = a.node.get_overlapping_bodies()
				if c:
					_is_triggered = true
			
			if _trigger_timer <= 0:
				_is_moving = true
				_reset_tween( true )
				var _ret = _tween.start()
				set_physics_process( false )


func _reset_tween( first_cycle : bool = false ) -> void:
	var half_cycle_start = wait_before_start if first_cycle else 0.0
	var return_cycle_start = half_cycle_start + half_cycle_duration + wait_after_half_cycle
	var _ret : int
	_ret = _tween.stop_all()
	_ret = _tween.remove_all()
	
	for m in _moving_elements:
		# half cycle
		_ret = _tween.interpolate_property( m.node, "position", \
			m.pos, m.pos + _final_position, half_cycle_duration, \
			half_cycle_transition, half_cycle_ease, half_cycle_start )
		if not return_to_original: continue
		# return cycle
		_ret = _tween.interpolate_property( m.node, "position", \
			m.pos + _final_position, m.pos, return_cycle_duration, \
			return_cycle_transition, return_cycle_ease, return_cycle_start )
	# triggers
	_ret = _tween.interpolate_callback( self, \
		half_cycle_start, "_on_half_cycle_started" )
	_ret = _tween.interpolate_callback( self, \
		half_cycle_start + half_cycle_duration, "_on_half_cycle_finished" )
	
	if return_to_original:
		_ret = _tween.interpolate_callback( self, \
			return_cycle_start, "_on_return_cycle_started" )
		_ret = _tween.interpolate_callback( self, \
			return_cycle_start + return_cycle_duration, "_on_return_cycle_finished" )
	
	# end of the cycle
	if return_to_original:
		_ret = _tween.interpolate_callback( self, \
			return_cycle_start + return_cycle_duration + wait_after_return_cycle, \
			"_on_cycle_finished" )
	else:
		_ret = _tween.interpolate_callback( self, \
			half_cycle_start + half_cycle_duration + wait_after_half_cycle, \
			"_on_cycle_finished" )


func _on_half_cycle_started() -> void:
	emit_signal( "half_cycle_started" )
func _on_half_cycle_finished() -> void:
	emit_signal( "half_cycle_finished" )
func _on_return_cycle_started() -> void:
	emit_signal( "return_cycle_started" )
func _on_return_cycle_finished() -> void:
	emit_signal( "return_cycle_finished" )

	
func _on_cycle_finished() -> void:
	if return_to_original:
		if keep_moving:
			_reset_tween()
			var _ret = _tween.start()
		else:
			if player_trigger:
				_set_trigger_elements()



















