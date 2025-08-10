extends Control


func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")


func _on_button_3_button_down() -> void:
		get_tree().change_scene_to_file("res://Scenes/Menus/credits.tscn")


func _on_button_4_button_down() -> void:
		get_tree().change_scene_to_file("res://Scenes/Menus/controles_menu.tscn")
