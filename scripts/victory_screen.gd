extends Sprite2D


func _ready() -> void:
    $Buttons/Main.grab_focus()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed('pause'):
        get_tree().change_scene_to_file('res://scenes/main_menu.tscn')

func _on_main_pressed() -> void:
    get_tree().change_scene_to_file('res://scenes/main_menu.tscn')

func _on_credits_pressed() -> void:
    get_tree().change_scene_to_file('res://scenes/credits.tscn')
