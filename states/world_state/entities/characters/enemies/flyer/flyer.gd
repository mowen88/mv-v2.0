
class_name Flyer

extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FiniteStateMachine = $FiniteStateMachine
@onready var move_component: MoveComponent = $MoveComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var knockback_component: KnockbackComponent = $KnockbackComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var squash_stretch_component: SquashStretchComponent = $SquashStretchComponent
@onready var vision_area: Area2D = $PlayerDetectionRadius
@onready var lose_player_area: Area2D = $LosePlayerRadius

var attack_target: Node2D = null

func _ready() -> void:
	health_component.died.connect(_on_death)
	vision_area.body_entered.connect(_on_body_entered)
	lose_player_area.body_exited.connect(_on_body_exited)
	
	fsm.initialize()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player")\
	and fsm.current_state.name == "Idle"\
	and health_component.current_health > 0:
		attack_target = body
		fsm.change_state("Chase")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player")\
	and fsm.current_state.name == "Chase"\
	and health_component.current_health > 0:
		fsm.change_state("Idle")
			
func _on_death() -> void:
	set_collision_mask_value(2, false)
	hitbox_component.monitoring = false
	hurtbox_component.monitorable = false
	
	fsm.change_state("Death")


#Testing with input - to be deleted for shipping !!!!
func _unhandled_input(event: InputEvent) -> void:

	# Test input
	if event.is_action_pressed("shoot"):
		#health_component.damage(1)
		#print(health_component.current_health)
		pass
#
#func _process(delta: float) -> void:
	#print(fsm.current_state.name)
	#
	
