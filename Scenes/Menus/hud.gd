extends Control


func _on_player_damaged() -> void:
	print( get_tree().get_first_node_in_group("Player").health)
	$HealthBar.value = get_tree().get_first_node_in_group("Player").health
