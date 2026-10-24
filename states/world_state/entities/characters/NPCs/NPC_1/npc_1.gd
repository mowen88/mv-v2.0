class_name NPC1
extends CharacterBody2D

#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FiniteStateMachine = $FiniteStateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_component: InteractionComponent = $InteractionComponent
@onready var persistence_component: PersistenceComponent = $PersistenceComponent

var has_spoken: bool = false
var player: CharacterBody2D = null

func _ready() -> void:
	interaction_component.interact.connect(_on_interacted)
	persistence_component.persistent_state_loaded.connect(_on_persistent_state_loaded)
	player = get_tree().root.get_node_or_null("WorldState/Player")

func _physics_process(_delta: float) -> void:
	var player_is_right = player.global_position.x > global_position.x
	animated_sprite.flip_h = not player_is_right

func _on_interacted(_player: CharacterBody2D) -> void:
	
	var base_id = persistence_component.persistent_id
	var spoken_key = base_id + "_spoken"
	var dialogue_key: String
	
	if has_spoken and DialogueData.DATABASE.has(spoken_key):
		dialogue_key = spoken_key
	else:
		var initial_key = base_id + "_initial"
		if DialogueData.DATABASE.has(initial_key):
			dialogue_key = initial_key 
		else:
			dialogue_key = base_id
	
	SignalBus.play_cutscene.emit(dialogue_key)
	
	if not has_spoken:
		persistence_component.add_to_peristent_list()
		has_spoken = true
	
	

func _on_persistent_state_loaded(_pos: Vector2) -> void:
	# This triggers on startup if the ID is already in persistent list
	has_spoken = true
	
	
