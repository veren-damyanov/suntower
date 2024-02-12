extends AnimatedSprite2D

const FLOOR_TILES = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)]
const EXIT_TILES = [Vector2i(1, 2)]

var lit = false
var has_key = false
var exit_open = false
@onready var pushables = $"../Pushables"
@onready var interactables = $"../Interactables"
@onready var tilemap = $"../TileMap"
@onready var key = $"../Key"
@onready var door = $"../Door"


func _collect_occluder_objects() -> Array[Vector2i]:
    return [Vector2i(0, 0)]

func _input(event: InputEvent) -> void:
    #if !event.is_pressed:
        #return
    if event.is_action_pressed("interact"):
        self.interact()
        return
    if event.is_action_pressed("left"):
        self.move(-1, 0)
        return
    if event.is_action_pressed("right"):
        self.move(1, 0)
        return
    if event.is_action_pressed("up"):
        self.move(0, -1)
        return
    if event.is_action_pressed("down"):
        self.move(0, 1)
        return

func _move_pushable(object: Sprite2D, dx: int, dy: int) -> bool:
    var object_pos = self.tilemap.local_to_map(object.get_position())
    var push_to = Vector2(object_pos.x + dx, object_pos.y + dy)
    var tile_id = self.tilemap.get_cell_atlas_coords(0, push_to)
    if tile_id in FLOOR_TILES:
        self.update_visual(object, push_to)
        self.tilemap.update_occluders()
        return true
    return false

func move(dx: int, dy: int) -> void:
    var current_pos = self.tilemap.local_to_map(self.position)
    var move_to = Vector2i(current_pos.x + dx, current_pos.y + dy)
    var tile_id = self.tilemap.get_cell_atlas_coords(0, move_to)
    if self.exit_open and tile_id in EXIT_TILES:
        self._move_player(move_to)
        self.death()
        return
    if tile_id in FLOOR_TILES:
        for object in self.pushables.all():
            var object_pos = self.tilemap.local_to_map(object.get_position())
            if object_pos != move_to:
                continue
            if self._move_pushable(object, dx, dy):
                self._move_player(move_to)
            return
        self._move_player(move_to)

func interact() -> void:
    var player_pos = self.tilemap.local_to_map(self.position)
    for object in self.interactables.get_children():
        var object_pos = self.tilemap.local_to_map(object.get_position())
        if object.is_in_group('key'):
            if !self.has_key and player_pos == object_pos:
                self.has_key = true
                object.queue_free()
        object_pos = Vector2i(object_pos.x, object_pos.y + 1)
        if object.is_in_group('door'):
            if !self.exit_open and self.has_key and player_pos == object_pos:
                self.exit_open = true
                object.play('open')
        if object.is_in_group('lever'):
            if player_pos == object_pos:
                object.pull()

func _move_player(new_position):
    self.update_visual(self, new_position)
    if self.tilemap.is_object_lit(self):
        if lit:
            self.death()
        else:
            self.lit = true
    else:
        self.lit = false

func update_visual(object: Node2D, new_position: Vector2i) -> void:
    object.set_position(self.tilemap.map_to_local(new_position))

func death():
    self.get_tree().paused = true
    print('DEATH')
