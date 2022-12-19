extends Area2D

func _ready() -> void:
	var id = Utils.get_unique_id( self )
	if not game.add_event( "pickup_" + id ):
		queue_free()

func _on_health_pickup_body_entered( _body: Node ) -> void:
	game.state.energy = game.state.max_energy
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	x.position = position + Vector2.UP * 6
	x.rotation = randf() * TAU
	x.modulate = Color( "1ede7b" )
	get_parent().add_child( x )
	queue_free()
