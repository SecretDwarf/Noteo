extends CanvasLayer
@onready var note = $%Note;

@export var sixteenth: Texture2D
@export var eighth: Texture2D
@export var quarter: Texture2D
@export var half: Texture2D

var note_array = [sixteenth, eighth, quarter, half]

func RNG(min, max):
	var random_number = randi() % (max - min + 1) + min
	return random_number

func newNote(CurrentNote){
	RNG(1, 16)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	newNote(currentNote)
	note.texture_changed(note_array.randf_range(1, note_array.length))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	var pianoInput = '?'
	if (pianoInput == currentNote):
		note.texture_changed(note_array.randf_range(1, note_array.length))
		newNote(currentNote)
