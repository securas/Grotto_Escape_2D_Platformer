extends StackedFSM_State

var wait_time = 0.5
var nxt_state : StackedFSM_State

var _wait_timer : float

func _initialize():
	_wait_timer = wait_time

func _run( delta : float ) -> void:
	_wait_timer -= delta
	if _wait_timer <= 0:
		fsm.pop()
		fsm.push( nxt_state )

