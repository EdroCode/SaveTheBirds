extends Node2D

@onready var anim = $AnimationPlayer
@onready var level_completed = false



func _ready() -> void:
	
	for i in $Node2D/Eyes.get_children():
		i.frame = randi_range(0, 7)
		i.rotation = randf_range(-20,20)

func _process(delta: float) -> void:
	
	
	

	$Mist.offset.x += 0.09
	
	if Input.is_action_just_pressed("Reset"):
		reload_scene()


func reload_scene():
	get_tree().reload_current_scene()

func finish_level():
	level_completed = true
	GameManager.esgoto_finished = true
	get_tree().change_scene_to_file("res://Scenes/Levels/garagem.tscn")
	


func _on_player_died() -> void:
	$AnimationPlayer.play("End")


func _on_gear_collected() -> void:
	$EndLevelTimer.start()


func _on_end_level_timer_timeout() -> void:
	$AnimationPlayer.play("EndComplete")
