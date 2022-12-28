tool
extends Enemy

export( bool ) var right_hand := true setget _set_right_hand

var idle_position : Vector2


onready var fsm = StackedFSM.new( self, $states, $states/idle, null, true )
onready var parent : Node2D = get_parent()
onready var anim_fx := $anim_fx
onready var rotate: Node2D = $rotate

func _set_right_hand( v ) -> void:
	right_hand = v
	$rotate.scale.x = 1.0 if right_hand else -1.0

func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process( false )
		return
	idle_position = position
	set_as_toplevel( true )
	
func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )
