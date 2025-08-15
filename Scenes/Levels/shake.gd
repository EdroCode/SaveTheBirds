extends Node2D

@export var cam: Camera2D

var noise := FastNoiseLite.new()
var noise_time := 0.0

var shake_intensity := 0.0
var shake_duration := 0.0
var shake_decay := 1.0


func _ready() -> void:
	
	
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.8   # lower = slower shake movement



func _process(delta: float) -> void:
	if shake_duration > 0:
		shake_duration -= delta
		noise_time += delta * 60.0  # how quickly we move through noise space

		var offset_x = noise.get_noise_2d(noise_time, 0.0) * shake_intensity
		var offset_y = noise.get_noise_2d(0.0, noise_time + 100.0) * shake_intensity

		cam.offset = Vector2(offset_x, offset_y)

		# fade out shake
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		cam.offset = Vector2.ZERO
	
	

func start_shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration
	shake_decay = intensity / duration


func _on_player_shot() -> void:
	start_shake(2, 0.2)
