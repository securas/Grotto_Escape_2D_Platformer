extends FSM_State


var hit_timer : float

func _initialize() -> void:
	anim.nxt( "hit" )
	hit_timer = 0.2

func _run( delta : float ) -> void:
	hit_timer -= delta
	if hit_timer <= 0:
		fsm.state_nxt = fsm.states.idle
	
	obj.vel.x = lerp( obj.vel.x, 0, 10 * delta )
	obj.gravity( delta )
	obj.move_with_snap()


