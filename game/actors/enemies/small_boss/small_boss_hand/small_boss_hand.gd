tool
extends Enemy
class_name SmallBossHand

# warning-ignore:unused_signal
signal finished_attack

enum AttackTypes { SIMPLE, DROP_DRAG, HIT_WALL }

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
	fsm = StackedFSM.new( self, $states, $states/wait, $anim, false )
	idle_position = position
	set_as_toplevel( true )
	global_position = Vector2( 320, 0 ) if right_hand else Vector2( 0, 0 )

func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )

func begin_idle():
	var _ret = fsm.pop()
	fsm.push( fsm.states.idle )

func begin_attack( attack_type : int ) -> void:
	match attack_type:
		AttackTypes.SIMPLE:
			fsm.push( fsm.states.simple_attack )
		AttackTypes.DROP_DRAG:
			fsm.push( fsm.states.drop_drag )
		AttackTypes.HIT_WALL:
			fsm.push( fsm.states.hit_wall )

func v_dist_to_player():
	return game.player.position.x - global_position.x

func h_dist_to_player():
	return game.player.position.y - global_position.y
