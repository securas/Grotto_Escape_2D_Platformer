tool
extends Node2D
class_name LDtkLevel

signal player_leaving_level( player_world_position )

export( PackedDataContainer ) var _LDtk_World : PackedDataContainer = null setget _set_LDtk_World
export( PackedDataContainer ) var _LDtk_Resource : PackedDataContainer = null setget _set_LDtk_Resource

export( int ) var _player_detection_mask : int = 0 setget _set_player_detection_mask
export( float ) var _player_detection_grace_time : float = 0.15

var _world : Dictionary
var _level : Dictionary
var _level_limits_created := false
var _detect_player := {}
var _detect_width := 4.0
var _detect_margin := 4.0
var _player_reported := false

#======================================
# Setters
#======================================
func _set_LDtk_Resource( resource ) -> void:
	_LDtk_Resource = resource
	if _LDtk_Resource and _LDtk_Resource is PackedDataContainer: # and Engine.editor_hint:
		_update_LDtk_resource( resource )

func _set_LDtk_World( resource ) -> void:
	_LDtk_World = resource
	if _LDtk_World and _LDtk_World is PackedDataContainer:
		_update_LDtk_world()

func _enter_tree() -> void:
	if _LDtk_Resource and _LDtk_Resource is PackedDataContainer:
		_update_LDtk_resource( _LDtk_Resource )
	if _LDtk_World and _LDtk_World is PackedDataContainer:
		_update_LDtk_world()
	if _world and _level and not Engine.editor_hint:
		_create_level_limits()
	elif not Engine.editor_hint:
		printerr( "LDtkLevel: Unable to set level since world or level data is not present" )

func _set_player_detection_mask( v : int ) -> void:
	_player_detection_mask = v

#======================================
# Update resource
#======================================
func _update_LDtk_resource( resource : Resource ) -> void:
	var data = bytes2var( resource.__data__, true )
	if data.size() < 4: return
	var level_data = bytes2var( data, true ) as Dictionary
	if level_data.single_level_resource:
		var _level_name = level_data.world.keys()[0]
		_level["name"] = level_data.world.keys()[0]
		_level["rect"] = level_data.world[_level_name].level_rect
	_set_LDtk_tilemaps_recursive( self, resource )

func _set_LDtk_tilemaps_recursive( node : Node, resource : Resource ) -> void:
	for c in node.get_children():
		if c is LDtkTileMap:
			c.LDtk_Resource = resource
		_set_LDtk_tilemaps_recursive( c, resource )

func _update_LDtk_world() -> void:
	var data = bytes2var( _LDtk_World.__data__, true )
	if data.size() < 4: return
	var world_data = bytes2var( data, true )
	_world = world_data.duplicate( true )

#======================================
# Create and manage level limits
#======================================
func _create_level_limits() -> void:
	if _level_limits_created: return
	_level_limits_created = true
