extends AnimationPlayer
class_name RandomAnimation

# selects a random animation from the set of animations and plays it
func _ready() -> void:
	var animations = get_animation_list()
	var pos = animations.find( "RESET" )
	if pos >= 0:
		animations.remove( pos )
	play( animations[ randi() % animations.size() ] )
