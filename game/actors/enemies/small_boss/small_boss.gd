extends Enemy

onready var fsm = StackedFSM.new( self, $states, $states/idle, null, true )


func _physics_process( delta: float ) -> void:
	fsm.run_machine( delta )