#	print( "Creating level limits: ", _player_detection_mask )
	var _ret : int
	
	# Detection areas
	_detect_player.area_top = Area2D.new()
	_detect_player.area_top.name = "_player_limits_top"
	_detect_player.area_top.collision_layer = 0
	_detect_player.area_top.collision_mask = _player_detection_mask
	_detect_player.shape_top = CollisionShape2D.new()
	_detect_player.shape_top.shape = RectangleShape2D.new()
	_detect_player.shape_top.shape.extents = Vector2( _level.rect.size.x * 0.5, _detect_width )
	_detect_player.shape_top.position = Vector2( _level.rect.size.x * 0.5, -_detect_width - _detect_margin )
	_detect_player.shape_top.disabled = true
	_ret = _detect_player.area_top.connect( \
		"body_entered", self, "_on_player_detected_top", [], CONNECT_DEFERRED )
	add_child( _detect_player.area_top )
	_detect_player.area_top.add_child( _detect_player.shape_top )
	
	_detect_player.area_bottom = Area2D.new()
	_detect_player.area_bottom.name = "_player_limits_bottom"
	_detect_player.area_bottom.collision_layer = 0
	_detect_player.area_bottom.collision_mask = _player_detection_mask
	_detect_player.shape_bottom = CollisionShape2D.new()
	_detect_player.shape_bottom.shape = _detect_player.shape_top.shape
	_detect_player.shape_bottom.position = Vector2( _level.rect.size.x * 0.5, _level.rect.size.y + _detect_width + _detect_margin )
	_detect_player.shape_bottom.disabled = true
	_ret = _detect_player.area_bottom.connect( \
		"body_entered", self, "_on_player_detected_bottom", [], CONNECT_DEFERRED )
	add_child( _detect_player.area_bottom )
	_detect_player.area_bottom.add_child( _detect_player.shape_bottom )
	
	_detect_player.area_right = Area2D.new()
	_detect_player.area_right.name = "_player_limits_right"
	_detect_player.area_right.collision_layer = 0
	_detect_player.area_right.collision_mask = _player_detection_mask
	_detect_player.shape_right = CollisionShape2D.new()
	_detect_player.shape_right.shape = RectangleShape2D.new()
	_detect_player.shape_right.shape.extents = Vector2( _detect_width, _level.rect.size.y * 0.5 )
	_detect_player.shape_right.position = Vector2( _level.rect.size.x + _detect_width + _detect_margin, _level.rect.size.y * 0.5 )
	_detect_player.shape_right.disabled = true
	_ret = _detect_player.area_right.connect( \
		"body_entered", self, "_on_player_detected_right", [], CONNECT_DEFERRED )
	add_child( _detect_player.area_right )
	_detect_player.area_right.add_child( _detect_player.shape_right )
	
	_detect_player.area_left = Area2D.new()
	_detect_player.area_left.name = "_player_limits_left"
	_detect_player.area_left.collision_layer = 0
	_detect_player.area_left.collision_mask = _player_detection_mask
	_detect_player.shape_left = CollisionShape2D.new()
	_detect_player.shape_left.shape = _detect_player.shape_right.shape
	_detect_player.shape_left.position = Vector2( -_detect_width - _detect_margin, _level.rect.size.y * 0.5 )
	_detect_player.shape_left.disabled = true
	_ret = _detect_player.area_left.connect( \
		"body_entered", self, "_on_player_detected_left", [], CONNECT_DEFERRED )
	add_child( _detect_player.area_left )
	_detect_player.area_left.add_child( _detect_player.shape_left )
	
	# timer to start detection
	_detect_player.start_timer = Timer.new()
	_detect_player.start_timer.wait_time = _player_detection_grace_time
	_detect_player.start_timer.one_shot = true
	_detect_player.start_timer.autostart = false
	_ret = _detect_player.start_timer.connect( "timeout", self, "_on_detect_start_time" )
	add_child( _detect_player.start_timer )
	_detect_player.start_timer.start()

func _on_detect_start_time():
	_detect_player.shape_top.disabled = false
	_detect_player.shape_bottom.disabled = false
	_detect_player.shape_right.disabled = false
	_detect_player.shape_left.disabled = false
	
func _on_player_detected_top( _player : Node2D ) -> void:
	_report_player_detected( _level.rect.position + \
		Vector2( _player.position.x, -_detect_width - _detect_margin ) )

func _on_player_detected_bottom( _player : Node2D ) -> void:
	_report_player_detected( _level.rect.position + \
		Vector2( _player.position.x, _level.rect.size.y + _detect_width + _detect_margin ) )
	
func _on_player_detected_left( _player : Node2D ) -> void:
	_report_player_detected( _level.rect.position + \
		Vector2( -_detect_width - _detect_margin, _player.position.y ) )
	
func _on_player_detected_right( _player : Node2D ) -> void:
	_report_player_detected( _level.rect.position + \
		Vector2( _level.rect.size.x + _detect_width + _detect_margin, _player.position.y ) )

func _report_player_detected( player_world_position : Vector2 ) -> void:
	if _player_reported: return
#	_player_reported = true
	emit_signal( "player_leaving_level", player_world_position )


func get_level_rect() -> Rect2:
	return _level.rect

func get_worldpos( obj : Node2D ) -> Vector2:
	if not obj: return _level.rect.position
	return _level.rect.position + obj.global_position
