extends Control


func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/garagem.tscn")
