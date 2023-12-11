extends Node2D
@export var clef: Sprite2D
@export var treble: Texture2D
@export var bass: Texture2D

@export var flatContainerBass: Node2D
@export var sharpContainerBass: Node2D

@export var flatContainerTreble: Node2D
@export var sharpContainerTreble: Node2D

@export var noteSprite: Sprite2D

@export var sixteenth: Texture2D
@export var eighth: Texture2D
@export var quarter: Texture2D
@export var half: Texture2D

var randAccidental: int
var randKey: int

@onready var round_countdown = $round_countdown
@onready var startButton = $Start 
@onready var score = $ScoreLabel
@onready var CurrentNoteLabel = $CurrentNote
@onready var label = $round_countdown/Label
@onready var scoreLabel = $ScoreLabel

# define note values
# the lower octave is stored as lowercase
# the upper octave is stored as uppercase
const trebleNotes  = ['c', 'd', 'e', 'f', 'g', 'A', 'B', 'C', 'D', 'E', 'F', 'G'] 
const bassNotes = ['f', 'g', 'a', 'b', 'c', 'd', 'e', 'F', 'G', 'A', 'B', 'C'] 

const trebleNoteToPositionDict = {
  'a': 260, 'ab': 260, 'a#': 260, 'b': 220, 'bb': 220, 'b#': 220, 'c': 180, 'cb': 180, 'c#': 180, 'd': 140, 'db': 140, 'd#': 140, 'e': 100, 'eb': 100, 'e#': 100, 'f': 60, 'fb': 60, 'f#': 60, 'g': 20, 'gb': 20, 'g#': 20,
  'A': -20, 'Ab': -20, 'A#': -20, 'B': -60, 'Bb': -60, 'B#': -60, 'C': -100, 'Cb': -100, 'C#': -100, 'D': -140, 'Db': -140, 'D#': -140, 'E': -180, 'Eb': -180, 'E#': -180, 'F': -220, 'Fb': -220, 'F#': -220, 'G': -260, 'Gb': -260, 'G#': -260, 'AA': -300, 'AAb': -300, 'AA#': -300, 'BB': -340, 'BBb': -340, 'BB#': -340, 'CC': -420, 'CCb': -420, 'CC#': -420 
}

const bassNoteToPositionDict = {
  'c': 260, 'cb': 260, 'c#': 260, 'd': 220, 'db': 220, 'd#': 220, 'e': 180, 'eb': 180, 'e#': 180, 'f': 140, 'fb': 140, 'f#': 140, 'g': 100, 'gb': 100, 'g#': 100, 'a': 60, 'ab': 60, 'a#': 60, 'b': 20, 'bb': 20, 'b#': 20,
  'C': -20, 'Cb': -20, 'C#': -20, 'D': -60, 'Db': -60, 'D#': -60, 'E': -100, 'Eb': -100, 'E#': -100, 'F': -140, 'Fb': -140, 'F#': -140, 'G': -180, 'Gb': -180, 'G#': -180, 'A': -220, 'Ab': -220, 'A#': -220, 'B': -260, 'Bb': -260, 'B#': -260, 'CC': -300, 'CCb': -300, 'CC#': -300, 'DD': -340, 'DDb': -340, 'DD#': -340, 'EE': -420, 'EEb': -420, 'EE#': -420 
};

# setters

func setRandKey(newRandKey: int):
	randKey = newRandKey

func setRandAccidental(newRandAccidental: int):
	randAccidental = newRandAccidental

func _ready():
	getNewClef()
	setRandKey(RNG(0, 7))
	setRandAccidental(RNG(0, 1))
	getNewKey()
	getNewNote()
	startButton.pressed.connect(self._startButton_pressed)
	round_countdown.set_one_shot (true)
	
	
func RNG(intMin, intMax):
	var random_number = randi() % (intMax - intMin + 1) + intMin
	return random_number

func _process(_delta):
	if round_countdown.is_stopped() == false:
		var timeLeftCopy = round(round_countdown.time_left)
		label.text = str(timeLeftCopy)
		if label.text == "0":
			get_tree().change_scene_to_file("res://end.tscn")		

func _startButton_pressed():
	start_round_countdown()
	startButton.hide()
	scoreLabel.visible = true

