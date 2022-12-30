extends StackedFSM_State

enum SubStates { HIT, WAIT }

const ACCEL = 1000
const WALL_COORDINATE = 112

var wait_timer : float
var state : int
var target_coordinate : float


func _initialize() -> void:
	obj.vel = Vector2( -200, 0 ) * obj.rotate.scale.x
	wait_timer = 2.0
	state = SubStates.HIT
	target_coordinate = 160 + WALL_COORDINATE * obj.rotate.scale.x - \
		12 * obj.rotate.scale.x

func _run( delta ) -> void:
	match state:
		SubStates.HIT:
			obj.vel.x += ACCEL * delta * obj.rotate.scale.x
			var _coldata = obj.move_and_collide( obj.vel * delta )
			
			if ( obj.rotate.scale.x > 0 and obj.position.x > target_coordinate ) or \
				( obj.rotate.scale.x < 0 and obj.position.x < target_coordinate ):
				obj.position.x = target_coordinate
				_hit_vfx()
				obj.vel *= 0
				state = SubStates.WAIT
		SubStates.WAIT:
			wait_timer -= delta
			if wait_timer <= 0:
				obj.vel *= 0
				fsm.pop()

func _hit_vfx() -> void:
#	obj.anim_fx.play( "land" )
#	obj.anim_fx.queue( "default" )
	sigmgr.emit_signal( "camera_shake", 0.1, 60, 2 )
	var p = preload( "res://actors/enemies/small_boss/ceiling_particles.tscn" ).instance()
	p.position = Vector2( obj.position.x, 32 )
	obj.get_parent().get_parent().add_child( p )
#	var d = preload( "res://actors/player/vfx/run_dust.tscn" ).instance()
#	d.position = obj.get_node( "rotate/dust_pos_right" ).global_position
#	d.scale.x = -obj.rotate.scale.x
#	obj.get_parent().get_parent().add_child( d )
#	d = preload( "res://actors/player/vfx/run_dust.tscn" ).instance()
#	d.position = obj.get_node( "rotate/dust_pos_left" ).global_position
#	d.scale.x = obj.rotate.scale.x
#	obj.get_parent().get_parent().add_child( d )


