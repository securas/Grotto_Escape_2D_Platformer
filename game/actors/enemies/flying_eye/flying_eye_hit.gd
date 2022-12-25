extends EnemyBehavior_AirHit

func _initialize() -> void:
	._initialize()
	anim.nxt( "hit" )
	
func _enable_damage():
	obj.get_node( "DealDamageArea/damage_collision" ).call_deferred( "set_disabled", false )
	
func _disable_damage():
	obj.get_node( "DealDamageArea/damage_collision" ).call_deferred( "set_disabled", true )
