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
	
func GetPriorityHTMLString(tag, index):
	var prio = ""
	return "<{tag} class ='{prio}'> {str} </{tag}>".format({
		"tag" : tag,
		"prio" : GetPriorityString(index),
		"str" : GetPriorityString(index) 
	})
	
func PrettyPrintBugData(bugData, bugNumber = 1):
	var str = ""
	str += "<table border='1' cellpadding='5' cellspacing='0'>"
	str += "<tr><th>Ticket #</th><td>" + str(bugNumber) + "</td></tr>"
	str += "<tr><th>Type</th><td>" + GetTicketTypeString(bugData["Type"]) + "</td></tr>"
	str += "<tr><th>Priority</th><td>" + GetPriorityHTMLString("p", bugData["Priority"]) + "</td></tr>"
	str += "<tr><th>Title</th><td>" + bugData["Title"] + "</td></tr>"
	str += "<tr><th>Description</th><td>" + bugData["Desc"] + "</td></tr>"
	str += "</table>"
	return str
