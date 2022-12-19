extends Reference
class_name FSM

var debug = false
var states = {}
var state_cur = null
var state_nxt = null
var state_lst = null
var obj : KinematicBody2D = null
var anim = null


# warning-ignore:shadowed_variable
func _init( _obj, _states_parent_node, _initial_state, _anim = null, _debug = false ):
	obj = _obj
	debug = _debug
	anim = _anim
	_set_states_parent_node( _states_parent_node )
	state_nxt = _initial_state

func _set_states_parent_node( pnode ):
	if debug: print( "Found ", pnode.get_child_count(), " states" )
	if pnode.get_child_count() == 0:
		return
	var state_nodes = pnode.get_children()
	for state_node in state_nodes:
		if not state_node is FSM_State: continue
		if debug: print( "adding state: ", state_node.name )
		states[ state_node.name ] = state_node
		state_node.fsm = self
		state_node.obj = self.obj
		state_node.anim = self.anim

func run_machine( delta ):
	if state_nxt != state_cur:
		if state_cur != null:
			if debug:
				print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": changing from state ", state_cur.name, " to ", state_nxt.name )
			state_cur._terminate()
		elif debug:
			print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": starting with state ", state_nxt.name )
		state_lst = state_cur
		state_cur = state_nxt
		state_cur._initialize()
	# run state
	state_cur._run( delta )

func is_state( check : FSM_State ) -> bool:
	if state_cur == check or state_nxt == check:
		return true
	return false

