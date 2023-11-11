extends Node2D
@export var clef: Sprite2D
@export var treble: Texture2D
@export var bass: Texture2D

@export var flatContainer: Node2D
@export var sharpContainer: Node2D

@export var note: Sprite2D

@export var sixteenth: Texture2D
@export var eighth: Texture2D
@export var quarter: Texture2D
@export var half: Texture2D

func RNG(intMin, intMax):
	var random_number = randi() % (intMax - intMin + 1) + intMin
	return random_number

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _ready():
	var piano = load("res://piano.gd").new
	var randClef = RNG(1, 2)

#Load Clef

	if (randClef == 1):
		clef.texture = bass
		piano.set_start_key(36)
		piano.set_end_key(64)
	elif (randClef == 2):
		clef.texture = treble
		piano.set_start_key(60)
		piano.set_end_key(88)

# Load Key signature

	var randKey = RNG(0, 7)

	if randKey != 0:
		var randAccidental = RNG(0, 2)

		if randAccidental == 0:
			var Accidental = "flat"
			var orderOfFlats = ["Bb", "Eb", "Ab", "Db", "Gb", "Cb", "Fb"]
			for i in range(randKey - 1):
				displaySprite(Accidental, orderOfFlats[i])
		elif randAccidental == 1:
			var Accidental = "sharp"
			var orderOfSharps = ["F#", "C#", "G#", "D#", "A#", "E#", "B#"]
			for i in range(randKey - 1):
				displaySprite(Accidental, orderOfSharps[i])

func displaySprite(accidental, note):
	if accidental == "flat":
		var container = flatContainer
		var sprite = container.get_node(note)
		if sprite:
			sprite.visible = true
	elif accidental == "sharp":
		var container = sharpContainer
		var sprite = container.get_node(note)
		if sprite:
			sprite.visible = true

# load note
const Notes  = ['A', 'Ab', 'A#', 'B', 'Bb', 'B#', 'C', 'Cb', 'C#', 'D', 'Db', 'D#', 'E', 'Eb', 'E#', 'F', 'Fb', 'F#', 'G', 'Gb', 'G#']
const notePositions = [130, 240, 350, 460, 570, 680, 790, 900, 1010, 1120, 1230]

const noteToPositionDict = {
	'A': 130,
	'Ab': 240,
	'A#': 350,
	'B': 460,
	'Bb': 570,
	'B#': 680,
	'C': 790,
	'Cb': 900,
	'C#': 1010,
	'D': 1120,
	'Db': 1230,
	'D#': 1340,
	'E': 1450,
	'Eb': 1560,
	'E#': 1670,
	'F': 1780, 
	'Fb': 1890,
	'F#': 2000,
	'G': 2110,
	'Gb': 2220,
	'G#': 2330
}

var randNote = RNG(0, 16)
# make a variable called note name sets the value CDEFGAB CDEFGAB
# if keysignature contains the note change note to the corresponidng flat or sharp
