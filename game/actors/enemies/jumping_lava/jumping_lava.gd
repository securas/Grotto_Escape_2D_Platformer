extends Enemy

export( float ) var height : float = 64.0
export( float ) var wait_time : float = 0.0

var _v_init : float
var _initial_pos : float
var _timer : float


func _ready() -> void:
	# required initial velocity
	_v_init = sqrt( height * 2 * GRAVITY * 0.1 )
	_initial_pos = position.y
	_timer = wait_time

func _begin_jump():
	vel.y = -_v_init

func _physics_process(delta: float) -> void:
	if _timer > 0:
		_timer -= delta
		return 
	vel.y += GRAVITY * delta * 0.1
	var _coldata = move_and_collide( vel * delta )
	if abs( vel.y ) > 0:
		$bullet.scale.x = -sign( vel.y )
	if position.y > _initial_pos:
		position.y = _initial_pos
		_begin_jump()

