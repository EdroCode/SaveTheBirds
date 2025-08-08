extends CharacterBody2D

enum STATES {IDLE, RUN, ATTACK, JUMP, FALL, GROUND, HIT, DEATH}

@export var SPEED : int
@export var GRAVITY : float
@export var JUMP_POWER : float
@export var DASH_SPEED : int

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "Idle"

@export var has_gun = true

@onready var anim = $AnimationPlayer

var health : int
@export var max_health : int

var dead = false


func _ready():
	health = max_health
	state_cur = -1
	state_prv = -1
	state_nxt = STATES.IDLE
	initialize_idle()
	
	if has_gun:
		$Arma.visible = true
	else:
		$Arma.visible = false

func _physics_process(delta):
	
	#print(state_cur)
	
	if state_nxt != state_cur:
		
		state_prv = state_cur
		state_cur = state_nxt
	
	if anim_nxt != anim_cur:
		
		anim_cur = anim_nxt
		anim.play(anim_cur)
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.RUN:
			state_run(delta)
		STATES.JUMP:
			state_jump(delta)
		STATES.HIT:
			state_hit(delta)
		STATES.DEATH:
			state_death(delta)
	
	if Input.is_action_just_pressed("Shot"):
		if has_gun:
			$Arma.shot()

func initialize_idle():
	
	state_nxt = STATES.IDLE
	anim_nxt = "Idle"
	velocity *= 0

func state_idle(delta):
	
	gravity(delta)
	
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		initialize_run()
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			initialize_jump()
	
	move_and_slide()

func initialize_run():
	
	state_nxt = STATES.RUN
	anim_nxt = "Run"

func state_run(delta):
	
	gravity(delta)
	
	var dir := Input.get_axis("Left", "Right")
	
	if dir != 0:
		velocity.x = dir * SPEED
		$Rotate.scale.x = dir
	else:
		velocity.x = 0
		#$Rotate.scale.x = 1
		initialize_idle()
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			initialize_jump()
	
	if $Rotate/WallCheck.is_colliding():
		if is_on_floor():
			var col = $Rotate/WallCheck.get_collider()
			if col.is_in_group("Subir"):
				position -= Vector2(0,15)
	
	if Input.is_action_just_pressed("Dash"):
		dash(dir)
	
	move_and_slide()


func initialize_jump():
	
	state_nxt = STATES.JUMP
	anim_nxt = "Jump"
	
	velocity.y -= JUMP_POWER

func state_jump(delta):
	
	gravity(delta)
	var dir := Input.get_axis("Left", "Right")
	
	if is_on_floor():
		if dir:
			initialize_run()
		else:
			initialize_idle()
	else:
		if dir != 0:
			velocity.x = dir * SPEED
			$Rotate.scale.x = dir
		
		if Input.is_action_just_pressed("Dash"):
			dash(dir)
	
	move_and_slide()



func initialize_hit():
	state_nxt = STATES.HIT
	anim_nxt = "Hit"

func state_hit(delta):
	
	pass
	pass

func initialize_death():
	state_nxt = STATES.DEATH
	anim_nxt = "Dead"
	has_gun = false
	dead = true
	$Arma.queue_free()
	velocity *= 0


func state_death(delta):
	#print('IM DEAD')
	gravity(delta)
	move_and_slide()
	

func dash(dir):
	print("Dash")
	velocity.x += dir * DASH_SPEED

func damage(dmg):
	
	health -= dmg
	if !dead:
		if health > 0:
			initialize_hit()
		else:
			initialize_death()


func gravity(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func play_walk_sound():
	
	pass
