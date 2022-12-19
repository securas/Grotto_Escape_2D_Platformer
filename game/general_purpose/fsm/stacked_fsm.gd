extends Reference
class_name StackedFSM

var debug = false
var states = {}
var obj : KinematicBody2D = null

var _stack : Array
var _state_cur = null
var _state_nxt = null
var _state_lst = null
var anim

func _init( _obj, _states_parent_node, _initial_state, _anim = null, _debug = false ):
	obj = _obj
	debug = _debug
	_set_states_parent_node( _states_parent_node, _anim )
	_stack.push_back( _initial_state )
	anim = _anim



func _set_states_parent_node( pnode, _anim ) -> void:
	if debug: print( "Found ", pnode.get_child_count(), " states" )
	if pnode.get_child_count() == 0:
		return
	var state_nodes = pnode.get_children()
	for state_node in state_nodes:
		if not state_node is StackedFSM_State: continue
		if debug: print( "adding state: ", state_node.name )
		states[ state_node.name ] = state_node
		state_node.fsm = self
		state_node.obj = self.obj
		state_node.anim = _anim

func push( state : StackedFSM_State ) -> void:
	_stack.push_back( state )

func pop() -> StackedFSM_State:
	return _stack.pop_back()

func run_machine( delta ):
	_state_nxt = _stack[-1]
	if _state_nxt != _state_cur:
		if _state_cur != null:
			if debug:
				print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": changing from state ", _state_cur.name, " to ", _state_nxt.name )
			_state_cur._terminate()
		elif debug:
			print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": starting with state ", _state_nxt.name )
		_state_lst = _state_cur
		_state_cur = _state_nxt
		_state_cur._initialize()
	# run state
	_state_cur._run( delta )


func is_state( state ):
	return _state_cur == state or _state_nxt == state
