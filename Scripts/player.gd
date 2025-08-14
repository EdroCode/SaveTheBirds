extends CharacterBody2D

enum STATES {IDLE, RUN, ATTACK, JUMP, DASH, FALL, GROUND, HIT, DEATH, STAIRS, SHOWITEM}

@export var SPEED : int
@export var GRAVITY : float
@export var JUMP_POWER : float
@export var DASH_SPEED : int
@export var dash_cooldown_duration := 3

var knockback_timer : float = 0.0
var knockback : Vector2 = Vector2.ZERO

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "Idle"

@export var has_gun = true
@export var ui_active = true


@onready var anim = $AnimationPlayer

var health : int
@export var max_health : int

var dead = false

var dash_cooldown_elapsed := 0.0
var can_dash := true
var can_climb := false
var climbing := false


signal died
signal damaged

func _ready():
	health = max_health
	state_cur = -1
	state_prv = -1
	state_nxt = STATES.IDLE
	
	$DashCooldown.wait_time = dash_cooldown_duration
	initialize_idle()
	
	if ui_active:
		$CanvasLayer/HUD.visible = true
	else:
		$CanvasLayer/HUD.visible = false
		
	
	
	
	if has_gun:
		$Arma.visible = true
	else:
		$Arma.queue_free()

func _process(delta: float) -> void:
	
	#print(can_climb)
	
	if not can_dash:
		dash_cooldown_elapsed += delta
		var progress = 100 * (1.0 - dash_cooldown_elapsed / dash_cooldown_duration)
		$CanvasLayer/HUD/DashClock/ProgressBar.value = clamp(progress, 0, 100)

func _physics_process(delta):
	
	#print(state_cur)
	
	
	
	if state_nxt != state_cur:
		
		state_prv = state_cur
		state_cur = state_nxt
	
	if anim_nxt != anim_cur:
		
		anim_cur = anim_nxt
		anim.play(anim_cur)
	
	#print(can_climb)
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
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
			STATES.DASH:
				state_dash(delta)
			STATES.STAIRS:
				state_stairs(delta)
			STATES.SHOWITEM:
				state_show(delta)
	
	

	
	if Input.is_action_just_pressed("Shot"):
		if has_gun:
			$Arma.shot()

func initialize_idle():
	climbing = false
	can_climb = false
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
	
	if Input.is_action_just_pressed("ActionE"):
		
		if climbing == false:
			if can_climb:
				print('Subindo escada')
				initialize_stairs()
	move_and_slide()

func initialize_run():
	climbing = false
	can_climb = false
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

		initialize_dash(dir)
	
	
	if Input.is_action_just_pressed("ActionE"):
		
		if climbing == false:
			if can_climb:
				print('Subindo escada')
				initialize_stairs()
	move_and_slide()


func initialize_jump():
	
	state_nxt = STATES.JUMP
	anim_nxt = "Jump"
	var pitch = randf_range(0.712, 1.145)
	$GruntSound.pitch_scale = pitch
	$GruntSound.play()
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
			#gravity(delta)
			
			$Rotate.scale.x = dir
		
		if Input.is_action_just_pressed("Dash"):
			initialize_dash(dir)
	
	move_and_slide()



func initialize_hit():
	$HurtSound.play()
	state_nxt = STATES.HIT
	anim_nxt = "Hit"

func state_hit(delta):
	move_and_slide()
	pass
	pass

func initialize_death():
	health = 0
	anim_nxt = "Dead"
	has_gun = false
	dead = true
	$Arma.queue_free()
	velocity *= 0
	emit_signal('died')
	state_nxt = STATES.DEATH


func state_death(delta):
	#print('IM DEAD')
	gravity(delta)
	move_and_slide()
	velocity *= 0
	

func initialize_dash(dir):
	if can_dash:
		can_dash = false
		$DashCooldown.start()
		$CanvasLayer/HUD/DashClock/ProgressBar.value = 100
		$CanvasLayer/HUD/DashClock/ProgressBar.visible = true
		anim_nxt = "Dash"
		
		print("Dash")
		var a = randi_range(0,1)
		var pitch = randf_range(0.912, 1.145)
		
		if a == 1:
			dashSound.stream = dash1
			dashSound.pitch_scale = pitch
			dashSound.play()
		else:
			dashSound.stream = dash2
			dashSound.pitch_scale = pitch
			dashSound.play()
			
			
		velocity.x += $Rotate.scale.x * DASH_SPEED
		
		state_nxt = STATES.DASH
	

