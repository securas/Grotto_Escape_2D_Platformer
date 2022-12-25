extends StackedFSM_State
class_name EnemyBehavior_AirHit

var hit_decel := 10
var hit_time := 0.5

var _hit_timer : float

func begin() -> void:
	_hit_timer = hit_time
	_disable_damage()
	if not is_current():
		fsm.push( self )


func _run( delta : float ) -> void:
	obj.vel = lerp( obj.vel, Vector2.ZERO, hit_decel * delta )
	var coldata = obj.move_and_collide( obj.vel * delta )
	if coldata:
		obj.vel = obj.vel.bounce( coldata.normal )
#	if abs( obj.vel.x ) > 0: obj.dir_nxt = sign( obj.vel.x )
	
	_hit_timer -= delta
	if _hit_timer <= 0:
		fsm.pop()


func _terminate() -> void:
	_enable_damage()


func _enable_damage() -> void:
	pass

func _disable_damage() -> void:
	pass
