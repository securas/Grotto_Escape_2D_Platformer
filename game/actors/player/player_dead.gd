extends FSM_State


var dead_timer : float

func _initialize() -> void:
	anim.nxt( "dead" )
	dead_timer = 2.0

func _run( delta : float ) -> void:
	dead_timer -= delta
	if dead_timer <= 0:
		obj.set_physics_process( false )
		obj.emit_signal( "player_dead" )
	
#	obj.vel.x = lerp( obj.vel.x, 0, 10 * delta )
	obj.gravity( delta )
	var coldata = obj.move_and_collide( obj.vel * delta )
	if coldata:
		obj.vel = obj.vel.bounce( coldata.normal )
		obj.vel *= 0.5


