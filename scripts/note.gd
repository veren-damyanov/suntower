extends Sprite2D

var on = false
@export var text = "placeholder"
@onready var manager = $"../../../"
@onready var note_canvas = $"../../../NoteCanvas"
@onready var note_label = $"../../../NoteCanvas/NoteText"
@onready var player = $"../../Player"


func toggle() -> void:
    self.note_label.set_text(self.text)
    self.note_canvas.visible = !self.note_canvas.visible
    self.player.reading = !self.player.reading
    self.manager.just_read = true
    self.manager.unpausable = !self.manager.unpausable
    self.on = !self.on

func _input(event: InputEvent) -> void:
    if self.on and event.is_action_pressed('pause'):
        self.toggle()
