extends Actor

# warning-ignore:unused_signal
signal player_dead
# warning-ignore:unused_signal
signal deadly_impact

const FLOOR_VEL = 70
const AIR_VEL = 80
const AIR_ACCEL = 5
const AIR_DECEL = 2
const JUMP_VEL = 250
const COYOTE_TIME = 0.15
const JUMP_TIME = 0.25


onready var fsm = FSM.new( self, $states, $states/idle, $anim, false )
onready var control = PlayerControl.new()
onready var rotate = $rotate
onready var anim_fx = $anim_fx
var is_firing := false
var fire_timer := 0.0
var is_invulnerable := false
var invulnerable_timer : float

func _ready() -> void:
	game.player = self
	position_offset = Vector2.UP * 7

func get_dir() -> Dictionary:
	return {
		"direction" : dir_cur,
		"velocity" : vel
	}

func set_initial_dir( dir_dic : Dictionary ) -> void:
	dir_nxt = dir_dic.direction
	vel = dir_dic.velocity

func _physics_process( delta: float ) -> void:
	control.update_input( delta )
	fsm.run_machine( delta )
	update_dir( rotate )
	
	if is_firing:
		fire_timer -= delta
		if fire_timer <= 0.0:
			is_firing = false
	
	if invulnerable_timer > 0:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false
	
	game.state.weapon_temperature = max( \
		game.state.weapon_temperature - game.state.weapon_cooldown_rate * delta,
		0.0 )

func set_cutscene( a : bool = true, nxt_state : FSM_State = null ):
	if a:
		fsm.state_nxt = fsm.states.cutscene
	else:
		fsm.state_nxt = fsm.states.idle if not nxt_state else nxt_state

func move_with_snap() -> void:
	vel = move_and_slide_with_snap( vel, Vector2.DOWN * 8, Vector2.UP, true )

func can_fire() -> bool:
	if is_firing or not game.state.weapon_enabled: return false
	if game.state.weapon_temperature >= ( game.state.weapon_max_temperature - 1 ):
		return false
	return true

func fire() -> void:
	is_firing = true
	fire_timer = 0.1
	game.state.weapon_temperature = \
		min( game.state.weapon_temperature + 1, game.state.weapon_max_temperature )
	var b = preload( "res://actors/player_bullet/player_bullet.tscn" ).instance()
	b.position = position + $rotate/firepos.position * Vector2( dir_cur, 1 )
	b.dir = dir_cur
	get_parent().add_child( b )
	var x = preload( "res://actors/player/gun_flare.tscn" ).instance()
	$rotate/firepos.add_child( x )
	

func _on_receiving_damage( from, damage ) -> void:
	if fsm.states.hit.is_current() or \
		fsm.states.dead.is_current() or \
		is_invulnerable: return
	game.state.energy = int( max( game.state.energy - damage, 0 ) )
	var hit_dir : Vector2
	if from is Actor:
		hit_dir = ( get_global_position_with_offset() - from.get_global_position_with_offset() ).normalized()
	else:
		hit_dir = ( get_global_position_with_offset() - from.global_position ).normalized()
	
	$rotate/player/flash_tween.start( 0.5 )
	
	if game.state.energy > 0:
		sigmgr.emit_signal( "camera_shake", 0.2, 60, 2 )
		vel = hit_dir * 200
		fsm.state_nxt = fsm.states.hit
		is_invulnerable = true
		invulnerable_timer = 0.5
	else:
		sigmgr.emit_signal( "camera_shake", 0.3, 60, 4 )
		vel = hit_dir * 100
		vel.y = -JUMP_VEL * 0.4
		fsm.state_nxt = fsm.states.dead
		is_invulnerable = true
		invulnerable_timer = -0.5
		emit_signal( "deadly_impact" )


func _on_death_area_body_entered( _body: Node ) -> void:
	if fsm.states.hit.is_current() or \
		fsm.states.dead.is_current() or \
		is_invulnerable: return
	sigmgr.emit_signal( "camera_shake", 0.3, 60, 4 )
	vel.x = 0
	vel.y = -JUMP_VEL * 0.4
	fsm.state_nxt = fsm.states.dead
	is_invulnerable = true
	invulnerable_timer = -0.5
	emit_signal( "deadly_impact" )
	


func _dust( scn : PackedScene ) -> void:
	var d = scn.instance()
	d.scale.x = dir_cur
	d.position = position
	get_parent().add_child( d )

func run_dust() -> void:
	_dust( preload( "res://actors/player/vfx/run_dust.tscn" ) )

func jump_dust() -> void:
	if abs( vel.x ) > 10:
		_dust( preload( "res://actors/player/vfx/jump_side_dust.tscn" ) )
	else:
		_dust( preload( "res://actors/player/vfx/jump_dust.tscn" ) )

func land_dust() -> void:
	_dust( preload( "res://actors/player/vfx/land_dust.tscn" ) )









