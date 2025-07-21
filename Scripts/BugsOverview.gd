extends Panel

class_name BugsOverview

var Bugs = []
var LatestBugNumber = 1
@export var BugHolder : VBoxContainer

func GetTicketAmount():
	return Bugs.size()
	
func _ready() -> void:
	Finder.GetMainControl().OnBugAdded.connect(OnBugAdded)
	
func OnBugAdded(bugData):
	if Bugs.is_empty():
		for child in BugHolder.get_children():
			child.queue_free()
	
	var bugNumber = int(bugData["BugNumber"]) - 1
	if Bugs.size() > bugNumber:
		BugHolder.get_child(bugNumber).Setup(bugData)
		Bugs[bugNumber] = bugData
	else:
		Bugs.append(bugData)
		LatestBugNumber += 1
		var previewInstance = load("res://Prefabs/BugPreview.tscn").instantiate() as BugPreview
		BugHolder.add_child(previewInstance)
		previewInstance.Setup(bugData)

func SortByPrio(bugDataA, bugDataB):
	return bugDataA["Priority"] > bugDataB["Priority"]
	
func GetTicketsOfType(type):
	var tickets = []
	for bug in Bugs:
		if bug["Type"] == type:
			if bug["Deleted"] == false:
				tickets.append(bug)
	tickets.sort_custom(SortByPrio)
	return tickets
	
func OpenExistingBug(bugNumber):
	Finder.GetMainControl().OpenBug(Bugs[bugNumber])
