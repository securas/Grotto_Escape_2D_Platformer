extends StackedFSM_State
class_name EnemyBehavior_AirPatrol

var patrol_velocity := 50.0


func _run( delta : float ) -> void:
	obj.vel.x = patrol_velocity * obj.dir_cur
	obj.vel.y = 0.0
	var coldata = obj.move_and_collide( obj.vel * delta )
	if coldata:
		obj.dir_nxt *= -1
	
	_check_player()
	

# to override
func _check_player() -> void:
	return
	

	
