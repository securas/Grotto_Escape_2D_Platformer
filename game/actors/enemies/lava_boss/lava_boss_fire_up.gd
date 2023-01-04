extends StackedFSM_State

enum FireUpStates { RAISING, FIRE, LOWERING }

const FIRE_INTERVAL = 0.25


var fire_count : int = 5
var double_fire : bool = true

var _tw : Tween
var _state : int
var _fire_timer : float
var _fire_counter : int

func _ready() -> void:
	_tw = Tween.new()
	_tw.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child( _tw )
	var _ret = _tw.connect( "tween_all_completed", self, "_finished_tween" )

func _initialize() -> void:
	_state = FireUpStates.RAISING
	_fire_counter = 0
	_fire_timer = 0.0
	_setup_raise()
	
	if fire_type == 0:
		fire_type = 1
	elif fire_type == 1:
		fire_type = 0

func _run( delta : float ) -> void:
	match _state:
		FireUpStates.FIRE:
			_fire_timer -= delta
			if _fire_timer <= 0:
				_fire_counter += 1
				if _fire_counter == fire_count + 1:
					if double_fire:
						if fire_type == 0:
							_initialize()
						elif fire_type == 1:
							_state = FireUpStates.LOWERING
							_setup_lower()
					else:
						_state = FireUpStates.LOWERING
						_setup_lower()
				else:
					_fire()
					_fire_timer = FIRE_INTERVAL
				
			



func _setup_raise() -> void:
	var _ret : int
	_ret = _tw.stop_all()
	_ret = _tw.remove_all()
	_ret = _tw.interpolate_property( obj.rotate, "rotation", \
		obj.rotate.rotation, -PI / 4, 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
	_ret = _tw.start()

func _setup_lower() -> void:
	var _ret : int
	_ret = _tw.stop_all()
	_ret = _tw.remove_all()
	_ret = _tw.interpolate_property( obj.rotate, "rotation", \
		obj.rotate.rotation, 0.0, 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
	_ret = _tw.start()

func _finished_tween():
	match _state:
		FireUpStates.RAISING:
			anim.nxt( "fire" )
			_state = FireUpStates.FIRE
		FireUpStates.LOWERING:
			_end_fire()
			anim.nxt( "idle" )

func _end_fire():
	fsm.pop()


var fire_type := 0
func _fire():
	var minv = 45.0
	var maxv = 131.0
	var fire_vel : float
	if fire_type == 0:
		fire_vel = float( fire_count - _fire_counter + 1 ) / ( fire_count - 1 ) * ( maxv - minv ) + minv
	elif fire_type == 1:
		fire_vel = float( fire_count - _fire_counter + 0.5 ) / ( fire_count - 1 ) * ( maxv - minv ) + minv

	
	var b = preload( "res://actors/enemies/lava_boss/projectile/lava_boss_projectile.tscn" ).instance()
	b.position = obj.get_node( "rotate/firepos" ).global_position
	b.scalar_vel = clamp( fire_vel, minv, maxv )
	obj.get_parent().add_child( b )
	
