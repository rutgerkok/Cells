extends Node2D

signal game_over  # Used when the game died
signal game_modified  # Used when the user changes some parameter, ablates a cell, etc.

const DIVIDING_CELL = preload("res://Scenes/DividingCell.tscn")
const NON_DIVIDING_CELL = preload("res://Scenes/NonDividingCell.tscn")


var _previous_fraction_nondividing_cells = 0
var _previous_max_live_time_nondividing_cells_seconds = 0
var _previous_child_count = 0
var _game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
    Parameters.game_speed = 1
    
    _previous_fraction_nondividing_cells = Parameters.fraction_nondividing_cells
    _previous_max_live_time_nondividing_cells_seconds = Parameters.max_live_time_nondividing_cells_seconds
    _previous_child_count = self.get_child_count()
    
    for child in get_children():
        if self._has_signal(child, "divide"):
            child.connect("divide", self, "_on_cell_divide")
        if self._has_signal(child, "out_of_bounds"):
            child.connect("out_of_bounds", self, "_on_cell_out_of_bounds")
        if self._has_signal(child, "cell_ablation"):
            child.connect("cell_ablation", self, "_on_cell_ablation")

func _has_signal(child, signal_name):
    for signal_dict in child.get_signal_list():
        if signal_dict["name"] == signal_name:
            return true
    return false

func _process(delta):
    # Called every step
    
    # Check for changed parameters
    if _previous_fraction_nondividing_cells != Parameters.fraction_nondividing_cells \
            or _previous_max_live_time_nondividing_cells_seconds != Parameters.max_live_time_nondividing_cells_seconds:
        _previous_fraction_nondividing_cells = Parameters.fraction_nondividing_cells
        _previous_max_live_time_nondividing_cells_seconds = Parameters.max_live_time_nondividing_cells_seconds
        emit_signal("game_modified")
        
    # Check if there are still cells
    var child_count = self.get_child_count()
    if child_count == 0 and self._previous_child_count != 0:
        if not self._game_over:
            emit_signal("game_over")
            self._game_over = true
    self._previous_child_count = child_count
    
    
func _on_cell_out_of_bounds():
    if not self._game_over:
        emit_signal("game_over")
        self._game_over = true

func _on_cell_divide(position: Vector2):
    var daughter1;
    var daughter2;
    if randf() > Parameters.fraction_nondividing_cells:
        daughter1 = DIVIDING_CELL.instance()
        daughter1.connect("divide", self, "_on_cell_divide")
        daughter1.connect("out_of_bounds", self, "_on_cell_out_of_bounds")
        daughter1.connect("cell_ablation", self, "_on_cell_ablation")
        daughter2 = DIVIDING_CELL.instance()
        daughter2.connect("divide", self, "_on_cell_divide")
        daughter2.connect("out_of_bounds", self, "_on_cell_out_of_bounds")
        daughter2.connect("cell_ablation", self, "_on_cell_ablation")
    else:
        daughter1 = NON_DIVIDING_CELL.instance()
        daughter1.connect("out_of_bounds", self, "_on_cell_out_of_bounds")
        daughter1.connect("cell_ablation", self, "_on_cell_ablation")
        daughter2 = NON_DIVIDING_CELL.instance()
        daughter2.connect("out_of_bounds", self, "_on_cell_out_of_bounds")
        daughter2.connect("cell_ablation", self, "_on_cell_ablation")
    daughter1.position = Vector2(position.x - 5, position.y)
    self.add_child(daughter1)
    daughter2.position = Vector2(position.x + 5, position.y)
    self.add_child(daughter2)

func _on_cell_ablation():
    # Called by ohter nodes using connections
    emit_signal("game_modified")
