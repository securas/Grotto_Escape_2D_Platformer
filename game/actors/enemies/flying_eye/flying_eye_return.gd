extends EnemyBehavior_AirReturn

func _check_player() -> bool:
	return fsm.states.patrol._check_player()

func _initialize_return() -> void:
	anim.nxt( "walk" )
