extends Actor

const VEL = 90
var dir := 1


func _ready() -> void:
	vel = Vector2.RIGHT * dir * VEL
	$bullet.scale.x = float( dir )
	
func _physics_process( delta: float ) -> void:
	var coldata = move_and_collide( vel * delta )
	if coldata:
		sigmgr.emit_signal( "camera_shake", 0.1, 60, 1 )
		var x = preload( "res://vfx/explosion_16px.tscn" ).instance()
		x.position = coldata.position
		x.rotation = TAU * randf()
		get_parent().add_child( x )
		queue_free()
	if not Utils.on_screen( self, 16 ):
		queue_free()


func _on_dealing_damage( to ):
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	if to is Actor:
		x.position = ( to.get_global_position_with_offset() + position ) * 0.5
	else:
		x.position = ( to.position + position ) * 0.5
	x.rotation = TAU * randf()
	get_parent().add_child( x )
	queue_free()
