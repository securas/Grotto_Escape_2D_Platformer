tool
extends MapRoom

func _ready() -> void:
	if game.is_event( "finished_level_12_boss" ):
		$walls/gate/block_anim.play( "default" )
	else:
		if game.is_event( "started_level_12_boss" ):
			$walls/gate/block_anim.play( "closed" )
		else:
			$walls/gate/block_anim.play( "default" )

func _on_trigger_gate_body_entered( _body: Node ) -> void:
	if game.is_event( "finished_level_12_boss" ) or game.is_event( "started_level_12_boss" ): return
	var _ret = game.add_event( "started_level_12_boss" )
	game.state.worldpos = get_worldpos( $walls/restart_position )
	_ret = game.save_gamestate()
	yield( get_tree().create_timer( 0.1 ), "timeout" )
	$player.set_cutscene( true )
	$walls/gate/block_anim.play( "close" )
	yield( $walls/gate/block_anim, "animation_finished" )
	$player.set_cutscene( false )
