extends Enemy

var fsm : StackedFSM

onready var hand_right = $hand_right
onready var hand_left = $hand_left

func _ready() -> void:
	fsm = StackedFSM.new( self, $states, $states/enter, null, true )
	fsm.states.enter.nxt_state = fsm.states.idle

func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )


