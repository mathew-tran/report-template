extends Node

func GetMainControl() -> MainControl:
	return get_tree().get_nodes_in_group("MainControl")[0]

func GetBugsOverview() -> BugsOverview:
	return get_tree().get_nodes_in_group("BugsOverview")[0]
