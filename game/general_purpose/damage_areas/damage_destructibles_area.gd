extends Area2D

export(int) var number_of_passes := 10
export(int) var damage_dealt := 1

func _ready():
	monitorable = false
	monitoring = true

func deal_damage():
	for _pass_count in range(number_of_passes):
		var objects = get_overlapping_bodies()
		
		pass
