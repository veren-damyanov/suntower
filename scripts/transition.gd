extends CanvasLayer

signal animation_done

@onready var animation = $AnimationPlayer


func _on_animation_finished(anim_name: String):
    if anim_name == 'fade_out':
        animation_done.emit()
        self.animation.play('fade_in')
