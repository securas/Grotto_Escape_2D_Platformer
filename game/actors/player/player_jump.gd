extends FSM_State

var jump_timer : float
var jump_finished : bool

func begin_jump():
	obj.jump_dust()
	
	obj.vel.y = -obj.JUMP_VEL
	obj.vel = obj.move_and_slide( obj.vel, Vector2.UP )
	
	fsm.state_nxt = fsm.states.jump
	if obj.is_firing:
		anim.nxt( "jump fire" )
	else:
		anim.nxt( "jump" )
	obj.anim_fx.play( "jump" )
	obj.anim_fx.queue( "default" )

func _initialize() -> void:
	jump_timer = obj.JUMP_TIME
	jump_finished = false


func _run( delta : float ) -> void:
	jump_timer -= delta
	if not jump_finished and ( not obj.control.is_jump or jump_timer <= 0 ):
		obj.vel.y *= 0.5
		jump_finished = true
	
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
	
	if obj.vel.y > 0:
		fsm.state_nxt = fsm.states.fall
		return
	
	
	
	if obj.is_on_floor():
		if abs( obj.vel.x ) > 10:
			fsm.state_nxt = fsm.states.run
		else:
			fsm.state_nxt = fsm.states.idle
