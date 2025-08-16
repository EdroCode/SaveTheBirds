extends Node2D


func finish_level():
	
	
	get_tree().change_scene_to_file("res://Scenes/Levels/boss_fight.tscn")


func start_music():
	
	
	BossTheme.play()
