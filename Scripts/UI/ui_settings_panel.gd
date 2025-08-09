extends Control

@onready var open_sound = preload("res://Resources/SFX/page-flip-sound-effect-384077.mp3")
@onready var close_sound = preload("res://Resources/SFX/page-flip-47177.mp3")


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_music_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Pause"):
		
		pause_and_unpause()

func pause_and_unpause():
	if get_tree().paused == true:
		get_tree().paused = false
		$AudioStreamPlayer.stream = close_sound
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("Close")
	elif get_tree().paused == false:
		$AudioStreamPlayer.stream = open_sound
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("Open")
		get_tree().paused = true


func _on_house_button_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")



func _on_reset_button_button_down() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
