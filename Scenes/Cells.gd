extends Node2D

const DIVIDING_CELL = preload("res://Scenes/DividingCell.tscn")
const NON_DIVIDING_CELL = preload("res://Scenes/NonDividingCell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    for child in get_children():
        if self._has_signal(child, "divide"):
            child.connect("divide", self, "_on_cell_divide")

func _has_signal(child, signal_name):
    for signal_dict in child.get_signal_list():
        if signal_dict["name"] == signal_name:
            return true
    return false

func _on_cell_divide(position: Vector2):
    var daughter1;
    var daughter2;
    if randf() > Parameters.fraction_nondividing_cells:
        daughter1 = DIVIDING_CELL.instance()
        daughter1.connect("divide", self, "_on_cell_divide")
        daughter2 = DIVIDING_CELL.instance()
        daughter2.connect("divide", self, "_on_cell_divide")
    else:
        daughter1 = NON_DIVIDING_CELL.instance()
        daughter2 = NON_DIVIDING_CELL.instance()
    daughter1.position = Vector2(position.x - 5, position.y)
    self.add_child(daughter1)
    daughter2.position = Vector2(position.x + 5, position.y)
    self.add_child(daughter2)
