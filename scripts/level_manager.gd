extends Node

const LEVELS = ['tutorial', 'level1']

var current_idx: int = 0
var current_level
var unpausable = true
@onready var resume_btn = $PauseCanvas/PauseMenu/VerticalContainer/Resume
@onready var retry_btn = $PauseCanvas/PauseMenu/VerticalContainer/Retry
@onready var next_btn = $PauseCanvas/PauseMenu/VerticalContainer/Next
@onready var exit_btn = $PauseCanvas/PauseMenu/VerticalContainer/Exit
@onready var buttons = [resume_btn, retry_btn, next_btn, exit_btn]


func _ready() -> void:
    var level = load('res://scenes/levels/%s.tscn' % LEVELS[current_idx])
    self.current_level = level.instantiate()
    self.add_child(self.current_level)

func _input(event: InputEvent) -> void:
    if self.unpausable and  event.is_action_pressed('pause'):
        self.set_pause_text('game is paused')
        self.set_pause_buttons()
        self.toggle_pause()
        self.resume_btn.grab_focus()

func reload() -> void:
    self.load_level(self.current_idx)

func load_next() -> void:
    self.current_idx += 1
    if self.current_idx == len(LEVELS):
        print('game won!')
        return
    self.load_level(self.current_idx)

func load_level(idx: int) -> void:
    self.current_level.queue_free()
    var new_scene = load("res://scenes/levels/%s.tscn" % LEVELS[self.current_idx])
    self.current_level = new_scene.instantiate()
    self.add_child(self.current_level)

func toggle_pause() -> void:
    var paused = self.get_tree().paused
    self.get_tree().paused = !paused
    $PauseCanvas/PauseMenu.visible = !paused
    $PauseCanvas/PauseTint.visible = !paused

func death() -> void:
    self.unpausable = false
    self.set_pause_text('i am become death')
    self.set_pause_buttons(false)
    self.toggle_pause()
    self.retry_btn.grab_focus()

func victory() -> void:
    self.unpausable = false
    self.set_pause_text('floor descended')
    self.set_pause_buttons(false, true, true, true)
    self.toggle_pause()
    self.next_btn.grab_focus()

func set_pause_text(text: String):
    $PauseCanvas/PauseMenu/VerticalContainer/Title.set_text(text)

func set_pause_buttons(resume=true, retry=true, next=false, exit=true) -> void:
    for btn in self.buttons:
        btn.hide()
    if resume:
        self.resume_btn.show()
    if retry:
        self.retry_btn.show()
    if next:
        self.next_btn.show()
    if exit:
        self.exit_btn.show()

func _on_next_pressed() -> void:
    self.load_next()
    self.toggle_pause()
    self.unpausable = true

func _on_resume_pressed() -> void:
    self.toggle_pause()

func _on_retry_pressed() -> void:
    self.reload()
    self.toggle_pause()
    self.unpausable = true

func _on_exit_pressed() -> void :
    self.get_tree().paused = false
    self.get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
