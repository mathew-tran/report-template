extends Panel

class_name BugPreview

@export var BugNumber : Label
@export var BugPriority : Label
@export var Type : Label
@export var BugTitle : Label

var BugNumberRef
#func GetData():
	#return {
		#"BugNumber" : BugNumberText.text,
		#"Type" : TicketChoice.get_item_text(TicketChoice.selected),
		#"Priority" : PriorityChoice.get_item_text(PriorityChoice.selected),
		#"Title" : TitleText.text,
		#"Desc" : DescriptionText.text
	#}
	
func Setup(bugData):
	BugNumber.text = bugData["BugNumber"]
	BugPriority.text = Helper.GetPriorityString(bugData["Priority"])
	Type.text = Helper.GetTicketTypeString(bugData["Type"])
	BugTitle.text = bugData["Title"]
	BugNumberRef = bugData["BugNumber"]
	if bugData["Deleted"]:
		visible = false


func _on_button_button_up() -> void:
	Finder.GetBugsOverview().OpenExistingBug(int(BugNumberRef) - 1)
