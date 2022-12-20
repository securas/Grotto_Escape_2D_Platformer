extends FSM_State

var down_timer : float

func _initialize() -> void:
	anim.nxt( "idle" )
	obj.vel.x = 0
	down_timer = 0.0

func _run( delta : float ) -> void:
	obj.vel.x = 0
	
	if obj.control.is_just_jump:
		fsm.states.jump.begin_jump()
		return
	
	if obj.control.is_just_attack and obj.can_fire():
		anim.nxt( "fire" )
		obj.fire()
	
	if obj.control.is_moving:
		fsm.state_nxt = fsm.states.run
		return
	
	obj.gravity( delta )
	obj.move_with_snap()
	
	if not obj.is_on_floor():
		fsm.state_nxt = fsm.states.fall
		return
	else:
		if obj.control.is_down:
			down_timer += delta
			if down_timer > 0.1:
				obj.position.y += 1
		else:
			down_timer = 0.0

