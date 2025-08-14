extends Control


func _ready() -> void:
	$Journal/Mouse.visible = false
	
	if GameManager.journal_read == true:
		queue_free()

func pause():
	get_tree().paused = true
	



func unpause():
	GameManager.journal_read = true
	get_tree().paused = false


func _on_timer_timeout() -> void:
	$Journal/Mouse.visible = true


func _on_button_button_down() -> void:
	$AnimationPlayer.play("end")
