extends Node2D

@onready var anim = $AnimationPlayer
@onready var level_completed = false

func _ready() -> void:
	
	for bird in get_tree().get_nodes_in_group("birds"):
		if GameManager.birds_collected.has(bird.bird_id):
			bird.queue_free()



func _process(delta: float) -> void:
	
	
	
	$Mist.offset.x += 0.09
	
	if Input.is_action_just_pressed("Reset"):
		$AnimationPlayer.play("End")


func reload_scene():
	get_tree().reload_current_scene()

func finish_level():
	#level_completed = true
	#GameManager.cidade_finished = true
	get_tree().change_scene_to_file("res://Scenes/Levels/boss_fight_cutscene.tscn")
	pass


func _on_player_died() -> void:
	$AnimationPlayer.play("End")


func _on_end_level_timer_timeout() -> void:
	$AnimationPlayer.play("EndComplete")


func _on_cables_collected() -> void:
	$EndLevelTimer.start()


func _on_cabos_body_entered(body: Node2D) -> void:
	$Cabos.visible = false
	$AnimationPlayer.play("EndComplete")
