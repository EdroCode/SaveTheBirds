extends CharacterBody2D

enum STATES {IDLE, PATROL, OFF}

@onready var explosion_particles = preload("res://Scenes/Effects/explosion.tscn")


@export var SPEED : int
@export var GRAVITY : float
@export var KNOCKBACK : float

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
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.PATROL:
			state_patrol(delta)
		STATES.OFF:
			state_off(delta)
	

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
	$IdleTimer.stop()
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
	
	if $Rotate/WallCheck.is_colliding() == true:
		var col = $Rotate/WallCheck.get_collider()
		
		if col.is_in_group("Wall"):
			dir = -dir
			$Rotate.scale.x = -dir
			velocity.x = dir * SPEED
	
	move_and_slide()

func initialize_off():
	$OffTimer.start()
	$IdleTimer.stop()
	$PatrolTimer.stop()
	velocity *= 0
	state_nxt = STATES.OFF
	anim_nxt = "Off"

func state_off(delta):
	
	gravity(delta)
	move_and_slide()


func gravity(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func _on_patrol_timer_timeout() -> void:
	dir = -dir


func _on_idle_timer_timeout() -> void:
	$IdleTimer.stop()
	initialize_patrol()


func _on_off_timer_timeout() -> void:
	$OffTimer.stop()
	initialize_idle()
