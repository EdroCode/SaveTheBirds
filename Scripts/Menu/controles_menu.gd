extends Control


func _on_button_button_down() -> void:
	ClickSound.play()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
