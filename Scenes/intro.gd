extends Node2D

var can_light = false


func can_play():
	
	can_light = true


func _process(delta: float) -> void:
	
	if can_light:
		if Input.is_action_just_pressed("LeftClick"):
			$AnimationPlayer.play("2phase")
	
	if Input.is_action_just_pressed("ActionE"):
		$AnimationPlayer.stop()
		$AnimationPlayer2.play("End")


func change_scene():
	GameManager.cutscene_seen = true
	get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")



@onready var foot1 = preload("res://Resources/SFX/footstep1.wav")
@onready var foot2 = preload("res://Resources/SFX/footstep2.wav")


func play_walk_sound():
	var a = randi_range(0,1)
	var pitch = randf_range(0.912, 1.145)
	
	
	if a == 1:
		$WalkAudioStreamPlayer2D.stream = foot1
		$WalkAudioStreamPlayer2D.pitch_scale = pitch
		$WalkAudioStreamPlayer2D.play()
	else:
		$WalkAudioStreamPlayer2D.stream = foot2
		$WalkAudioStreamPlayer2D.pitch_scale = pitch
		$WalkAudioStreamPlayer2D.play()
		
