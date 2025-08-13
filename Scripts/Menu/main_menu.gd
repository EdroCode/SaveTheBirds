extends Control


func _on_start_button_button_down() -> void:
	$AnimationPlayer2.play("EndMainMenu")


func _on_button_3_button_down() -> void:
	ClickSound.play()
	
	get_tree().change_scene_to_file("res://Scenes/Menus/credits.tscn")


func _on_button_4_button_down() -> void:
	ClickSound.play()
	
	get_tree().change_scene_to_file("res://Scenes/Menus/controles_menu.tscn")

func _on_button_2_button_down() -> void:
	ClickSound.play()

	get_tree().change_scene_to_file("res://Scenes/Menus/options_menu.tscn")


func start():
	ClickSound.play()
	
	if GameManager.cutscene_seen == true:
		get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func increase(goal):
	$AudioStreamPlayer2D.play()
	goal.scale += Vector2(0.1,0.1)


func decrease(goal):
	
	goal.scale -= Vector2(0.1,0.1)


func _on_start_button_mouse_entered() -> void:
	increase($StartButton)


func _on_start_button_mouse_exited() -> void:
	decrease($StartButton)


func _on_button_3_mouse_entered() -> void:
	increase($Button3)


func _on_button_3_mouse_exited() -> void:
	decrease($Button3)


func _on_button_4_mouse_entered() -> void:
	increase($Button4)


func _on_button_4_mouse_exited() -> void:
	decrease($Button4)


func _on_button_2_mouse_entered() -> void:
	increase($Button2)


func _on_button_2_mouse_exited() -> void:
	decrease($Button2)
