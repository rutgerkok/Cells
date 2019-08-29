extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $CellDivisionSlider.value = Parameters.fraction_nondividing_cells
    $CellDeathSlider.value = Parameters.max_live_time_nondividing_cells_seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_CellDivisionSlider_value_changed(value):
    Parameters.fraction_nondividing_cells = value


func _on_CellDeathSlider_value_changed(value):
    Parameters.max_live_time_nondividing_cells_seconds = value
