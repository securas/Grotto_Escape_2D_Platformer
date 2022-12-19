extends Particles2D


func _ready() -> void:
	call_deferred( "_set_position" )


func _set_position() -> void:
	var parent = get_parent()
	if not parent is LDtkLevel: return
	var level_rect = parent._level.rect
	position = Vector2( level_rect.size.x, level_rect.size.y * 0.5 );
#	print( "particle position: ", position )
	process_material.set_shader_param( "vextent", level_rect.size.y * 0.7 )
	var ref_area = 320 * 180 * 2
	var level_area = level_rect.size.x * level_rect.size.y
	amount = int( 40 * level_area / ref_area )
	lifetime = 30 * level_rect.size.x / 320.0
	
	$back_particles.process_material.set_shader_param( "vextent", level_rect.size.y * 0.7 )
	$back_particles.amount = int( 40 * level_area / ref_area )
	$back_particles.lifetime = 30 * level_rect.size.x / 320.0
