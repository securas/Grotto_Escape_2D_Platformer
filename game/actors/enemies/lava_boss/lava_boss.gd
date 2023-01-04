extends Enemy

var fsm : StackedFSM


onready var rotate: Node2D = $rotate

func _ready() -> void:
	fsm = StackedFSM.new( self, $states, $states/enter, $anim, true )
	fsm.states.enter.nxt_state = fsm.states.idle
	energy = 30
	$rotate/RcvDamageArea.control_node = self

func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )

func _on_receiving_damage( _player, damage ):
	energy -= damage
	if energy > 0:
		$rotate/head/flash_tween.start( 0.1, 1 )
