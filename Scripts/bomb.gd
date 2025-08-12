extends CharacterBody2D

@export var GRAVITY = 100
@onready var bomb_explosion = preload("res://Scenes/Effects/kaboomVerde.tscn")

func _process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	
	var col = move_and_collide(velocity)
	if col:
		var collider = col.get_collider()
		
		#print("CABOOM")
		
		
		
		explode()
		

func explode():
	
	var bodies = $ExplosionArea.get_overlapping_bodies()
	
	var b = bomb_explosion.instantiate()
	b.position = global_position
	get_tree().root.add_child(b)
	#print(bodies)
	for i in bodies:
		if i.is_in_group("Player"):
			i.damage(10)
		if i.is_in_group("Enemy"):
			#print("GOTCHU")
			i.damage(10)
	
	
	
	queue_free()
