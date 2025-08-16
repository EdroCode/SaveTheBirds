extends CharacterBody2D

enum STATES {IDLE, ATTACK, HIT, DEATH, STUN}

@onready var anim = $AnimationPlayer

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "Idle"

var dead
var health : int
@export var max_health := 100
@export var PUSH_FORCE : int

var has_taken_damage = false

signal death


func _ready() -> void:
	randomize()
	health = max_health
	state_cur = -1
	state_prv = -1
	initialize_idle()


func _physics_process(delta):
	
	move_and_slide()
	#print(has_taken_damage)
	
	if state_nxt != state_cur:
		
		state_prv = state_cur
		state_cur = state_nxt
	
	if anim_nxt != anim_cur:
		
		anim_cur = anim_nxt
		anim.play(anim_cur)
	
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.ATTACK:
			state_attack(delta)
		STATES.HIT:
			state_hit(delta)
		STATES.DEATH:
			state_death(delta)


func initialize_idle():
	if !dead:
	
		var cooldonw = randf_range(3.2, 4.6)
		$AttackTimer.wait_time = cooldonw
		$AttackTimer.start()
		anim_nxt = "Idle"
		state_nxt = STATES.IDLE

func state_idle(delta):
	pass


func initialize_attack():
	if !dead:
		
		if health > ((max_health * 50)/100):
			
			var attack = randi_range(1,3)
			var animation = "Attack" + str(attack)
			anim_nxt = animation
			state_nxt = STATES.ATTACK
			
			
		else:
			var animation = ""
			var chance = 0.4
			if randf() < chance:
				animation = "Attack4"
			else:
				
				var attack = randi_range(1,3)
				animation = "Attack" + str(attack)
			anim_nxt = animation
			state_nxt = STATES.ATTACK


func state_attack(delta):
	
	pass

func initialize_hit():
	
	anim_nxt = "Hit"
	state_nxt = STATES.HIT

func state_hit(delta):
	pass

func initialize_death():
	emit_signal("death")
	$Explosion.play("explode")
	$Explosion2.play("explode")
	$Explosion3.play("explode")
	$Explosion4.play("explode")
	$AttackTimer.stop()
	dead = true
	anim_nxt = "Death"
	state_nxt = STATES.DEATH


func state_death(delta):
	pass

func initialize_stun():
	
	
	anim_nxt = "Stun"
	state_nxt = STATES.STUN
	
	


func state_stun(delta):
	pass

var growl = false

func damage(dmg):
	
	if health < ((max_health * 50)/100):\
		if !growl:
			$Scream.play()
			growl = true
	
	
	health -= dmg
	has_taken_damage = true
	
	if !dead:
		if health > 0:
			initialize_hit_flash()
		else:
			initialize_death()


func check_player():
	
	
	var area1 = $"Node2D/BossBraço02/HurtBox"
	var area2 = $"Node2D/BossBraço01/HurtBox"
	
	var bodies = area1.get_overlapping_bodies() + area2.get_overlapping_bodies()
	
	for i in bodies:
		if i.is_in_group("Player"):
			i.damage(5)
			i.apply_knockback(Vector2(0,-1).normalized(), PUSH_FORCE,0.01)
	



func try_for_stun():
	
	var chance = 0.4
	if has_taken_damage:
		if randf() < chance:
			initialize_stun()
		else:
			initialize_idle()

func initialize_hit_flash():
	var mat = $Node2D/BossCorpo.material
	mat.set_shader_parameter("flash_enabled", true)
	var t = Timer.new()
	t.wait_time = 0.1
	add_child(t)
	t.start()
	await t.timeout
	t.stop()
	mat.set_shader_parameter("flash_enabled", false)
	



func _on_attack_timer_timeout() -> void:
	$AttackTimer.stop()
	print("attacl")
	initialize_attack()


func _on_hurt_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage(10)
			#i.apply_knockback(Vector2(0,-1).normalized(), PUSH_FORCE,0.01)


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage(8)
		body.apply_knockback(Vector2(-1,0).normalized(), PUSH_FORCE,0.01)
