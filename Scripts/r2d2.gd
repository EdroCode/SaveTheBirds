extends CharacterBody2D

enum STATES {IDLE, PATROL, CHASE, OFF, HIT, DEATH}

@export var SPEED : int
@export var GRAVITY : float
@export var JUMP_POWER : float

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "Idle"

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
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.PATROL:
			state_patrol(delta)
		STATES.HIT:
			state_hit(delta)
		STATES.CHASE:
			state_chase(delta)
		STATES.OFF:
			pass
		STATES.DEATH:
			state_death(delta)
	

func initialize_idle():
	$IdleTimer.start()
	$PatrolTimer.stop()
	velocity *= 0
	state_nxt = STATES.IDLE
	anim_nxt = "Idle"

func state_idle(delta):
	
	gravity(delta)
	
	move_and_slide()

func initialize_patrol():
	$PatrolTimer.start()
	state_nxt = STATES.PATROL
	anim_nxt = "Patrol"

func state_patrol(delta):
	
	gravity(delta)
	
	if $Rotate/FloorCheck.is_colliding():
		$Rotate.scale.x = -dir
		velocity.x = dir * SPEED
	else:
		#velocity.x = dir * SPEED
		velocity *= 0
		dir = -dir
		$Rotate.scale.x = -dir
		velocity.x = dir * SPEED
		#ola
	
	move_and_slide()

func initialize_chase():
	$PatrolTimer.stop()
	state_nxt = STATES.CHASE
	anim_nxt = "Patrol"

func state_chase(delta):
	pass

func initialize_hit():
	$PatrolTimer.stop()
	state_nxt = STATES.HIT
	anim_nxt = "Hit"

func state_hit(delta):
	
	gravity(delta)
	pass
	
	move_and_slide()

func initialize_death():
	
	state_nxt = STATES.DEATH
	anim_nxt = "Death"

func state_death(delta):
	gravity(delta)
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


func _on_patrol_timer_timeout() -> void:
	dir = -dir


func _on_idle_timer_timeout() -> void:
	$IdleTimer.stop()
	initialize_patrol()
