extends Reference
class_name FireFSM

enum FireStates { IDLE, COOLDOWN }

var _state : int = FireStates.IDLE
var _timer : float

var _idle_check_fire : FuncRef
var _fire : FuncRef
var _fire_finished : FuncRef

func _init( obj, idle_check_fire_fcn : String, fire_fcn : String, fire_finished_fcn : String ) -> void:
	_idle_check_fire = funcref( obj, idle_check_fire_fcn )
	_fire = funcref( obj, fire_fcn )
	_fire_finished = funcref( obj, fire_finished_fcn )


func run_machine( delta : float ) -> void:
	match _state:
		FireStates.IDLE:
			if _idle_check_fire.call_func():
				_timer = _fire.call_func()
				_state = FireStates.COOLDOWN
		FireStates.COOLDOWN:
			_timer -= delta
			if _timer <= 0:
				_state = FireStates.IDLE
				_fire_finished.call_func()

