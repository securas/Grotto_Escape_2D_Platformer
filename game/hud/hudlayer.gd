extends CanvasLayer

var cur_energy : int
var cur_max_energy : int
var cur_weapon_temperature : float
var cur_weapon_max_temperature : float


func _ready() -> void:
	cur_energy = game.state.energy
	cur_max_energy = game.state.max_energy
	cur_weapon_temperature = game.state.weapon_temperature
	cur_weapon_max_temperature = game.state.weapon_max_temperature
	_update_energy()
	_update_temperature()
	var _ret : int
	_ret = sigmgr.connect( "gamestate_changed", self, "_on_gamestate_changed" )


func _on_gamestate_changed():
	_update_energy()
	_update_temperature()

func _update_energy() -> void:
	if cur_energy == game.state.energy and cur_max_energy == game.state.max_energy:
		return
	cur_energy = game.state.energy
	cur_max_energy = game.state.max_energy
	$energy/spin_tween.start()
	
	# update back according to max energy
	$energy/back.rect_size.x = 18 + ( game.state.max_energy - 5 ) * 3
	# update energy bars
	for count in range( 10 ):
		if count < game.state.energy:
			$energy/bars.get_child( count ).show()
		else:
			$energy/bars.get_child( count ).hide()

var temperature_alert := false
func _update_temperature() -> void:
	$temperature.visible = game.state.weapon_enabled
	if cur_weapon_temperature == game.state.weapon_temperature and \
		cur_weapon_max_temperature == game.state.weapon_max_temperature:
			return
	cur_weapon_temperature = game.state.weapon_temperature
	cur_weapon_max_temperature = game.state.weapon_max_temperature
	# set temperature
	$temperature/back.rect_size.x = 18 + ( game.state.weapon_max_temperature - 5 ) * 3
	$temperature/temp.rect_size.x = game.state.weapon_temperature * 3
	
	if not temperature_alert:
		if abs( cur_weapon_temperature - cur_weapon_max_temperature ) < 0.9:
			$temperature/spin_tween.start()
			temperature_alert = true
	else:
		if abs( cur_weapon_temperature - cur_weapon_max_temperature ) > 0.9:
			temperature_alert = false
