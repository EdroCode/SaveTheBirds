extends Control

func _ready() -> void:
	
	$ColorRect2.visible = true


func _on_button_button_down() -> void:
	ClickSound.play()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