func state_dash(delta):
	
	pass

func initialize_stairs():
	climbing = true
	can_climb = false
	anim_nxt = "Stairs"
	state_nxt = STATES.STAIRS


func state_stairs(delta):
	
	var dir := Input.get_axis("Subir", "Descer")
	
	
	if dir != 0:
		velocity.y = dir * SPEED
		velocity.x = 0
		$AnimationPlayer.play("Stairs")
	else:
		velocity.y = 0
		velocity.x = 0
		$AnimationPlayer.stop()
	
	if Input.is_action_just_pressed("ActionE"):
		
		print('Desacendo escada')
		
		climbing = false
		
		initialize_idle()
	
	
	
	move_and_slide()


# PECAS

@onready var gear = preload("res://Artwork/Sprites/Other/PEÇA01.png")
@onready var lights = preload("res://Artwork/Sprites/Other/PEÇA02.png")
@onready var cabos = preload("res://Artwork/Sprites/Other/PEÇA03.png")

func initialize_show(peca):
	$Arma.queue_free()
	has_gun = false
	
	
	if peca == "gear":
		$"Peça01".texture = gear
		$"Peça01".position = $ShowPosition.position
	elif peca == "eyes":
		$"Peça01".texture = lights
		$"Peça01".position = $ShowPosition.position
	elif peca == "cabos":
		$"Peça01".texture = cabos
		$"Peça01".position = $ShowPosition.position
	
	
	anim_nxt = "Show"
	state_nxt = STATES.SHOWITEM
	velocity *= 0
	
	

func state_show(delta):
	gravity(delta)
	velocity.x *= 0
	move_and_slide()





func damage(dmg):
	if state_cur != 10:
		health -= dmg
		emit_signal("damaged")
		if !dead:
			if health > 0:
				initialize_hit()
			else:
				initialize_death()


func gravity(delta):
	
	
	velocity.y += GRAVITY * delta

func apply_knockback(direction : Vector2, force : float, knockback_duration : float) -> void:
	
	knockback = direction * force
	knockback_timer = knockback_duration










@onready var foot1 = preload("res://Resources/SFX/footstep1.wav")
@onready var foot2 = preload("res://Resources/SFX/footstep2.wav")

@onready var dash1 = preload("res://Resources/SFX/dash1.wav")
@onready var dash2 = preload("res://Resources/SFX/dash2.wav")

@onready var step1 = preload("res://Resources/SFX/step.wav")
@onready var step2 = preload("res://Resources/SFX/step2.wav")

@onready var dashSound = $DashSound




func play_walk_sound():
	var a = randi_range(0,1)
	var pitch = randf_range(0.912, 1.145)
	
	
	if a == 1:
		$WalkAudioStreamPlayer2D.stream = foot1
		$WalkAudioStreamPlayer2D.pitch_scale = pitch
		$WalkAudioStreamPlayer2D.play()
	else:
		$WalkAudioStreamPlayer2D.stream = foot2
		$WalkAudioStreamPlayer2D.pitch_scale = pitch
		$WalkAudioStreamPlayer2D.play()
		



func play_step_sound():
	var a = randi_range(0,1)
	var pitch = randf_range(0.912, 1.145)
	
	
	if a == 1:
		$StepSound.stream = step1
		$StepSound.pitch_scale = pitch
		$StepSound.play()
	else:
		$StepSound.stream = step2
		$StepSound.pitch_scale = pitch
		$StepSound.play()
		

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	dash_cooldown_elapsed = 0.0  
	$CanvasLayer/HUD/DashClock/ProgressBar.visible = false
	$CanvasLayer/HUD/DashClock/ProgressBar.value = 0



func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Acid"):
		$Splash.play()
		initialize_death()



func _on_hit_box_body_exited(body: Node2D) -> void:
	pass
