extends ExplodingBody

export( Color ) var main_color := Color.white
export( Color ) var second_color := Color.gray


func _ready() -> void:
	strength = 150
	for count in range( get_child_count() ):
		var p = get_child( count )
		if not p is ExplodingBodyPart: continue
		p.part_color = main_color if count < get_child_count() * 0.5 else second_color
		p.size = 1 + ( randi() % 3 )
		p.set_part()
		
