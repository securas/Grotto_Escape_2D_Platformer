tool
extends Enemy

export( bool ) var right_hand := true setget _set_right_hand

var idle_position : Vector2

onready var anim_fx := $anim_fx
onready var rotate: Node2D = $rotate
var fsm : StackedFSM
var parent : Node2D


func _init() -> void:
	if Engine.editor_hint: set_physics_process( false )
	._init()
	
func _set_right_hand( v ) -> void:
	right_hand = v
	$rotate.scale.x = 1.0 if right_hand else -1.0

func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process( false )
		return
	parent = get_parent()
	fsm = StackedFSM.new( self, $states, $states/wait, null, true )
	idle_position = position
	set_as_toplevel( true )
	global_position = Vector2( 320, 0 ) if right_hand else Vector2( 0, 0 )

func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )

func begin_idle():
	var _ret = fsm.pop()
	fsm.push( fsm.states.idle )
