extends Reference
class_name LDtkWorldData

var _LDtk_World : PackedDataContainer = null
var _world : Dictionary

func _init( LDtk_World : PackedDataContainer ):
	_LDtk_World = LDtk_World
	_update_LDtk_world()

func _update_LDtk_world() -> void:
	var data = bytes2var( _LDtk_World.__data__, true )
	if data.size() < 4: return
	var world_data = bytes2var( data, true )
	_world = world_data.world.duplicate( true )

func get_level_at( world_position : Vector2 ) -> String:
	for level in _world:
		var r = _world[level].level_rect as Rect2
		if r.has_point( world_position ):
			return level
	return ""

func get_level_data( level_name : String ) -> Dictionary:
	if _world.has( level_name ):
		return _world[ level_name ]
	return {}
