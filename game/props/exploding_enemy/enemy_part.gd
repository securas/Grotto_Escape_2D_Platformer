extends ExplodingBodyPart

var part_color := Color.white
var size := 1

#var debug := true
#var pdebug : Sprite


#func _ready() -> void:
#	if debug:
#		pdebug = Sprite.new()
#		pdebug.texture = $pixel.texture
#		pdebug.modulate = Color.red
#		pdebug.z_index = 100
#		get_parent().call_deferred( "add_child", pdebug )

#func _physics_process(_delta: float) -> void:
#	pdebug.position = position_buffer_avg

func set_part() -> void:
	$pixel.modulate = part_color
	$pixel.scale = Vector2.ONE * size
	$pixel.position = -Vector2.ONE * size * 0.5
	$collision.shape.radius = ( size - 1 ) * 0.5


func _on_enemy_part_settled() -> void:
	var n = Node2D.new()
	n.position = ( get_parent().position + position ).round()
	n.rotation = rotation
	get_parent().get_parent().add_child( n )
	var p = $pixel.duplicate( true )
	n.add_child( p )
	$particles.emitting = false
	$pixel.hide()
	$end_timer.start()


func _on_end_timer_timeout() -> void:
	queue_free()
