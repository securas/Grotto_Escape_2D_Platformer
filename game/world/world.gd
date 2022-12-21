tool
extends Node2D

onready var world = LDtkWorldData.new( preload( "res://ldtk/grotto.ldtk" ) )

var cur_level : MapRoom


func _ready() -> void:
	var _ret : int
	_ret = sigmgr.connect( "load_gamestate", self, "_on_load_gamestate" )
	if game.debug:
		game.state.worldpos = $fake_player.position
		_ret = game.save_gamestate()
		sigmgr.emit_signal( "load_gamestate" )
	$map_images.queue_free()
	$fake_player.queue_free()
#	$music_mgr.play()


func _on_load_gamestate():
	_on_change_level( \
		Vector2( game.state.worldpos[0], game.state.worldpos[1] ), game.state.player_dir )


func _on_change_level( worldpos : Vector2, player_dir : Dictionary ):
	var new_level_name = world.get_level_at( worldpos )
	if not new_level_name: return
	
	# convert level name to a scene name
	var scn_file = "res://world/level_scenes//%s.tscn" % [ new_level_name ]
	cur_level = load( scn_file ).instance()
	var _ret = cur_level.connect( "change_level", self, "_on_change_level" )
	cur_level.player_dir = player_dir
	cur_level.player_pos = worldpos
	cur_level.world = world
	
	for l in $maps.get_children():
		l.queue_free()
	$maps.add_child( cur_level )
	

