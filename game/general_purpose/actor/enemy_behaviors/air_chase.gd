extends StackedFSM_State
class_name EnemyBehavior_AirChase


var chase_velocity := 50.0
var chase_quit_time := 1.0
var chase_wait_time := 1.0
var chase_update_dir_time := 0.25

var _quit_timer : float
var _wait_timer : float
var _update_dir_timer : float
var _state : int

func _initialize() -> void:
	_quit_timer = chase_quit_time
	_update_dir_timer = 0.0
	_initialize_chase()

func _run( delta : float ) -> void:
	var dist = game.player.get_global_position_with_offset() - obj.get_global_position_with_offset()
	if abs( dist.x ) > 0: obj.dir_nxt = sign( dist.x )
	if _check_player():
		var desired_vel = dist.normalized() * chase_velocity
		var force = desired_vel - obj.vel
		obj.vel += force * delta
		obj.vel = obj.vel.limit_length( chase_velocity )
		_quit_timer = 0.0
	else:
		_quit_timer += delta
		if _quit_timer >= chase_quit_time:
			fsm.pop()
	
	var coldata = obj.move_and_collide( obj.vel * delta )
	if coldata:
		obj.vel = obj.vel.bounce( coldata.normal )


# to override
func _check_player() -> bool:
	return false

func _initialize_chase() -> void:
	pass
