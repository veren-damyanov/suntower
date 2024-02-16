extends AnimatedSprite2D


const COOLDOWN = 0.3

var state:int = 0  # 0 is down, 1 is up
var elapsed: float = 0
@export var channel: int = 0
@onready var extendables = $"../../Extendables"
@onready var rumble_audio = $Rumble

func _physics_process(delta: float) -> void:
    if self.elapsed < COOLDOWN:
        self.elapsed += delta

func toggle() -> void:
    if self.elapsed < COOLDOWN:
        return
    self.elapsed = 0
    self.extendables.trigger(self.channel)
    self.rumble_audio.play()
    match self.state:
        0:
            self.play('right')
            self.state = 1
        1:
            self.play('left')
            self.state = 0
