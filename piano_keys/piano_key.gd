class_name PianoKey
extends Control

var pitch_scale: float

@onready var key: ColorRect = $Key
@onready var start_color: Color = key.color
@onready var color_timer: Timer = $ColorTimer


# Function to get the note name from a pitch index
func get_white_key_note_name_from_pitch(pitch_index):
	# Define an array to map pitch indexes to note names
	const note_names = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"]
	
	# Calculate the relative position within the octave (12 notes)
	var relative_position = pitch_index % 12
	
	# Get the note name for the given pitch index
	var note_name = note_names[relative_position]
	
	# Check if the note_name is one of 'A', 'B', 'C', 'D', 'E', 'F', or 'G'
	if note_name in ['A', 'B', 'C', 'D', 'E', 'F', 'G']:
		return note_name
	else:
		# it's a black key
		pass

func setup(pitch_index: int):
	name = "PianoKey" + str(pitch_index)
	var exponent := (pitch_index - 69.0) / 12.0
	pitch_scale = pow(2, exponent)

	var note_name = get_white_key_note_name_from_pitch(pitch_index)
	if note_name != null:
		var noteLabel: Label = $noteLabel
		noteLabel.text = note_name

func activate():
	key.color = (Color.YELLOW + start_color) / 2
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = preload("res://piano_keys/A440.wav")
	audio.pitch_scale = pitch_scale
	audio.play()
	color_timer.start()
	await get_tree().create_timer(8.0).timeout
	audio.queue_free()


func deactivate():
	key.color = start_color
