extends StackedFSM_State

enum SubStates { CYCLE, ATTACK }
const MAX_VEL = 200
const MAX_FOR = 10
const STA_DIS = 32
const CYCLE_TIME = 2.0

var center_position : Vector2 = Vector2( 160, 90 )
var speed = 0.20
var attack_type : int = SmallBossHand.AttackTypes.DROP_DRAG
var second_hand : bool = true

var _state : int
var _t : float = 0.0
var _cycle_timer : float
var _finished_attack : bool
var _attack_hand : SmallBossHand
var _other_hand : SmallBossHand
var _attack_timer : float


func _initialize() -> void:
	anim.nxt( "RESET" )
#	_t = 0.0
	_state = SubStates.CYCLE
	_cycle_timer = CYCLE_TIME


func _run( delta ) -> void:
	match _state:
		SubStates.CYCLE:
			var target_position = center_position + \
				Vector2( 75 * sin( TAU * _t ), 35 * sin( 2.0 * TAU * _t ) )
			_t += delta * speed
			_t = _t - floor( _t )
			
			var dist : Vector2 = target_position - obj.position
			var desired_vel = dist.normalized() * MAX_VEL
			var distlen = dist.length()
			desired_vel *= 1.0 if distlen > STA_DIS else distlen / STA_DIS
			var force : Vector2 = ( desired_vel - obj.vel ).limit_length( MAX_FOR )
			obj.vel += force
			
			var _coldata = obj.move_and_collide( obj.vel * delta )
			
			_cycle_timer -= delta
			if _cycle_timer > 0: return
			
			var dist_right = obj.hand_right.v_dist_to_player()
			var dist_left = obj.hand_left.v_dist_to_player()
			
			if abs( dist_right ) < 8:
				_attack_hand = obj.hand_right
				_other_hand = obj.hand_left
				_begin_attack()
			elif abs( dist_left ) < 8:
				_attack_hand = obj.hand_left
				_other_hand = obj.hand_right
				_begin_attack()
				
		SubStates.ATTACK:
			obj.vel *= 0.90
			var _coldata = obj.move_and_collide( obj.vel * delta )
			_attack_timer -= delta
			if second_hand and _other_hand and _attack_timer < 1.0 - 0.5:
				_attack_timer = 1.0
				_other_hand.begin_attack( attack_type )
				_other_hand = null
			if _attack_timer <= 0:
				fsm.pop()

func _begin_attack():
	_state = SubStates.ATTACK
	_attack_timer = 1.0
	_attack_hand.begin_attack( attack_type )
