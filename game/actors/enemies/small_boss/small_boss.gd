extends Enemy

#onready var fsm = StackedFSM.new( self, $states, $states/idle, null, true )


func _physics_process( _delta: float ) -> void:
	#fsm.run_machine( delta )
	global_position = get_global_mouse_position()

