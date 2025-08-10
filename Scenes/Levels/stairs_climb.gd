extends Area2D


@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body: Node2D) -> void:
	player.can_climb = true


func _on_body_exited(body: Node2D) -> void:
	player.can_climb = false
	

	player.initialize_idle()
