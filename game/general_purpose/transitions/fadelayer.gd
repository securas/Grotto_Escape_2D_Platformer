extends CanvasLayer

signal finished

func instant_fadeout():
	$fade.material.set_shader_param( "r", 1.0 )

func fadein():
	$anim.play("fadein")

func fadeout():
	$anim.play("fadeout")

func _on_anim_animation_finished(_anim_name: String) -> void:
	emit_signal( "finished" )
