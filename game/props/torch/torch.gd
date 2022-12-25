extends Area2D

var is_active := false
var id : String

#func _ready() -> void:
#	if Engine.editor_hint: return
#	id = Utils.get_unique_id( self )
#	if game.is_event( "savepoint_" + id ):
#		activate()

func _on_torch_body_entered( _body: Node ) -> void:
	if is_active: return
	game.state.worldpos = owner.get_worldpos( self )
	game.state.energy = game.state.max_energy
	var _ret = game.save_gamestate()
	activate()
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	x.position = $flamepos.position
	x.rotation = randf() * TAU
	x.modulate = Color( "21b6fb" )
	add_child( x )

func activate():
	is_active = true
	var _ret = game.add_event( "savepoint_" + id )
	$anim.play( "active" )
	$collision.call_deferred( "set_disabled", true )


func _on_activate_collision_timeout() -> void:
	$collision.disabled = false
