extends State

@export var knockback_force: float = 100.00
@export var stun_duration: float = 0.2

var timer: float = 0.0

func enter() -> void:
	timer = stun_duration
	# Play a "hit" animation if you have one
	owner.get_node("AnimatedSprite2D").play("idle")
	owner.vision_area.monitoring = false
	owner.lose_player_area.monitoring = false

func physics_update(delta: float) -> void:
	# Increment timer
	timer -= delta
	
	if timer <= 0:
		fsm.change_state("Chase")
