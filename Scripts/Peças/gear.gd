extends Area2D

signal collected


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.initialize_show("gear")
		$AnimationPlayer.play("Collect")
		GameManager.PECAS_COLETADAS += 1
		emit_signal("collected")

func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
