
extends State

@export var speed: float = 70.0  

func enter() -> void:
	owner.get_node("AnimatedSprite2D").play("idle")

func update(delta: float) -> void:
	# Safety check
	if not owner.attack_target:
		return
	
	owner.override_facing()
	
	# Chase the player reference
	var direction = owner.global_position.direction_to(owner.attack_target.global_position)
	var target_velocity = direction * speed
	owner.velocity = owner.velocity.move_toward(target_velocity, speed * delta * 6.0)

	# Handle facing
	if abs(owner.velocity.x) > 0.5:
		owner.move_component.facing = int(sign(owner.velocity.x))

	owner.move_and_slide()
