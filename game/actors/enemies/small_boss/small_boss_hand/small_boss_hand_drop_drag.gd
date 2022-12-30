extends StackedFSM_State

enum SubStates { DROP, DRAG, WAIT }

const ACCEL = 1000
const FLOOR_COORDINATE = 176
const DRAG_ACCEL = 800
const DRAG_TIME = 0.5

var drop_timer : float
var drag_timer : float
var state : int
var drag_dust_timer : float

func _initialize() -> void:
	obj.vel = Vector2( 0, -200 )
	drop_timer = 2.0
	drag_timer = DRAG_TIME
	state = SubStates.DROP
	drag_dust_timer = 0.0

func _run( delta ) -> void:
	match state:
		SubStates.DROP:
			obj.vel.y += ACCEL * delta
			var _coldata = obj.move_and_collide( obj.vel * delta )
			
			if obj.position.y > FLOOR_COORDINATE:
				obj.position.y = FLOOR_COORDINATE
				obj.vel = Vector2( 50, 0 ) * obj.rotate.scale.x 
				_hit_vfx()
				state = SubStates.DRAG
		SubStates.DRAG:
			obj.vel += -Vector2.RIGHT * obj.rotate.scale.x * DRAG_ACCEL * delta
			var _coldata = obj.move_and_collide( obj.vel * delta )
			drag_timer -= delta
			_drag_vfx( delta )
			if drag_timer <= 0:
				state = SubStates.WAIT
				obj.get_node( "rotate/hand_right" ).position *= 0
		SubStates.WAIT:
			obj.vel.x = lerp( obj.vel.x, 0, 15 * delta )
			var _coldata = obj.move_and_collide( obj.vel * delta )
			if abs( obj.vel.x ) > 5:
				_drag_vfx( delta )
			drop_timer -= delta
			if drop_timer <= 0:
				obj.vel *= 0
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

func _drag_vfx( delta : float ) -> void:
	obj.get_node( "rotate/hand_right" ).position = randf() * Vector2.RIGHT.rotated( TAU * randf() )
	drag_dust_timer -= delta
	if drag_dust_timer <= 0:
		drag_dust_timer = 0.05
		var d = preload( "res://actors/player/vfx/run_dust.tscn" ).instance()
		d.position = obj.get_node( "rotate/dust_pos_right" ).global_position
		d.scale.x = -obj.rotate.scale.x
		obj.get_parent().get_parent().add_child( d )
