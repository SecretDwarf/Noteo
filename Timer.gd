extends Timer

var time_start = 60
var label : Label

func _ready(
	label = $Label # Reference to the Label node
	self.connect("timeout", self, "_on_Timer_timeout")
	self.start(1) # Start the timer with a 1-second interval

func _on_Timer_timeout():
	time_left -= 1
	label.text = "Time Left: " + str(time_start) + " seconds"
	if time_left <= 0:
		self.stop() # Stop the timer when time runs out
		label.text = "Time's up!"
