extends EnemyBehavior_AirChase

const CHASE_REACH = 160


# to override
func _check_player() -> bool:
	var target_in_sight = Utils.target_in_sight(
		obj,
		obj.get_global_position_with_offset(),
		game.player.get_global_position_with_offset(),
		CHASE_REACH,
		obj.dir_cur,
		1.5,
		[],
		1 + 2048
	)
	return target_in_sight

func _initialize_chase() -> void:
	anim.nxt( "walk" )

