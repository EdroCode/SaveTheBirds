extends Node2D

@onready var bullet = preload("res://Scenes/bullets.tscn")


var can_shot = true
@export var bullets : int
@export var cooldown : float

var on = false

func _ready() -> void:
	$CooldownTimer.wait_time = cooldown
	$LuzLanterna.energy = 0


func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("LeftClick"):
		light_toggle()
	
	look_at(get_global_mouse_position())
	
	check_rotation()


func shot():
	if can_shot:
		if bullets > 0:
			$CooldownTimer.start()
			can_shot = false
			var dir =  get_global_mouse_position() - get_parent().global_position
			spawn_bullet(dir)
		else:
			can_shot = false

func check_rotation():
	

	var angle = fposmod(rotation_degrees, 360)

	#print(angle)

	if angle < 90 or angle > 270:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true


func spawn_bullet(d):
	
	bullets -= 1
	var b = bullet.instantiate()
	b.position = $ShotPos.global_position
	b.dir = d.normalized() 
	get_tree().root.add_child(b)
	

func light_toggle():
	on = !on
	if on:
		$LuzLanterna.energy = 1.95
	else:
		$LuzLanterna.energy = 0
	
	

func _on_cooldown_timer_timeout() -> void:
	can_shot = true
	$CooldownTimer.stop()
