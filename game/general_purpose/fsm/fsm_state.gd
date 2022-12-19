extends Node
class_name FSM_State

# warning-ignore:unused_class_variable
var fsm = null
# warning-ignore:unused_class_variable
var obj : KinematicBody2D
## warning-ignore:unused_class_variable
var anim : FSM_Anim


func is_current() -> bool:
	if not fsm: return false
	return fsm.is_state( self )

func _initialize() -> void:
	pass

func _terminate() -> void:
	pass

func _run( _delta : float ) -> void:
	pass
