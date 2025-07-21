extends Panel

@export var TicketChoice : OptionButton
@export var PriorityChoice : OptionButton
@export var TitleText : TextEdit
@export var DescriptionText : TextEdit
@export var UpdateButton : Button
@export var BugNumberText : Label
@export var ErrorText : Label
func GetData():
	return {
		"BugNumber" : BugNumberText.text,
		"Type" : TicketChoice.selected,
		"Priority" : PriorityChoice.selected,
		"Title" : TitleText.text,
		"Desc" : DescriptionText.text
	}
	
func CanUpdate():
	return TitleText.text != "" and DescriptionText.text != ""
	
func _on_button_button_up() -> void:
	if CanUpdate():
		print(GetData())
		Finder.GetMainControl().OnBugAdded.emit(GetData())
		visible = false
		ErrorText.text = ""
	else:
		ErrorText.text = "Title or description is empty!"
