extends Node2D
class_name ExplodingBody

export( float ) var strength := 200.0

var parts := []
var parts_count := 0.0

func _ready() -> void:
	call_deferred( "_register_parts" )

func _register_parts() -> void:
	for c in get_children():
		if c is ExplodingBodyPart:
			parts.append( c )
			parts_count += 1.0
			c.connect( "tree_exited", self, "_on_part_tree_exited" )
	if not parts:
		queue_free()
		return
	else:
		call_deferred( "_set_parts" )

func _set_parts() -> void:
	var direction := Vector2.ONE.normalized()
	var diff_rot = PI / parts_count
	for p in parts:
		p.rotation = direction.angle()
		p.apply_central_impulse( direction * strength )
		direction = direction.rotated( diff_rot + randf() * 0.2 )

func _on_part_tree_exited():
#	print( "part free", parts_count )
	parts_count -= 1
	if parts_count == 0:
		queue_free()