func start_round_countdown():
	round_countdown.start(31)  # Changed to 31 seconds

func getNewClef():
	var selectedClef = RNG(1,2)
	if selectedClef == 0:
		clef.texture = treble
	else:
		clef.texture = bass

func getNewKey():
	var container: Node2D
	var orderOfAccidentals: Array
	
	var clefTexture = clef.texture 
	
	if clefTexture == bass:
		if randAccidental == 0:
			container = flatContainerBass
			orderOfAccidentals = ["Bb", "Eb", "Ab", "Db", "Gb", "Cb", "Fb"]
		elif randAccidental == 1:
			container = sharpContainerBass
			orderOfAccidentals = ["F#", "C#", "G#", "D#", "A#", "E#", "B#"]
		else:
			print("Invalid accidental type:", randAccidental)
			return
	else:
		if clefTexture == treble:
			if randAccidental == 0:
				container = flatContainerTreble
				orderOfAccidentals = ["Bb", "Eb", "Ab", "Db", "Gb", "Cb", "Fb"]
			elif randAccidental == 1:
				container = sharpContainerTreble
				orderOfAccidentals = ["F#", "C#", "G#", "D#", "A#", "E#", "B#"]
			else:
				print("Invalid accidental type:", randAccidental)
				return
		
	for i in range(randKey - 1):
		var note = orderOfAccidentals[i]
		var sprite: Sprite2D = getNoteSprite(container, note)

		if sprite:
			sprite.visible = true
		else:
			print("Display Sprite: Note position not found for:", note)

# Helper function to get the note sprite from the container
func getNoteSprite(container: Node2D, note: String) -> Sprite2D:
	for child in container.get_children():
		if child is Sprite2D and child.name == note:
			return child

	return null
	
func getNewNote():

	var randNote = RNG(0, 11)
	var adjustedNote: String = ""
	var accidental: String = ""
	var noteName: String = ""
	var noteNameLower: String = ""
	var orderOfAccidentals: Array[String] = []
	var accidentalArray: Array[String] = []

	# Check the accidental type
	if randAccidental == 0:
		accidental = "flat"
	elif randAccidental == 1:
		accidental = "sharp"
	else:
		print("Invalid accidental type:", randAccidental)
		return

	# Define orderOfAccidentals and accidental based on randAccidental
	if randAccidental == 0:
		orderOfAccidentals = ["Bb", "Eb", "Ab", "Db", "Gb", "Cb", "Fb"]
		accidental = "b"
	elif randAccidental == 1:
		orderOfAccidentals = ["F#", "C#", "G#", "D#", "A#", "E#", "B#"]
		accidental = "#"

	# Fill accidentalArray with base notes (without accidentals)
	for i in range(randKey - 1):
		if i < len(orderOfAccidentals):
			var baseNote = orderOfAccidentals[i][0]  # Extract the base note without accidental
			accidentalArray.append(baseNote.to_lower())  # Convert to lowercase

	# Assign note names based on randAccidental
	if randAccidental == 1:
		noteName = bassNotes[randNote]
		noteNameLower = noteName.to_lower()
	elif randAccidental == 0:
		noteName = trebleNotes[randNote]
		noteNameLower = noteName.to_lower()

	# Check if the adjustedNote needs an accidental and set it
	adjustedNote = noteName  # Initialize adjustedNote with the note name
	if noteNameLower in accidentalArray:
		adjustedNote += accidental

	# Set the position of the Note Sprite along the Y-axis
	if randAccidental == 1:
		if bassNoteToPositionDict.has(adjustedNote):
			noteSprite.position.y = bassNoteToPositionDict[adjustedNote]
	elif randAccidental == 0:
		if trebleNoteToPositionDict.has(adjustedNote):
			noteSprite.position.y = trebleNoteToPositionDict[adjustedNote]

	# Choose a random texture outside the if conditions
	var randomTexture: Texture2D
	var randTextureIndex = RNG(0, 3)
	match randTextureIndex:
		0:
			randomTexture = sixteenth
		1:
			randomTexture = eighth
		2:
			randomTexture = quarter
		3:
			randomTexture = half

	# Set the texture of the note sprite
	noteSprite.texture = randomTexture
	CurrentNoteLabel.text = adjustedNote;
