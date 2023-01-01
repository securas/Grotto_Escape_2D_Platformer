extends StackedFSM_State



var _tw : Tween
var initial_position : Vector2 = Vector2( 160, 220 )
var final_position : Vector2 = Vector2( 160, 90 )
var duration : float = 3.0
var nxt_state : StackedFSM_State

func _ready() -> void:
	_tw = Tween.new()
	_tw.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child( _tw )
	var _ret = _tw.connect( "tween_all_completed", self, "_finished_entering" )

func _initialize() -> void:
	var _ret : int
	_ret = _tw.interpolate_property( obj, "position", \
		initial_position, final_position, duration, \
		Tween.TRANS_SINE, Tween.EASE_OUT, 0.0 )
	_ret = _tw.start()
	anim.nxt( "RESET" )

func _finished_entering() -> void:
	fsm.pop()
	fsm.push( nxt_state )
	obj.hand_right.begin_idle()
	obj.hand_left.begin_idle()

