extends FSM_State

var down_timer : float
var on_floor : bool

func _initialize() -> void:
	anim.nxt( "idle" )
	obj.vel.x = 0
	down_timer = 0.0
	on_floor = true

func _run( delta : float ) -> void:
	obj.vel.x = 0
	
	
	
	obj.gravity( delta )
	if on_floor:
		obj.move_with_snap()
	else:
		obj.vel = obj.move_and_slide( obj.vel, Vector2.UP )
	
	on_floor = obj.is_on_floor()


