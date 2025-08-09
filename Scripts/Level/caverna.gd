extends Node2D



@onready var anim = $AnimationPlayer



func _process(delta: float) -> void:
	
	
	
	$Mist.offset.x += 0.09
	
	if Input.is_action_just_pressed("Reset"):
		reload_scene()


func reload_scene():
	get_tree().reload_current_scene()


func _on_player_died() -> void:
	$AnimationPlayer.play("End")
