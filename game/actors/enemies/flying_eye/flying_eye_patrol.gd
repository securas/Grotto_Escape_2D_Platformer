extends EnemyBehavior_AirPatrol

const PATROL_REACH = 160

func _initialize() -> void:
	._initialize()
	anim.nxt( "walk" )

func _check_player() -> void:
	var target_in_sight = Utils.target_in_sight(
		obj,
		obj.get_global_position_with_offset(),
		game.player.get_global_position_with_offset(),
		PATROL_REACH,
		obj.dir_cur,
		1.0,
		[],
		1 + 2048
	)
	
	if target_in_sight:
		fsm.push( fsm.states.return )
		fsm.push( fsm.states.chase )
	
	

