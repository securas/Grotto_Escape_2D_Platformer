extends Pickup

func _item_picked() -> void:
	game.state.weapon_enabled = true
	var _ret = game.save_gamestate()
	var x = preload( "res://vfx/explosion_24px.tscn" ).instance()
	x.position = position + Vector2.UP * 6
	x.rotation = randf() * TAU
	x.modulate = Color( "f88926" )
	get_parent().add_child( x )
	pass


