extends Enemy
class_name LavaBossProjectile

const GRAV = 100

var scalar_vel : float = 100.0
var flight_time : float

func _ready() -> void:
	vel = Vector2( 1, -1 ).normalized() * scalar_vel

func _physics_process( delta: float ) -> void:
	delta *= 0.7
	vel.y += GRAV * delta
	var coldata = move_and_collide( vel * delta )
	flight_time += delta
	if coldata:
		sigmgr.emit_signal( "camera_shake", 0.1, 60, 1 )
		var x = preload( "res://vfx/explosion_16px.tscn" ).instance()
		x.position = coldata.position
		x.rotation = TAU * randf()
		get_parent().add_child( x )
		_terminate()
#		print( "Hit Point: ", coldata.position.x, " ", flight_time )


func _on_dealing_damage( to ):
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	if to is Actor:
		x.position = ( to.get_global_position_with_offset() + position ) * 0.5
	else:
		x.position = ( to.position + position ) * 0.5
	x.rotation = TAU * randf()
	get_parent().add_child( x )
	_terminate()

func _terminate():
	set_physics_process( false )
	$collision.disabled = true
	$projectile.hide()
	$particles.emitting = false
	$end_timer.start()


func _on_end_timer_timeout() -> void:
	queue_free()
