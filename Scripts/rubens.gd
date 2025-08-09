extends CharacterBody2D

enum STATES {IDLE, PATROL, HOVER, ATTACK, STUN, HIT, DEATH}

@onready var bomb = preload("res://Scenes/Effects/bomb.tscn")
@onready var explosion_particles = preload("res://Scenes/Effects/explosion.tscn")


@export var HOVER_SPEED : int
@export var SPEED : int
@export var GRAVITY : float

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "Idle"

var dead = false
var stunned = false
var patroling = false
var player_in_range = false
var attacking = false
var can_attack = true

@onready var anim = $AnimationPlayer

var health : int
@export var max_health : int

@export var hover_offset_y : float
var player_pos
var hover_target
var dir = 1


func _ready():
	health = max_health
	state_cur = -1
	state_prv = -1
	state_nxt = STATES.IDLE
	initialize_idle()


func _physics_process(delta):
	
	#print(anim_cur)
	#
	player_pos = get_tree().get_first_node_in_group("Player").global_position
	
	if state_nxt != state_cur:
		
		state_prv = state_cur
		state_cur = state_nxt
	
	if anim_nxt != anim_cur:
		
		anim_cur = anim_nxt
		anim.play(anim_cur)
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.PATROL:
			state_patrol(delta)
		STATES.HIT:
			state_hit(delta)
		STATES.HOVER:
			state_hover(delta)
		STATES.ATTACK:
			state_attack(delta)
		STATES.STUN:
			state_stun(delta)
		STATES.DEATH:
			state_death(delta)
	

func initialize_idle():
	$IdleTImer.start()
	patroling = false
	velocity *= 0
	
	state_nxt = STATES.IDLE
	anim_nxt = "Idle"

func state_idle(delta):
	
	check_player()
	move_and_slide()

func initialize_patrol():
	$PatrolTimer.start()
	patroling = true
	state_nxt = STATES.PATROL
	anim_nxt = "Patrol"

func state_patrol(delta):
	
	$Rotate.scale.x = -dir
	velocity.x = dir * SPEED
	check_player()
	
	move_and_slide()

func initialize_hover():
	patroling = false
	$PatrolTimer.stop()
	$IdleTImer.stop()
	
	hover_target = Vector2(player_pos.x, player_pos.y - hover_offset_y)
	
	state_nxt = STATES.HOVER
	anim_nxt = "Hover"
	

func state_hover(delta):
	
	var direction = (hover_target - global_position).normalized()
	velocity = direction * HOVER_SPEED


	if player_pos:
		if player_pos.x > global_position.x:
			$Rotate.scale.x = -1   
		else:
			$Rotate.scale.x = 1 
	
	# Check if close enough to attack
	if global_position.distance_to(hover_target) < 15:
		initialize_attack()
	
	move_and_slide()

func initialize_attack():
	
	anim_nxt = "Attack"
	state_nxt = STATES.ATTACK
	attacking = true
	can_attack = false
	drop_bomb()
	$AttackTimer.start()

func state_attack(delta):
	if can_attack:
		if !attacking:
			if player_in_range == true:
				initialize_hover()
			else:
				player_in_range = false
				initialize_idle()

func initialize_hit():
	if !dead:
		stunned = true
		can_attack = false
		state_nxt = STATES.HIT
		anim_nxt = "Hit"
		velocity *= 0

func state_hit(delta):
	if can_attack:
		if !stunned:
			
			check_player()
			
			initialize_hover()
			
	
	
	move_and_slide()

func initialize_death():
	if dead == false:
		add_particle()
		velocity *= 0
		dead = true
		state_nxt = STATES.DEATH
		anim_nxt = "Death"

func state_death(delta):
	gravity(delta)
	move_and_slide()


func initialize_stun():
	
	anim_nxt = "Stun"
	velocity *= 0
	state_nxt = STATES.STUN


func state_stun(delta):
	
	move_and_slide()



func damage(dmg):
	
	health -= dmg
	print(health)
	if health > 0:
		initialize_hit()
	else:
		initialize_death()
	


func gravity(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func check_player():
	
	var bodies = $DetectPlayer.get_overlapping_bodies()
	
	for i in bodies:
		if i.is_in_group("Player"):
			player_in_range = true
			if !attacking: 
				initialize_hover()


func drop_bomb():
	
	var b = bomb.instantiate()
	b.position = $Rotate/Bomba.global_position
	get_tree().root.add_child(b)

func set_stunned():
	
	stunned = !stunned
	can_attack = true

func add_particle():
	
	var p = explosion_particles.instantiate()
	p.position = $ParticlePos.global_position
	get_tree().root.add_child(p)



func _on_idle_t_imer_timeout() -> void:
	if patroling:
		$IdleTImer.start()
		$PatrolTimer.stop()
		$IdleTImer.wait_time = 2
		initialize_idle()
	else:
		$IdleTImer.wait_time = 5
		$IdleTImer.start()
		initialize_patrol()


func _on_patrol_timer_timeout() -> void:
	dir = -dir


func _on_attack_timer_timeout() -> void:
	attacking = false
	can_attack = true
	$AttackTimer.stop()
