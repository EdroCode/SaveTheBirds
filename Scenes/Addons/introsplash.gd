extends Control



func start_game():
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func _process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		start_game()
