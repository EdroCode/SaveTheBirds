extends Node2D



@onready var anim = $AnimationPlayer
@onready var level_completed = false



func _process(delta: float) -> void:
	
	
	
	$Mist.offset.x += 0.09
	
	if Input.is_action_just_pressed("Reset"):
		reload_scene()


func reload_scene():
	get_tree().reload_current_scene()


func finish_level():
	level_completed = true
	GameManager.caverna_finished = true
	get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")
	


func _on_player_died() -> void:
	$AnimationPlayer.play("End")


func _on_end_level_timer_timeout() -> void:
	$AnimationPlayer.play("EndComplete")


func _on_eyes_collected() -> void:
	$EndLevelTimer.start()
