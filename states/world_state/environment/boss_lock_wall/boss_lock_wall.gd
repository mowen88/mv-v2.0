extends Node2D

@export var open_sound: AudioStream
@onready var walls: Node2D = $walls
@onready var trigger_area: Area2D = $Area2D
@onready var persistence_component: PersistenceComponent = $PersistenceComponent

func _ready() -> void:
	_is_active(false)
	SignalBus.open_boss_locks.connect(_on_open_locks)
	persistence_component.persistent_state_loaded.connect(_on_persistent_state_loaded)
	trigger_area.body_entered.connect(_on_body_entered)

func _is_active(state: bool) -> void:
	for child in walls.get_children():
		if child is StaticBody2D:
			for subchild in child.get_children():
				if subchild is CollisionShape2D:
					subchild.set_deferred("disabled", not state)
				if subchild is GPUParticles2D:
					subchild.emitting = state
					subchild.visible = state
			
func _on_open_locks() -> void:
	persistence_component.add_to_peristent_list()
	SignalBus.flash_screen.emit(Color(255,255,255), 1.0)
	AudioManager.play_sfx(open_sound)
	_is_active(false)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("colllided")
		_is_active(true)

func _on_persistent_state_loaded(_pos: Vector2) -> void:
	queue_free()
