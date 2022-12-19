extends FSM_State


func _initialize() -> void:
	anim.nxt( "idle" )
	obj.vel.x = 0

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

