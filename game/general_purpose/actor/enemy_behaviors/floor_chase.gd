extends StackedFSM_State
class_name EnemyBehavior_FloorChase

enum ChaseStates { CHASE, WAIT }

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
	_state = ChaseStates.CHASE
	_initialize_chase()


func _run( delta : float ) -> void:
	match _state:
		ChaseStates.CHASE:
			if obj.is_at_border( delta ):
				_state = ChaseStates.WAIT
				obj.vel.x = 0
				_wait_timer = chase_wait_time
				obj.position = obj.position.round()
				_initialize_wait()
				return
			
			obj.vel.x = chase_velocity * obj.dir_cur
			obj.gravity( delta )
			obj.move_with_snap()
			
			
			
			
			if _check_player():
				_quit_timer = chase_quit_time
			else:
				_quit_timer -= delta
				if _quit_timer <= 0:
					_state = ChaseStates.WAIT
					obj.vel.x = 0
					_wait_timer = chase_wait_time
					obj.position = obj.position.round()
					_initialize_wait()
					return
			
			var player_dist = game.player.get_global_position_with_offset() - obj.get_global_position_with_offset()
			if sign( player_dist.x ) == obj.dir_cur:
				_update_dir_timer = 0.0
			else:
				_update_dir_timer += delta
				if _update_dir_timer >= chase_update_dir_time:
					obj.dir_nxt *= -1
			
			
		
		ChaseStates.WAIT:
			if _check_player():
				_initialize_chase()
				_state = ChaseStates.CHASE
				return
			_wait_timer -= delta
			if _wait_timer <= 0:
				obj.dir_nxt *= -1
				fsm.pop()
			
			var player_dist = game.player.get_global_position_with_offset() - obj.get_global_position_with_offset()
			if sign( player_dist.x ) == obj.dir_cur:
				_update_dir_timer = 0.0
			else:
				_update_dir_timer += delta
				if _update_dir_timer >= chase_update_dir_time:
					obj.dir_nxt *= -1




# to override
func _check_player() -> bool:
	return false

func _initialize_wait() -> void:
	pass

func _initialize_chase() -> void:
	pass
