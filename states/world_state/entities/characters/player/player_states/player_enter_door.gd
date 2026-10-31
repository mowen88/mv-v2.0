extends State

func enter() -> void:
	owner.animated_sprite.play("climb")
	# Clear heal particles if swiped up over the heal button
	owner.heal_particles.emitting = false
	
	# Fade the player out
	var tween = create_tween()
	tween.tween_property(owner.animated_sprite, "modulate:a", 0.0, 0.75)
