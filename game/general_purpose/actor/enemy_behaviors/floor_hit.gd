extends StackedFSM_State
class_name EnemyBehavior_FloorHit

var hit_decel := 10
var hit_time := 0.5

var _hit_timer : float

func begin() -> void:
	_hit_timer = hit_time
	_disable_damage()
	if not is_current():
		fsm.push( self )


func _run( delta : float ) -> void:
	obj.vel.x = lerp( obj.vel.x, 0, hit_decel * delta )
	obj.gravity( delta )
	obj.move_with_snap()
	
	if obj.is_at_border( delta, true ):
		obj.vel *= 0
	
	_hit_timer -= delta
	if _hit_timer <= 0:
		fsm.pop()


func _terminate() -> void:
	_enable_damage()


func _enable_damage() -> void:
	pass

func _disable_damage() -> void:
	pass
