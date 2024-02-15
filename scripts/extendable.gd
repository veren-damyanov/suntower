extends AnimatedSprite2D

var state: int = 0
@export var initial_state: int = 0
@export var channel: int = 0
@onready var tilemap = $"../../TileMap"

func _ready():
    self.set_state(self.initial_state, true)

func set_state(state: int, skip: bool = false) -> void:
    self.state = state
    match state:
        0:
            if skip:
                self.set_animation('down')
                self.set_frame(2)
            else:
                self.play('down')
        1:
            if skip:
                self.set_animation('up')
                self.set_frame(2)
            else:
                self.play('up')
    self.tilemap.update_occluders()

func trigger() -> void:
    match self.state:
        0:
            self.set_state(1)
        1:
            self.set_state(0)
