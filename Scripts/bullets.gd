extends CharacterBody2D
var speed = 5.0
var dir : Vector2


func _ready() -> void:
	
	look_at(get_global_mouse_position())

func _process(delta):
	position += dir * speed
	var col = move_and_collide(velocity)
	if col:
		
		var collider = col.get_collider()
		
		if collider.is_in_group("Enemy"):
			collider.damage(3)
		if collider.is_in_group("Boss"):
			collider.damage(3)
		
		queue_free()
	
	$AudioStreamPlayer2D.volume_db -= 0.8
		


func _on_timer_timeout() -> void:
	queue_free()
