extends TextureProgressBar





func _ready() -> void:
	max_value = get_tree().get_first_node_in_group("Player").max_health
	visible = false


func _process(delta: float) -> void:
	
	
	pass
	


func _on_value_changed(value: float) -> void:
	visible = true
	$Timer.start()


func _on_timer_timeout() -> void:
	$Timer.stop()
	visible = false
