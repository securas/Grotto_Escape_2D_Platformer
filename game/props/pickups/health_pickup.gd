extends Area2D

onready var id = Utils.get_unique_id( self )

func _ready() -> void:
	if Engine.editor_hint: return
	if game.is_event( "pickup_" + id ):
		queue_free()
	var _ret = connect( "body_entered", self, "_on_health_pickup_body_entered", \
		[], CONNECT_DEFERRED + CONNECT_ONESHOT )

func _on_health_pickup_body_entered( _body: Node ) -> void:
	var _ret = game.add_event( "pickup_" + id )
	game.state.energy = game.state.max_energy
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	x.position = position + Vector2.UP * 6
	x.rotation = randf() * TAU
	x.modulate = Color( "1ede7b" )
	get_parent().add_child( x )
	queue_free()
