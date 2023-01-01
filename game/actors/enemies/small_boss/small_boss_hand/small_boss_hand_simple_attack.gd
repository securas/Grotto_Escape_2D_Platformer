extends StackedFSM_State

const ACCEL = 1000
const FLOOR_COORDINATE = 176

var dropping_hand : bool
var drop_timer : float

func _initialize() -> void:
	obj.vel = Vector2( 0, -200 )
	dropping_hand = true
	drop_timer = 1.0
	anim.nxt( "default" )

func _run( delta ) -> void:
	if dropping_hand:
		obj.vel.y += ACCEL * delta
		var _coldate = obj.move_and_collide( obj.vel * delta )
		
		if obj.position.y > FLOOR_COORDINATE:
			obj.position.y = FLOOR_COORDINATE
			dropping_hand = false
			obj.vel *= 0
			_hit_vfx()
	else:
		drop_timer -= delta
		if drop_timer <= 0:
			obj.emit_signal( "finished_attack" )
			fsm.pop()

func _hit_vfx() -> void:
	obj.anim_fx.play( "land" )
	obj.anim_fx.queue( "default" )
	sigmgr.emit_signal( "camera_shake", 0.1, 60, 2 )
	var d = preload( "res://actors/player/vfx/run_dust.tscn" ).instance()
	d.position = obj.get_node( "rotate/dust_pos_right" ).global_position
	d.scale.x = -obj.rotate.scale.x
	obj.get_parent().get_parent().add_child( d )
	d = preload( "res://actors/player/vfx/run_dust.tscn" ).instance()
	d.position = obj.get_node( "rotate/dust_pos_left" ).global_position
	d.scale.x = obj.rotate.scale.x
	obj.get_parent().get_parent().add_child( d )
