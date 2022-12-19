extends FSM_State

func _initialize() -> void:
	anim.nxt( "run" )

func _run( delta : float ) -> void:
	if obj.control.is_just_jump:
		fsm.states.jump.begin_jump()
		return
	
	if obj.control.is_just_attack and obj.can_fire():
		anim.nxt( "run_fire" )
		obj.fire()
	
	if obj.control.is_moving:
		obj.vel.x = obj.control.dir * obj.FLOOR_VEL
		obj.dir_nxt = obj.control.dir
	else:
		fsm.state_nxt = fsm.states.idle
		return
	
	obj.gravity( delta )
	obj.move_with_snap()
	
	if not obj.is_on_floor():
		fsm.state_nxt = fsm.states.fall
		return
