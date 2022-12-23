tool
extends MapRoom



func _on_check_player_body_entered( _body: Node ) -> void:
	$player.set_cutscene()
	$walls/giant_snake_bundle/snake_anim.play( "open" )
	yield( $walls/giant_snake_bundle/snake_anim, "animation_finished" )
	$player.set_cutscene( false )
