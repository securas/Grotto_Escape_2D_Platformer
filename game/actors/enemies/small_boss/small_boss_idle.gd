extends StackedFSM_State

var timer : float

func _initialize() -> void:
	anim.nxt( "idle" )
	timer = 2.0

func _run( delta : float ) -> void:
	timer -= delta
	if timer <= 0:
		fsm.push( fsm.states.eight_cycle )
