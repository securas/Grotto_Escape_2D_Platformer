extends ExplodingBody

export( Color ) var main_color := Color( "21b6fb" )
export( Color ) var second_color := Color( "056592" )


func _ready() -> void:
	strength = 20
	for count in range( get_child_count() ):
		var p = get_child( count )
		if not p is ExplodingBodyPart: continue
		p.position_margin = 150
		p.checktimer = 2.0
		p.part_color = main_color if count < get_child_count() * 0.5 else second_color
		p.size = 1 + ( randi() % 2 )
		p.set_part()
		p.position = Vector2.RIGHT * rand_range( -11, 11 )
		p.get_node( "particles" ).hide()
