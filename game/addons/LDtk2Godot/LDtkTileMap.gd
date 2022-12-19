tool
extends TileMap
class_name LDtkTileMap

export( PackedDataContainer ) var LDtk_Resource : PackedDataContainer = null setget _set_LDtk_Resource
export( Array, String ) var levels := [ "" ] setget _set_levels
export( Array, String ) var layers := [ "" ] setget _set_layers
export( int ) var tileno := 0 setget _set_tileno

var cell_data : Dictionary

func _enter_tree():
	if LDtk_Resource and LDtk_Resource is PackedDataContainer:
		_update_LDtk_resource()

func _set_LDtk_Resource( v ):
	LDtk_Resource = v
	if LDtk_Resource and LDtk_Resource is PackedDataContainer and Engine.editor_hint:
		_update_LDtk_resource()

func _set_levels( v ):
	levels = v
	if LDtk_Resource and LDtk_Resource is PackedDataContainer and Engine.editor_hint:
#		_update_LDtk_resource()
		_update_cell_data( cell_data )

func _set_layers( v ):
	layers = v
	if LDtk_Resource and LDtk_Resource is PackedDataContainer and Engine.editor_hint:
#		_update_LDtk_resource()
		_update_cell_data( cell_data )

func _set_tileno( v ):
	tileno = v
	if LDtk_Resource and LDtk_Resource is PackedDataContainer and Engine.editor_hint:
#		_update_LDtk_resource()
		_update_cell_data( cell_data )

func _update_LDtk_resource():
#	if LDtk_Resource.size() < 4: return
	var data = bytes2var( LDtk_Resource.__data__, true )
	if data.size() < 4: return
#	var cell_data = bytes2var( data, true )
	cell_data = bytes2var( data, true )
	_update_cell_data( cell_data )

func _update_cell_data( data ):
	clear()
	if data.single_level_resource:
		levels = [data.single_level_name]
	for level_name in levels:
		if level_name.empty(): continue
		for layer_name in layers:
			if layer_name.empty(): continue
			var cells = _get_cell_data( level_name, layer_name, data.celldata )
			for c in cells:
				.set_cell( c.x, c.y, tileno, c.flip_x, c.flip_y, c.transpose, c.autotile_coord )

func _get_cell_data( level_name : String, layer_name : String, celldata : Dictionary) -> Array:
	if celldata.has( level_name ):
		if celldata[level_name].has( layer_name ):
			return celldata[level_name][layer_name]
	return []

