tool
extends MapRoom

var spawn_state := -1
var enemy_counter := 0

func _ready() -> void:
	if game.is_event( "finished_level_12" ):
		$walls/gate/block_anim.play( "default" )
	else:
		if game.is_event( "started_level_12" ):
			$walls/gate/block_anim.play( "closed" )
#			$enemies/spawn_timer.wait_time = 2.0
#			$enemies/spawn_timer.start()
		else:
			$walls/gate/block_anim.play( "default" )

func _on_trigger_gate_body_entered( _body: Node ) -> void:
	if game.is_event( "finished_level_12_boss" ) or game.is_event( "started_level_12" ): return
	var _ret = game.add_event( "started_level_12" )
	game.state.worldpos = get_worldpos( $walls/restart_position )
	_ret = game.save_gamestate()
	yield( get_tree().create_timer( 0.1 ), "timeout" )
	$player.set_cutscene( true )
	$walls/gate/block_anim.play( "close" )
	yield( $walls/gate/block_anim, "animation_finished" )
	$player.set_cutscene( false )
#	$enemies/spawn_timer.wait_time = 2.0
#	$enemies/spawn_timer.start()
	



func _on_enemy_wave_finished() -> void:
	spawn_state += 1
	match spawn_state:
		0:
			_spawn_enemy( EnemyTypes.BOB, $enemies/spawn_position_1 )
		1:
			_spawn_enemy( EnemyTypes.SLIME, $enemies/spawn_position_2, -1 )
		2:
			_spawn_enemy( EnemyTypes.SLIME, $enemies/spawn_position_1 )
		3:
			_spawn_enemy( EnemyTypes.BOB, $enemies/spawn_position_2, -1 )
		4:
			_spawn_enemy( EnemyTypes.SLIME, $enemies/spawn_position_1 )
			_spawn_enemy( EnemyTypes.SLIME, $enemies/spawn_position_2, -1 )
		5:
			_spawn_enemy( EnemyTypes.BOB, $enemies/spawn_position_3 )
			_spawn_enemy( EnemyTypes.SLIME, $enemies/spawn_position_4 )
			_spawn_enemy( EnemyTypes.SLIME, $enemies/spawn_position_5, -1 )
			_spawn_enemy( EnemyTypes.BOB, $enemies/spawn_position_6, -1 )
		_:
			_finished_enemies()
enum EnemyTypes { BOB, SLIME }
func _spawn_enemy( enemy_type : int, pos : Position2D, dir : float = 1.0 ) -> void:
	var b : Node
	match enemy_type:
		EnemyTypes.BOB:
			b = preload( "res://actors/enemies/bouncybob/bouncybob.tscn" ).instance()
		EnemyTypes.SLIME:
			b = preload( "res://actors/enemies/slime/slime.tscn" ).instance()
	b.position = pos.position
	b.dir_nxt = dir
	var _ret = b.connect( "tree_exited", self, "_on_enemy_killed", \
				[], CONNECT_DEFERRED )
	$enemies.add_child( b )
	enemy_counter += 1
	b.fsm.states.initiate.nxt_state = b.fsm.states.pop
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	x.position = b.get_global_position_with_offset()
	x.rotation = TAU * randf()
	$enemies.add_child( x )

func _on_enemy_killed():
	enemy_counter -= 1
	if enemy_counter == 0:
		call_deferred( "_on_enemy_wave_finished" )


func _finished_enemies():
	var _ret = game.add_event( "finished_level_12" )
#	sigmgr.emit_signal( "camera_temporary_target", null )
#	game.state.worldpos = get_worldpos( $gunpos )
#	_ret = game.save_gamestate()
#	$player.set_cutscene()
#	yield( get_tree().create_timer( 1.5 ), "timeout" )
#	$walls/gate/block_anim.play( "open" )
#	yield( $walls/gate/block_anim, "animation_finished" )
#	$player.set_cutscene( false )
