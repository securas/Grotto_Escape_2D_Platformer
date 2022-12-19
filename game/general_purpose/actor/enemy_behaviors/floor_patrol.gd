extends StackedFSM_State
class_name EnemyBehavior_FloorPatrol

var patrol_velocity := 50.0


func _run( delta : float ) -> void:
	if obj.is_at_border( delta ):
		obj.dir_nxt *= -1
	
	obj.vel.x = patrol_velocity * obj.dir_cur
	obj.gravity( delta )
	obj.move_with_snap()
	
	
	
	_check_player()
	

# to override
func _check_player() -> void:
	return
	

	
