extends AnimationPlayer
class_name FSM_Anim


func cur() -> String:
	return current_animation

func nxt( anim_name, restart : bool = false, seek_position : float = 0.0 ) -> void:
	if restart:
		play( anim_name )
		seek( seek_position )
	else:
		if current_animation != anim_name:
			play( anim_name )
			advance(0)
			seek( seek_position )

func queue( anim_name ) -> void:
	.queue( anim_name )


