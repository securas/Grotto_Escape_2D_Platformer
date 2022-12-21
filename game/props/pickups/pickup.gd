extends Area2D
class_name Pickup

signal item_picked

onready var id : String

func _ready() -> void:
	if Engine.editor_hint: return
	id = Utils.get_unique_id( self )
	if game.is_event( "pickup_" + id ):
		queue_free()
	var _ret = connect( "body_entered", self, "_on_pickup_body_entered", \
		[], CONNECT_DEFERRED + CONNECT_ONESHOT )

func _on_pickup_body_entered( _body: Node ) -> void:
	var _ret = game.add_event( "pickup_" + id )
	emit_signal( "item_picked" )
	_item_picked()
	queue_free()


func _item_picked() -> void:
	pass
