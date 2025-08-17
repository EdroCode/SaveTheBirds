extends Node2D


var lower_music = false

func _ready() -> void:
	
	$CanvasLayer/BossHealthBar/ProgressBar.value = $Boss.max_health


func _process(delta: float) -> void:
	
	$CanvasLayer/BossHealthBar/ProgressBar.value = $Boss.health
	
	if lower_music:
		BossTheme.volume_db -= delta
	
	if Input.is_action_just_pressed("Reset"):
		$AnimationPlayer2.play("End")


func _on_player_died() -> void:
	$AnimationPlayer2.play("End")


func _on_boss_death() -> void:
	$AnimationPlayer.play("win")

func finish_level():
	BossTheme.stop()
	
	GameManager.cidade_finished = true
	get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")

func reload_scene():
	
	BossTheme.stop()
	BossTheme.play()
	get_tree().reload_current_scene()


func _on_gear_collected() -> void:
	$EndLevelTimer.start()


func _on_end_level_timer_timeout() -> void:
	$AnimationPlayer2.play("EndComplete")


func lower_db():
	lower_music = true
	pass
