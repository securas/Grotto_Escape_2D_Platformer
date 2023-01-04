extends StackedFSM_State

var _idle_timer : float


func _initialize() -> void:
	_idle_timer = 1.0

func _run( delta : float ) -> void:
	if _idle_timer > 0:
		_idle_timer -= delta
		if _idle_timer <= 0:
			_set_nxt_state()


func _set_nxt_state() -> void:
	fsm.push( fsm.states.fire_up )



