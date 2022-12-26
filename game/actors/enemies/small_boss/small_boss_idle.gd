extends StackedFSM_State

var tw : Tween

func _ready() -> void:
	tw = Tween.new()
	tw.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child( tw )
	var _ret = tw.connect( "tween_all_completed", self, "_idle_animation" )

func _initialize() -> void:
	_idle_animation()


func _terminate():
	var _ret = tw.stop_all()

func _idle_animation():
	var _ret : int
	var head = obj.get_node( "head" )
	var hand_right = obj.get_node( "hand_right" )
	var hand_left = obj.get_node( "hand_left" )
	_ret = tw.stop_all()
	_ret = tw.remove_all()
	# head
	_ret = tw.interpolate_property( head, "position", \
		head.position, Vector2( 0, 2 ), 0.25, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
	_ret = tw.interpolate_property( head, "position", \
		Vector2( 0, 2 ), Vector2( 0, -2 ), 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.25 )
	_ret = tw.interpolate_property( head, "position", \
		Vector2( 0, -2 ), Vector2( 0, 0 ), 0.25, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.75 )
	# left hand
	_ret = tw.interpolate_property( hand_left, "position", \
		hand_left.position, Vector2( -36, 19 ), 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
	_ret = tw.interpolate_property( hand_left, "position", \
		Vector2( -36, 19 ), Vector2( -36, 23 ), 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.5 )
	# right hand
	_ret = tw.interpolate_property( hand_right, "position", \
		hand_right.position, Vector2( 36, 19 ), 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
	_ret = tw.interpolate_property( hand_right, "position", \
		Vector2( 36, 19 ), Vector2( 36, 23 ), 0.5, \
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.5 )
	_ret = tw.start()
