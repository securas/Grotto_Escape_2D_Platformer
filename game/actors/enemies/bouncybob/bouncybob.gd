extends Enemy

const PATROL_VEL = 60
const CHASE_VEL = 120

onready var fsm := StackedFSM.new( self, $states, $states/initiate, $anim, false )
onready var rotate := $rotate

func _ready():
	position_offset = Vector2.UP * 6
	$states/initiate.nxt_state = $states/patrol

func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )
	update_dir( rotate )
	
	# force attack
	_check_attack_player()
	
func _set_ground_vel( multiplier : float ) -> void:
	$states/patrol.patrol_velocity = PATROL_VEL * multiplier
	$states/chase.chase_velocity = CHASE_VEL * multiplier

func _on_receiving_damage( from, damage ):
	energy = int( max( energy - damage, 0 ) )
	var hit_dir : Vector2
	if from is Actor:
		hit_dir = from.vel.normalized()
	else:
		hit_dir = ( get_global_position_with_offset() - from.global_position ).normalized()
	if abs( hit_dir.x ) > 0:
		dir_nxt = -sign( hit_dir.x )
	vel.x = hit_dir.x * 200
	$rotate/enemy/flash_tween.start()
	if energy > 0:
		fsm.states.hit.begin()
		sigmgr.emit_signal( "camera_shake", 0.1, 60, 1 )
	else:
		sigmgr.emit_signal( "camera_shake", 0.2, 60, 3 )
		var ex = preload( "res://vfx/explosion_32px.tscn" ).instance()
		ex.position = get_global_position_with_offset()
		ex.rotation = TAU * randf()
		get_parent().add_child( ex )
		var x = preload( "res://props/exploding_enemy/exploding_enemy.tscn" ).instance()
		x. position = get_global_position_with_offset()
		x.main_color = Color( "dc7803" )
		x.second_color = Color( "904e00" )
		get_parent().call_deferred( "add_child", x )
		queue_free()



func _check_attack_player() -> void:
	if fsm.states.fire.can_attack_player():
		fsm.push( fsm.states.fire )
