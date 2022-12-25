tool
extends LDtkLevel
class_name MapRoom


signal change_level( worldpos, player_dir )
signal start_level

var player_dir := {}
var player_pos : Vector2
var is_boss_level := false
var player_can_leave := true
var world : LDtkWorldData

func _ready() -> void:
#	print( "starting ", name )
	if Engine.editor_hint:
		set_physics_process( false )
		return
	
	if not _level: return
	
	var _ret = connect( "player_leaving_level", self, "_on_player_leaving" )
	if player_dir:
		$player.set_initial_dir( player_dir )
		$player.position = player_pos - _level.rect.position
	_ret = $player.connect( "player_dead", self, "_on_player_dead" )
	_ret = $player.connect( "deadly_impact", self, "_on_deadly_impact" )
	
	$player/camera.limit_left = 0
	$player/camera.limit_right = _level.rect.size.x
	$player/camera.limit_top = 0
	$player/camera.limit_bottom = _level.rect.size.y
	
#	_setup_dust_particles()
	
	_ret = $fadelayer.connect( "finished", self, "_on_fadelayer_finished", [], CONNECT_ONESHOT )
	$fadelayer.instant_fadeout()
	$fadelayer.call_deferred( "fadein" )
	
	
	


#func _setup_dust_particles():
#	$dust_particles.position = _level.rect.size * Vector2( 1, 0.5 )
#	var area_ratio = _level.rect.size.x * _level.rect.size.y / ( 256 * 256 )
#	$dust_particles.amount = int( clamp( 24 * area_ratio, 0, 240 ) )
#	$dust_particles.lifetime = clamp( 12 * _level.rect.size.x / 256, 0, 32 )
#	$dust_particles.emission_rect_extents.y = 128 * _level.rect.size.x / 256


func _on_fadelayer_finished():
	emit_signal( "start_level" )


func _on_player_leaving( worldpos : Vector2 ):
	if not player_can_leave: return
	var nxt_level = world.get_level_at( worldpos )
	if not nxt_level: return
#	game.state.just_died = false
	$fadelayer.fadeout()
	yield( $fadelayer, "finished" )
	emit_signal( "change_level", worldpos, $player.get_dir() )


func _on_player_dead():
	$fadelayer.fadeout()
	yield( $fadelayer, "finished" )
	var _ret = game.load_gamestate()
#	game.state.just_died = true
	sigmgr.emit_signal( "load_gamestate" )

func _on_deadly_impact():
	player_can_leave = false
	$background/flash_tween.start( 0.2, 2 )


func shake( duration : float, frequency : float, intensity : float ):
	sigmgr.emit_signal( "camera_shake", duration, frequency, intensity )


func create_save():
	if is_boss_level: return
#	var level_rect = _level.rect
#	var worldpos = level_rect.position + $player.global_position
#	game.state.worldpos = [ worldpos.x, worldpos.y ]
#	game.backup_gamestate()

