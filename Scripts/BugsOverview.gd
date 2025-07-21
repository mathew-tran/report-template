extends Panel

class_name BugsOverview

var Bugs = []

@export var BugHolder : VBoxContainer

func GetTicketAmount():
	return Bugs.size()
	
func _ready() -> void:
	Finder.GetMainControl().OnBugAdded.connect(OnBugAdded)
	
func OnBugAdded(bugData):
	if Bugs.is_empty():
		for child in BugHolder.get_children():
			child.queue_free()
	
	Bugs.append(bugData)
	var previewInstance = load("res://Prefabs/BugPreview.tscn").instantiate() as BugPreview
	BugHolder.add_child(previewInstance)
	previewInstance.Setup(bugData)

func SortByPrio(bugDataA, bugDataB):
	return bugDataA["Priority"] > bugDataB["Priority"]
	
func GetTicketsOfType(type):
	var tickets = []
	for bug in Bugs:
		if bug["Type"] == type:
			tickets.append(bug)
	tickets.sort_custom(SortByPrio)
	return tickets
