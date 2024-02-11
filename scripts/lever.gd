extends AnimatedSprite2D


const COOLDOWN = 1

var state:int = 0  # 0 is down, 1 is up
var elapsed: float = 0
@export var channel: int = 0
@onready var extendables = $"../../Extendables"

func _physics_process(delta: float) -> void:
    if self.elapsed < COOLDOWN:
        self.elapsed += delta

func pull() -> void:
    if self.elapsed < COOLDOWN:
        return
    self.elapsed = 0
    self.extendables.trigger(self.channel)
    match self.state:
        0:
            self.play('down')
            self.state = 1
        1:
            self.play('up')
            self.state = 0
