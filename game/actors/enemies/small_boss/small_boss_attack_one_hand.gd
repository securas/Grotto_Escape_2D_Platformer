extends StackedFSM_State
#
#const ATTACKSTART_YPOS = 90
#const MOVE_VEL = 70
#const WAIT_TIME = 0.5
#const ATTACK_DURATION = 0.5
#const FLOOR_YPOS = 176
#const FINISH_TIME = 1.0
#
#var _tw : Tween
#var _wait_to_terminate : float
#
#func _ready() -> void:
#	_tw = Tween.new()
#	_tw.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
#	add_child( _tw )
#	var _ret = _tw.connect( "tween_all_completed", self, "_finished_attack" )
#
#func _initialize() -> void:
#	_attack_animation()
#	_wait_to_terminate = -1.0
#
#func _run( delta : float ) -> void:
#	if _wait_to_terminate > 0:
#		_wait_to_terminate -= delta
#		if _wait_to_terminate <= 0:
#			fsm.pop()
#
#
#func _terminate():
#	var _ret = _tw.stop_all()
#
#
#func _attack_animation():
#	var _ret : int
#	var _head = obj.get_node( "head" )
#	var _hand_right = obj.get_node( "hand_right" )
#	var _hand_left = obj.get_node( "hand_left" )
#	var hand = _hand_left
#	_ret = _tw.stop_all()
#	_ret = _tw.remove_all()
#	# move hand to player position
#	var hand_target_pos = Vector2( game.player.position.x, ATTACKSTART_YPOS )
#	var duration = ( hand_target_pos - hand.global_position ).length() / MOVE_VEL
#	_ret = _tw.interpolate_property( hand, "global_position", \
#		hand.global_position, hand_target_pos, duration, \
#		Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
##	# move head also
##	if hand == _hand_left and hand_target_pos.x >= hand.global_position.x:
##		# move head along with hand
##		_ret = _tw.interpolate_property( _head, "global_position", \
##			_head.global_position, hand_target_pos +, duration, \
##			Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0 )
#	# drop hand
#	var hand_floor_pos = Vector2( hand_target_pos.x, FLOOR_YPOS )
#	_ret = _tw.interpolate_property( hand, "global_position", \
#		hand_target_pos, hand_floor_pos + Vector2.DOWN, ATTACK_DURATION - 0.1, \
#		Tween.TRANS_BACK, Tween.EASE_IN, duration + WAIT_TIME)
#	_ret = _tw.interpolate_property( hand, "global_position", \
#		hand_floor_pos + Vector2.DOWN, hand_floor_pos, 0.1, \
#		Tween.TRANS_BACK, Tween.EASE_IN, duration + WAIT_TIME + ATTACK_DURATION - 0.1)
#	_ret = _tw.interpolate_callback( self, \
#		ATTACK_DURATION + duration + WAIT_TIME - 0.1, "_attack_shake" )
#	_ret = _tw.start()
#
#func _attack_shake():
#	sigmgr.emit_signal( "camera_shake", 0.2, 60, 2 )
#
#func _finished_attack():
#	_wait_to_terminate = FINISH_TIME
