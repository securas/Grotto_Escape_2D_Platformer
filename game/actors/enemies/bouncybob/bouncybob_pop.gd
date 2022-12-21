extends StackedFSM_State


var nxt_state : StackedFSM_State

var _col_counter : int
func _initialize():
	anim.nxt( "walk" )
	_col_counter = 0

func _run( delta : float ) -> void:
	obj.gravity( delta )
	var coldata = obj.move_and_collide( obj.vel * delta )
	if coldata:
		_col_counter += 1
		if _col_counter > 2:
			fsm.pop()
			fsm.push( fsm.states.patrol )
			return
		obj.vel = obj.vel.bounce( coldata.normal ) * 0.5
		coldata = obj.move_and_collide( obj.vel * delta )
		
	
