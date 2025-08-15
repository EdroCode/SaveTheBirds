extends CharacterBody2D
var speed = 5.0
var dir : Vector2


@onready var metal_hit = preload("res://Resources/SFX/Robos/080997_bullet-39735.mp3")
@onready var hit = preload("res://Resources/SFX/Robos/080884_bullet-hit-39872.mp3")

func _ready() -> void:
	
	look_at(get_global_mouse_position())

func _process(delta):
	position += dir * speed
	var col = move_and_collide(velocity)
	if col:
		
		var collider = col.get_collider()
		
		if collider.is_in_group("Enemy"):
			collider.damage(3)
			BulletMetal.stream = hit
			BulletMetal.pitch_scale = randf_range(0.95, 1.45)
			BulletMetal.play()
			
		if collider.is_in_group("Boss"):
			collider.damage(3)
			BulletMetal.stream = hit
			BulletMetal.pitch_scale = randf_range(0.95, 1.45)
			BulletMetal.play()
			#BulletMetal.pitch_scale = randf_range(0.95, 1.45)
			
			#BulletMetal.play()
		if collider.is_in_group("Metal"):
			BulletMetal.stream = metal_hit
			BulletMetal.pitch_scale = randf_range(0.95, 1.45)
			BulletMetal.play()
		
		
		queue_free()
	
	$AudioStreamPlayer2D.volume_db -= 0.8
		


func _on_timer_timeout() -> void:
	queue_free()
