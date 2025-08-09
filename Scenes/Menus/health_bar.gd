extends TextureProgressBar





func _ready() -> void:
	max_value = get_tree().get_first_node_in_group("Player").max_health


func _process(delta: float) -> void:
	
	
	value = get_tree().get_first_node_in_group("Player").health
	
