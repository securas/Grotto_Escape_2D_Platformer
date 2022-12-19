tool
extends Node2D

const PNGPATH = "res://ldtk/grotto/png/"

func _enter_tree() -> void:
	if not Engine.editor_hint: return
	print( "Updating map images" )
	for c in get_children():
		c.queue_free()
	var world = LDtkWorldData.new( preload( "res://ldtk/grotto.ldtk" ) )._world as Dictionary
	var rooms = world.keys()
	for r in rooms:
		var texturefile = "%s/%s.png" % [ PNGPATH, r ]
		var texture = load( texturefile )
		var s := Sprite.new()
		s.texture = texture
		s.position = world[ r ].level_rect.position
		s.centered = false
		add_child( s )
#		var texture = load(  )
	
