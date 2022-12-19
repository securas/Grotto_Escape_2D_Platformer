extends KinematicBody2D
class_name Actor

const GRAVITY = 800
const TERM_VEL = 160


export( Vector2 ) var position_offset : Vector2
export( float ) var dir_nxt : float = 1.0

#var global_position_with_offset : Vector2 setget _set_global_position_with_offset, _get_global_position_with_offset
var vel : Vector2
var dir_cur := 1.0


#func _set_global_position_with_offset( v: Vector2 ) -> void:
#	global_position_with_offset = v
#	global_position = global_position_with_offset - position_offset
#
#func _get_global_position_with_offset() -> Vector2:
#	global_position_with_offset = global_position + position_offset
#	return global_position_with_offset

func get_global_position_with_offset() -> Vector2:
	return global_position + position_offset


func update_dir( rotate : Node2D ):
	if dir_nxt != dir_cur:
		dir_cur = dir_nxt
		rotate.scale.x = dir_cur

func _gravity( vely : float, delta : float, multiplier : float = 1.0 ) -> float:
	return min( vely + delta * GRAVITY * multiplier, TERM_VEL )
func gravity(  delta : float, multiplier : float = 1.0 ) -> void:
	vel.y = _gravity( vel.y, delta, multiplier )


func is_at_border( delta : float, check_back : bool = false ) -> bool:
	# Check wall in front
	var gtrans = global_transform
	# test falling
#	var fall_vel = Vector2.DOWN# * GRAVITY * delta
#	var tfall = test_move( \
#		gtrans.translated( Vector2.RIGHT * 16 * dir_cur ), \
#			fall_vel * delta )
	var tfall = test_move( \
		gtrans.translated( Vector2.RIGHT * 16 * dir_cur ), \
			Vector2.DOWN )
	if not tfall: return true
	if check_back:
		tfall = test_move( \
			gtrans.translated( Vector2.LEFT * 16 * dir_cur ), \
			Vector2.DOWN )
		if not tfall: return true
	# test wall
	var wall_vel = Vector2.RIGHT * dir_cur * 100 # cheating
	var wall = test_move( gtrans, wall_vel * delta )
	if wall: return true
	return false

