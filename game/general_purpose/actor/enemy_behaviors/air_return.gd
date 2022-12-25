extends StackedFSM_State
class_name EnemyBehavior_AirReturn

var return_velocity := 30.0

var _starting_position : Vector2
var _starting_direction : float

func _ready() -> void:
	call_deferred( "_set_starting_position" )

func _set_starting_position() -> void:
	_starting_direction = obj.dir_nxt
	_starting_position = obj.get_global_position_with_offset()


var _quit_timer : float
var _wait_timer : float
var _update_dir_timer : float
var _state : int

func _initialize() -> void:
	_initialize_return()

func _run( delta : float ) -> void:
	if _check_player():
		obj.vel *= 0.0
	else:
		var dist = _starting_position - obj.get_global_position_with_offset()
		if dist.length() < 2:
			obj.position = obj.get_global_position_with_offset() - obj.position_offset
			fsm.pop()
			return
		var desired_vel = dist.normalized() * return_velocity
		var force = desired_vel - obj.vel
		obj.vel += force * delta
		obj.vel = obj.vel.limit_length( return_velocity )
		if abs( obj.vel.x ) > 0: obj.dir_nxt = sign( obj.vel.x )
	
	var coldata = obj.move_and_collide( obj.vel * delta )
	if coldata:
		obj.vel = obj.vel.bounce( coldata.normal )
	


# to override
func _check_player() -> bool:
	return false

func _initialize_return() -> void:
	pass
