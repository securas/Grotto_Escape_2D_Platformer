extends Enemy

var fsm : StackedFSM

onready var hand_right = $hand_right
onready var hand_left = $hand_left

func _ready() -> void:
	fsm = StackedFSM.new( self, $states, $states/enter, $anim, true )
	fsm.states.enter.nxt_state = fsm.states.idle
	energy = 30

func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )

func _on_receiving_damage( _player, damage ):
	energy -= damage
	
