extends CharacterBody2D

enum STATES {IDLE, PATROL, CHASE,STUN, OFF, HIT, DEATH}

@onready var explosion_particles = preload("res://Scenes/Effects/explosion.tscn")


@export var CHASING_SPEED : int
@export var SPEED : int
@export var GRAVITY : float

@export var KNOCKBACK_FORCE : float
var knockback_timer : float = 0.0
var knockback : Vector2 = Vector2.ZERO

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "Idle"

var dead = false

@onready var anim = $AnimationPlayer

var health : int
@export var max_health : int


var dir = 1

func _ready():
	health = max_health
	state_cur = -1
	state_prv = -1
	state_nxt = STATES.IDLE
	initialize_idle()
	


func _physics_process(delta):
	
	if state_nxt != state_cur:
		
		state_prv = state_cur
		state_cur = state_nxt
	
	if anim_nxt != anim_cur:
		
		anim_cur = anim_nxt
		anim.play(anim_cur)
	
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		
	
		match state_cur:
			
			STATES.IDLE:
				state_idle(delta)
			STATES.PATROL:
				state_patrol(delta)
			STATES.HIT:
				state_hit(delta)
			STATES.CHASE:
				state_chase(delta)
			STATES.STUN:
				state_stun(delta)
			STATES.OFF:
				pass
			STATES.DEATH:
				state_death(delta)
		
		

	
func initialize_idle():
	$PatrolTimer.stop()
	$IdleTimer.start()
	
	velocity *= 0
	state_nxt = STATES.IDLE
	anim_nxt = "Idle"

func state_idle(delta):
	
	gravity(delta)
	for i in $Rotate/DetectPlayer.get_overlapping_bodies():
		if i.is_in_group("Player"):
			initialize_chase()
	move_and_slide()

func initialize_patrol():
	$PatrolTimer.start()
	$IdleTimer.stop()
	state_nxt = STATES.PATROL
	anim_nxt = "Patrol"

func state_patrol(delta):
	
	gravity(delta)
	
	if $Rotate/FloorCheck.is_colliding() or $Rotate/WallCheck.is_colliding():
		$Rotate.scale.x = -dir
		velocity.x = dir * SPEED
	else:
		#velocity.x = dir * SPEED
		velocity *= 0
		dir = -dir
		$Rotate.scale.x = -dir
		velocity.x = dir * SPEED
		#ola
	
	for i in $Rotate/DetectPlayer.get_overlapping_bodies():
		if i.is_in_group("Player"):
			initialize_chase()
	
	
	move_and_slide()

func initialize_chase():
	$PatrolTimer.stop()
	$IdleTimer.stop()
	state_nxt = STATES.CHASE
	anim_nxt = "Chase"

func state_chase(delta):
	
	
	var player_pos
	gravity(delta)

	var player = get_tree().get_first_node_in_group("Player")

	if player:
		player_pos = player.global_position
		
		if player_pos.x > global_position.x:
			$Rotate.scale.x = -1   
		else:
			$Rotate.scale.x = 1 
		# Only modify the X axis, keep Y for gravity/jumping
		var direction_x = sign(player_pos.x - global_position.x) # -1, 0, or 1
		velocity.x = direction_x * CHASING_SPEED

	
	move_and_slide()


func initialize_hit():
	$PatrolTimer.stop()
	$IdleTimer.stop()
	state_nxt = STATES.HIT
	anim_nxt = "Hit"

func state_hit(delta):
	
	gravity(delta)
	move_and_slide()

func initialize_death():
	if dead == false:
		
		velocity *= 0
		add_particle()
		$PatrolTimer.stop()
		$IdleTimer.stop()
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
	
	gravity(delta)
	move_and_slide()



func add_particle():
	
	var p = explosion_particles.instantiate()
	p.position = $ParticlePos.global_position
	get_tree().root.add_child(p)


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


func apply_knockback(direction : Vector2, force : float, knockback_duration : float) -> void:
	
	knockback = direction * force
	knockback_timer = knockback_duration





















func _on_patrol_timer_timeout() -> void:
	dir = -dir

func _on_idle_timer_timeout() -> void:
	$IdleTimer.stop()
	initialize_patrol()


func _on_hit_box_body_entered(body: Node2D) -> void:

	if not dead and body.is_in_group("Player"):
	
		body.damage(5)
		var ab = global_position - body.global_position
		#ab.y = 0
		#if ab.length() != 0:
	#		position += ab.normalized() * KNOCKBACK
		
		apply_knockback(ab.normalized(),KNOCKBACK_FORCE,0.05)
		body.apply_knockback(-ab.normalized(),KNOCKBACK_FORCE,0.01)
		initialize_stun()
		

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if dead == false:
			initialize_chase()


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if dead == false:
			initialize_idle()
