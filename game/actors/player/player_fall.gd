extends FSM_State

var coyote_timer : float
var jump_buffer : float

func _initialize() -> void:
	if obj.is_firing:
		anim.nxt( "jump fire" )
	else:
		anim.nxt( "fall" )
	coyote_timer = 0.0 if fsm.state_lst == fsm.states.jump else obj.COYOTE_TIME
	jump_buffer = 0.0

func _run( delta : float ) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta
		if obj.control.is_just_jump:
			fsm.states.jump.begin_jump()
			return
	
	if obj.control.is_just_attack and obj.can_fire():
		anim.nxt( "jump fire" )
		obj.fire()
	
	if obj.control.is_moving:
		obj.vel.x = lerp( obj.vel.x, obj.control.dir * obj.AIR_VEL, obj.AIR_ACCEL * delta )
		obj.dir_nxt = obj.control.dir
	else:
		obj.vel.x = lerp( obj.vel.x, 0, obj.AIR_DECEL * delta )
	
	obj.gravity( delta )
	obj.vel = obj.move_and_slide( obj.vel, Vector2.UP )
	
	
	jump_buffer -= delta
	if obj.control.is_just_jump:
		jump_buffer = 0.1
		
	if obj.is_on_floor():
		obj.land_dust()
		if jump_buffer > 0:
			fsm.states.jump.begin_jump()
			return
		obj.anim_fx.play( "land" )
		obj.anim_fx.queue( "default" )
		if abs( obj.vel.x ) > 10:
			fsm.state_nxt = fsm.states.run
		else:
			fsm.state_nxt = fsm.states.idle
	

