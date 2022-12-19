extends Reference
class_name PlayerControl

const CONTROLLER_BTN_RANGE = 0.1
const CONTROLLER_BTN_RANGE_Y = 0.5

var input_enabled : bool = true
var is_moving : bool
var dir : float
var fulldir : Vector2
var is_just_jump : bool
var is_jump : bool
var is_up: bool
var is_down : bool
var is_just_down : bool
var is_attack : bool
var is_just_attack : bool


func update_input( _delta : float ) -> void:
	if input_enabled:
		var aux = Input.get_action_strength( "btn_right" ) - Input.get_action_strength( "btn_left" )
		is_moving = false
		if abs( aux ) > CONTROLLER_BTN_RANGE:
			dir = sign( aux )
			is_moving = true
			fulldir.x = aux
		else:
			dir = 0.0
			fulldir.x = 0
		
		var auxv = Input.get_action_strength( "btn_down" ) - Input.get_action_strength( "btn_up" )
		if abs( auxv ) > CONTROLLER_BTN_RANGE:
			fulldir.y = auxv
			is_up = fulldir.y < -CONTROLLER_BTN_RANGE_Y
			is_down = fulldir.y > CONTROLLER_BTN_RANGE_Y
		else:
			fulldir.y = 0
			is_up = false
			is_down = false
		
		is_just_down = Input.is_action_just_pressed( "btn_down" )
		is_just_jump = Input.is_action_just_pressed( "btn_jump" )
		is_jump = Input.is_action_pressed( "btn_jump" )
		
		is_just_attack = Input.is_action_just_pressed( "btn_attack" )
		is_attack = Input.is_action_pressed( "btn_attack" )
	else:
		is_moving = false
		dir = 0
		fulldir *= 0
		is_just_jump = false
		is_jump = false
		is_up = false
		is_down = false
		is_just_down = false



