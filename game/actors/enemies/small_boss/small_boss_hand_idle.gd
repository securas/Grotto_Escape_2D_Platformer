extends StackedFSM_State

const MAX_VEL = 200
const MAX_FOR = 10
const STA_DIS = 32

var attack_timer : float


func _initialize() -> void:
	attack_timer = 2.0

func _run( delta : float ) -> void:
	var dist : Vector2 = ( obj.parent.global_position + obj.idle_position ) - obj.global_position
	var desired_vel = dist.normalized() * MAX_VEL
	var distlen = dist.length()
	desired_vel *= 1.0 if distlen > STA_DIS else distlen / STA_DIS
	var force : Vector2 = ( desired_vel - obj.vel ).limit_length( MAX_FOR )
	obj.vel += force
	
	var _coldata = obj.move_and_collide( obj.vel * delta )
	
	
	attack_timer -= delta
	if attack_timer <= 0:
#		if obj.rotate.scale.x < 0:
#			fsm.push( fsm.states.hit_wall )
		fsm.push( fsm.states.hit_wall )

