tool
extends KinematicBody2D

enum PlatformColor { GREEN, BLUE }


export( PlatformColor ) var platform_color : int = PlatformColor.GREEN setget _set_platformcolor


func _set_platformcolor( v : int ) -> void:
	platform_color = v
	match platform_color:
		PlatformColor.GREEN:
			$tile.region_rect.position = Vector2( 160, 128 )
		PlatformColor.BLUE:
			$tile.region_rect.position = Vector2( 160, 128 - 16 )
