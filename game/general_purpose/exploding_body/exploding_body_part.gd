extends RigidBody2D
class_name ExplodingBodyPart

signal settled

var checktimer := 0.5
var buflen := 120
var position_margin := 20#2.5

var position_buffer := []
var bufidx := 0
var position_buffer_avg := Vector2.ZERO

func _ready():
	for _c in range( buflen ):
		position_buffer.append( position )
	position_buffer_avg = position
	contacts_reported = 2
	contact_monitor = true

func _process(delta):
	position_buffer_avg -= position_buffer[ bufidx ] / float( buflen )
	position_buffer[ bufidx ] = position
	position_buffer_avg += position_buffer[ bufidx ] / float( buflen )
	bufidx = ( bufidx + 1 ) % buflen
	if checktimer >= 0:
		checktimer -= delta
		return
	var found_walls = false
	for b in get_colliding_bodies():
		if b.get_collision_layer_bit(0):
			found_walls = true
	if not found_walls: return
	if position.distance_squared_to( position_buffer_avg ) < position_margin:
		emit_signal( "settled" )
		set_process( false )


