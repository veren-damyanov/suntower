extends Area2D

@export var title: String = 'p'
@export var level: int = 0


func _ready():
    $Title.set_text(self.title)

func _on_mouse_entered():
    $Background.visible = true

func _on_mouse_exited():
    $Background.visible = false

func _on_input_event(viewport, event, shape_idx):
    if event.is_action_pressed('mouse_left'):
        Global.level_idx = self.level
        get_tree().change_scene_to_file('res://scenes/level_manager.tscn')
