extends Node2D

@onready var anim = $AnimationPlayer

@onready var max_value = get_tree().get_first_node_in_group("Player").max_health

func _process(delta: float) -> void:
	
	
	
	$CanvasLayer/HUD/HealthBar.value = get_tree().get_first_node_in_group("Player").health
	$Mist.offset.x += 0.09
	
	if Input.is_action_just_pressed("Reset"):
		reload_scene()


func reload_scene():
	get_tree().reload_current_scene()


func _on_player_died() -> void:
	$AnimationPlayer.play("End")
