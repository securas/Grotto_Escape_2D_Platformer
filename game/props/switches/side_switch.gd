tool
extends Node2D
enum SwitchColor { GREEN, BLUE }

signal pressed
export( SwitchColor ) var switch_color : int = SwitchColor.GREEN setget _set_switchcolor
export( bool ) var flip := false setget _set_flip

var id : String
var is_pressed := false

func _set_flip( v : bool ) -> void:
	flip = v
	$rotate.scale.x = -1 if flip else 1

func _set_switchcolor( v : int ) -> void:
	switch_color = v
	match switch_color:
		SwitchColor.GREEN:
			$rotate/switch.region_rect.position = Vector2( 208, 128 )
		SwitchColor.BLUE:
			$rotate/switch.region_rect.position = Vector2( 208, 128 - 16 )

func _ready() -> void:
	if Engine.editor_hint:
		return
	$rotate/RcvDamageArea.control_node = self
	id = Utils.get_unique_id( self )
	if game.is_event( "switch_" + id ):
		is_pressed = true
		match switch_color:
			SwitchColor.GREEN:
				$anim.play( "pressed" )
			SwitchColor.BLUE:
				$anim.play( "pressed_blue" )
		$rotate/check_player.queue_free()
		$rotate/RcvDamageArea.queue_free()
		call_deferred( "emit_signal", "pressed" )

func _on_check_player_body_entered( _body: Node ) -> void:
	if is_pressed: return
	is_pressed = true
	match switch_color:
		SwitchColor.GREEN:
			$anim.play( "pressed" )
		SwitchColor.BLUE:
			$anim.play( "pressed_blue" )
	$rotate/check_player.queue_free()
	$rotate/RcvDamageArea.queue_free()
	var _ret = game.add_event( "switch_" + id )
	emit_signal( "pressed" )

func _on_receiving_damage( _from, _damage ):
	_on_check_player_body_entered( null )
