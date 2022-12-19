extends Node
class_name LDtkEntitySpawner

export( PackedDataContainer ) var LDtk_Resource : PackedDataContainer = null setget _set_LDtk_Resource
export( Array, String ) var levels := [ "" ] setget _set_levels
export( Array, String ) var layers := [ "" ] setget _set_layers

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
		_update_LDtk_resource()

func _set_layers( v ):
	layers = v
	if LDtk_Resource and LDtk_Resource is PackedDataContainer and Engine.editor_hint:
		_update_LDtk_resource()

func _update_LDtk_resource():
#	print( "Resource size: ", LDtk_Resource.size() )
#	if LDtk_Resource.size() < 0: return
	var data = bytes2var( LDtk_Resource.__data__, true )
#	print( "Data size: ", data.size() )
#	if data.size() < 0: return
	var resource_data = bytes2var( data, true )
	var entities_data = resource_data.entities
#	var entities_list = resource_data.entities_list
	
	if resource_data.single_level_resource:
		levels = [resource_data.single_level_name]
	for level_name in levels:
		if level_name.empty(): continue
		for layer_name in layers:
			if layer_name.empty(): continue
			var entities = _get_entities( level_name, layer_name, entities_data )
			
			# create a local list of entities
			var entities_list = []
			for e in entities:
				if entities_list.find( e.id ) > -1: continue
				entities_list.append( e.id )
			# print( "Entities List: ", entities_list)
			
			for key in entities_list:
				var entity_group = []
				for e in entities:
					if e.id == key:
						entity_group.append( e )
				if entity_group.empty():
					continue
#				call_deferred( "_spawn_entity_group", entity_group )
				_spawn_entity_group( entity_group )
#
			for entity in entities:
				call_deferred( "_spawn_entity", entity )
#				_spawn_entity( entity )

func _get_entities( level_name, layer_name, entities_data ):
	var entities = []
	if entities_data.has( level_name ):
		if entities_data[level_name].has( layer_name ):
			return entities_data[level_name][layer_name]
	return entities

func _spawn_entity( entity_data : Dictionary ) -> void:
	pass

func _spawn_entity_group( entity_group : Array ) -> void:
	pass
