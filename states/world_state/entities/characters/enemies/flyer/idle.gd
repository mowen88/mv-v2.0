
extends State

@export var hover_radius: float = 50.0  
@export var hover_speed: float = 50.0     
@export var waypoint_interval: float = 2.0

var anchor_position: Vector2 = Vector2.ZERO
var target_offset: Vector2 = Vector2.ZERO
var timer: float = 0.0

func enter() -> void:
	owner.get_node("AnimatedSprite2D").play("idle")
	anchor_position = owner.global_position
	_get_new_target_offset()
	timer = 0.0

func update(delta: float) -> void:

	# Periodically pick a new random spot around the anchor to drift toward
	timer += delta
	if timer >= waypoint_interval:
		timer = 0.0
		_get_new_target_offset()

	# Calculate target global position
	var target_position = anchor_position + target_offset
	var current_position = owner.global_position
	
	# Move towards the target offset smoothly
	var direction = current_position.direction_to(target_position)
	var distance = current_position.distance_to(target_position)
	
	if distance > 0.0:
		owner.velocity = owner.velocity.move_toward(direction * hover_speed, hover_speed * delta * 4.0)
	else:
		owner.velocity = owner.velocity.move_toward(Vector2.ZERO, hover_speed * delta * 4.0)
	
	# Set facing as per direction
	owner.move_component.set_facing(sign(owner.velocity.x))
	
	# Keeps tile collisions active so it floats around obstacles naturally
	owner.move_and_slide()

func _get_new_target_offset() -> void:
	
	# Generate a random offset vector within the hover radius
	target_offset = Vector2(
		randf_range(-hover_radius, hover_radius),
		randf_range(-hover_radius, hover_radius)
	)
