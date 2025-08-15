extends Node2D


func _ready() -> void:
	
	$CanvasLayer/BossHealthBar/ProgressBar.value = $Boss.max_health


func _process(delta: float) -> void:
	
	$CanvasLayer/BossHealthBar/ProgressBar.value = $Boss.health
