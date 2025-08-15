extends CharacterBody2D

enum STATES {IDLE, ATTACK, HIT, DEATH}

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


func _ready() -> void:
	
	health = max_health
	state_cur = -1
	state_prv = -1
	initialize_idle()


func _physics_process(delta):
	
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
	
	$AttackTimer.start()
	anim_nxt = "Idle"
	state_nxt = STATES.IDLE

func state_idle(delta):
	pass


func initialize_attack():
	
	var attack = randi_range(1,3)
	var animation = "Attack" + str(attack)
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
	
	dead = true
	anim_nxt = "Death"
	state_nxt = STATES.DEATH


func state_death(delta):
	pass


func damage(dmg):
	
	health -= dmg
	if state_cur != 1:
		if !dead:
			if health > 0:
				#initialize_hit()
				pass
			else:
				initialize_death()


func check_player():
	
	
	var area1 = $Icon2/HurtBox
	var area2 = $Icon3/HurtBox
	
	var bodies = area1.get_overlapping_bodies() + area2.get_overlapping_bodies()
	
	for i in bodies:
		if i.is_in_group("Player"):
			i.damage(5)
			i.apply_knockback(Vector2(0,-1).normalized(), PUSH_FORCE,0.01)
	
	


func _on_attack_timer_timeout() -> void:
	$AttackTimer.stop()
	print("attacl")
	initialize_attack()
