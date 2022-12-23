extends StackedFSM_State

var FIRE_INTERVAL = 1.0

var fire_timer : float

func _initialize() -> void:
	fire_timer = FIRE_INTERVAL
	anim.nxt( "fire" )
	
	var b = preload( "res://actors/enemies/bouncybob_bullet/bouncybob_bullet.tscn" ).instance()
	b.dir = obj.dir_cur
	b.position = obj.get_node( "rotate/firepos" ).global_position # not good to mix
	obj.get_parent().add_child( b )

func _run( delta : float ) -> void:
	fire_timer -= delta
	if fire_timer <= 0:
		if can_attack_player():
			_initialize()
		else:
			fsm.pop()


func can_attack_player() -> bool:
	if fsm.is_state( fsm.states.patrol ) or fsm.is_state( fsm.states.chase ):
		var target_in_sight = Utils.target_in_sight(
			obj,
			obj.get_global_position_with_offset(),
			game.player.get_global_position_with_offset(),
			64,
			obj.dir_cur,
			0.1,
			[],
			1
		)
		return target_in_sight
	return false

