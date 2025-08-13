extends Control



func _on_h_slider_value_changed(value: float) -> void:

	
	GameManager.sfx_volume = $Volume/HSlider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_music_h_slider_value_changed(value: float) -> void:
	
	GameManager.music_volume = $Music/MusicHSlider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _ready() -> void:
	
	$Volume/HSlider.value = GameManager.sfx_volume
	$Music/MusicHSlider.value = GameManager.music_volume


func _on_button_button_down() -> void:
	ClickSound.play()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
	


func _on_music_h_slider_drag_started() -> void:
	ClickSound.play()



func _on_h_slider_drag_started() -> void:
	ClickSound.play()
