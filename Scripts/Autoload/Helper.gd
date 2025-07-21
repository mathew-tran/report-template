extends Node

enum PRIORITY {
	LOW,
	MEDIUM,
	HIGH
}

enum TICKET_TYPE {
	BUG,
	FEEDBACK,
	SUGGESTION
}

func GetPriorityString(index):
	return PRIORITY.keys()[index]
	
func GetTicketTypeString(index):
	return TICKET_TYPE.keys()[index]
	
func GetTicketTypeHTMLString(index):
	var str =  GetPriorityString(index)
	match index:
		Helper.PRIORITY.HIGH:
			str += "🔴"
		Helper.PRIORITY.MEDIUM:
			str += "🟠"
		Helper.PRIORITY.LOW:
			str += "🟢"
	return str
	
func GetPriorityHTMLString(tag, index):
	var prio = ""
	return "<{tag} class ='{prio}'> [{str}] </{tag}>".format({
		"tag" : tag,
		"prio" : GetPriorityString(index),
		"str" : GetTicketTypeHTMLString(index) 
	})
	
func GetEmoticonFromType(type):
	match type:
		TICKET_TYPE.BUG:
			return "🐛"
		TICKET_TYPE.FEEDBACK:
			return "💬"
		TICKET_TYPE.SUGGESTION:
			return "💡"

func PrettyPrintBugData(bugData, bugNumber = 1, bugMax = 1):
	var str = ""
	var bugDesc = ""
	for desc in bugData["Desc"].split("\n"):
		bugDesc += desc.strip_edges() + "<br>"
	bugDesc = bugDesc.strip_edges()
	bugDesc = bugDesc.rstrip("<br>")
	str += "<table border='1' cellpadding='2' cellspacing='0' style='margin-bottom:4px;'>"
	str += "<tr><td><b>" + str(bugNumber) + "/" + str(bugMax) + "</b> " + GetEmoticonFromType(bugData["Type"])
	str += GetPriorityHTMLString("b", bugData["Priority"]) + " " + bugData["Title"] + "</td></tr>"
	str += "<tr><td><b>Description:</b> <br>" + bugDesc + "</td></tr>"
	str += "</table>"
	return str
				
#func PrettyPrintBugData(bugData, bugNumber = 1, bugMax = 1):
	#var str = ""
	#str += "<table border='1' cellpadding='5' cellspacing='0'>"
	#str += "<tr><td><h4>Ticket #:</b> " + str(bugNumber) + "/" + str(bugMax) + "</td></tr>"
	#str += "<tr><td><b>Type:</b> " + GetTicketTypeString(bugData["Type"]) + GetEmoticonFromType(bugData["Type"]) + "</td></tr>"
	#str += "<tr><td><b>Priority:</b> " + GetPriorityHTMLString("span", bugData["Priority"]) + "</td></tr>"
	#str += "<tr><td><b>Title:</b> " + bugData["Title"] + "</td></tr>"
	#
	#var bugDesc = ""
	#for desc in bugData["Desc"].split("\n"):
		#bugDesc += "<p>" + desc + "</p>"
	#str += "<tr><td><b>Description:</b> <br>" + bugDesc + "</td></tr>"
	#str += "</table>"
	#return str

func PrettyPrintFeedbackData(bugData, bugNumber = 1, bugMax = 1):
	var str = ""
	var bugDesc = ""
	for desc in bugData["Desc"].split("\n"):
		bugDesc += desc.strip_edges() + "<br>"
	bugDesc = bugDesc.strip_edges()
	bugDesc = bugDesc.rstrip("<br>")
	str += "<table border='1' cellpadding='2' cellspacing='0' style='margin-bottom:4px;'>"
	str += "<tr><td><b>" + str(bugNumber) + "/" + str(bugMax) + "</b> " + GetEmoticonFromType(bugData["Type"]) + " " + bugDesc + "</td></tr>"
	str += "</table>"
	return str
