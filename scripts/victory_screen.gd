extends Sprite2D


func _on_main_pressed():
    get_tree().change_scene_to_file('res://scenes/main_menu.tscn')


func _input(event: InputEvent) -> void:
    if event.is_action_pressed('pause'):
        get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
