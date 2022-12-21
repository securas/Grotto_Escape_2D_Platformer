extends Node
class_name GameManager

const SAVEFILENAME = "user://savegame"

var debug := true

var player setget _set_player, _get_player
var state : Dictionary setget _set_gamestate
var settings : Dictionary setget _set_player_settings


#-----------------------
# Setters
#-----------------------
func _set_player( v ) -> void:
	player = weakref( v )

func _get_player():
	if player:
		return player.get_ref()
	return null

func _set_gamestate( v : Dictionary ) -> void:
	state = v
	sigmgr.emit_signal( "gamestate_changed" )

func _set_player_settings( v : Dictionary ) -> void:
	settings = v
	sigmgr.emit_signal( "settings_changed" )

#-----------------------
# Main
#-----------------------
func _ready():
	randomize()
	pause_mode = PAUSE_MODE_PROCESS
	set_initial_gamestate()
	set_initial_settings()

func set_initial_settings():
	settings.controller_btn_range = 0.1
	settings.keybinds = {}
	set_default_keybinds()

func set_default_keybinds():
	settings.keybinds.left = [ KEY_LEFT, KEY_A  ]
	settings.keybinds.right = [ KEY_RIGHT, KEY_D ]
	settings.keybinds.up = [ KEY_UP, KEY_W ]
	settings.keybinds.down = [ KEY_DOWN, KEY_S ]
	settings.keybinds.jump = [ KEY_SPACE ]

func save_settings():
	#TODO: Implement save settings file
	pass

#-----------------------
# Manage game state
#-----------------------
func set_initial_gamestate():
	state.player_dir = {
		"direction" : 1,
		"velocity" : Vector2.ZERO
	}
	state.worldpos = [ 64, 104 ]
	state.events = []
	state.max_energy = 5
	state.energy = state.max_energy
	state.weapon_enabled = false
	state.weapon_temperature = 0
	state.weapon_max_temperature = 5
	state.weapon_cooldown_rate = 1.0
	if debug:
		_set_debug_gamestate()
		
	var _ret = save_gamestate()

func _set_debug_gamestate():
	state.weapon_enabled = true
	pass


#-----------------------
# Save game
#-----------------------
var backup_state : Dictionary
func save_gamestate() -> bool:
	var res : bool = true
#	var save_filename = SAVEFILENAME + "_debug.sav" if debug else ".sav"
#	res = Utils.save_encrypted_file( save_filename, state )
	backup_state = state.duplicate( true )
	return res

func load_gamestate() -> bool:
#	var save_filename = SAVEFILENAME + "_debug.sav" if debug else ".sav"
#	var aux = Utils.load_encrypted_file( save_filename )
#	if not aux: return false
#	state = aux.duplicate( true )
	state = backup_state.duplicate( true )
	return true

#-----------------------
# Manage events
#-----------------------
func is_event( evt_name : String ) -> bool:
	if state.events.find( evt_name ) > -1:
		return true
	return false

func add_event( evt_name : String ) -> bool:
	if is_event( evt_name ): return false
	state.events.append( evt_name )
	return true






#func set_player_state_position( level : LDtkLevel, levelpos : Vector2, direction : float = -999 ):
#	var worldpos = level._level.rect.position + levelpos
#	if direction != -999:
#		state.player_dir.direction = direction
#		state.player_dir.velocity *= 0
#	state.worldpos = [ worldpos.x, worldpos.y ]
