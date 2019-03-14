local mapproto = {}

mapproto.type = [[
.cityobject { #城池信息
	objectid 0 : integer
	playerid 1 : integer
	level 3 : integer 
	name 4 : string
	x 5 : integer #
	y 6 : integer #

}

.occupyresourcedata {
	marchid 0 : integer
	guildid 1 : integer		
}

.resourceobject { #资源点信息
	objectid 0 : integer
	type 1 : integer #资源点类型
	x 2 : integer
	y 3 : integer
	occupydata 4 : occupyresourcedata #占领的行军信息
}

.monsterobject { #怪物点信息
	objectid 0 : integer
	type 1 : integer #怪物类型
	level 2 : integer #怪物等级
}

.marchobject { #行军信息
	marchid 	0 : integer
	marchtype 	1 : integer #行军类型
	playerid 	2 : integer
	name  		3 : string
	startx 		4 : integer
	starty 		5 : integer
	endx 		6 : integer
	endy 		7 : integer
	pastdistance 	8 : integer #行驶路程
	endtime  		9 : integer #结束时间
	status 			10 : integer #状态
	army 			11 : *marcharmy #行军队伍
}

.marcharmy { #行军队伍
	
}

]]

mapproto.c2s = mapproto.type .. [[ 
#5001 ~ 5200
reqmapinfo 5001 { #请求地图信息
	request {
		serverid 0 : integer #
		x 1 : integer #中心点X
		y 2 : integer #中心点Y
	}
}

reqmapleave 5002 {#离开地图
	request {
		serverid 0 : integer
	}
}

reqmarch 5003 { #请求行军
	request {
		marchtype 0 : integer 
		x 1 : integer
		y 2 : integer
		army 3 : *marcharmy #行军队伍
 	}
}

reqmoveplayercity 5004 { #请求迁城
	request {
		itemid 0 : integer
		x 1 : integer
		y 2 : integer
	}
}

reqsearchmap 5005 { #地图搜索
	request {
		searchtype 0 : integer
		level 1 : integer
		index 2 : integer #搜索序号
	}	
}

]]

mapproto.s2c = mapproto.type .. [[
synccitylist 5001 { #玩家城池同步
	request {
		serverid 0 : integer #
		objlist  1 : *cityobject
	}
}

syncresourcelist 5002 { #资源点同步
	request {
		serverid 0 : integer #
		objlist  1 : *resourceobject
	}
}

syncmonsterlist 5003 { #怪物信息
	request {
		serverid 0 : integer #
		objlist  1 : *monsterobject
	}
}

syncmarchlist 5004 { #行军信息
	request {
		serverid 0 : integer
		objlist  1 : *marchobject 
	}
}

syncmarchremove 5005 { #行军路线移除
	request {
		serverid 0 : integer
		marchid  1 : integer
	}
}

syncmapobjremove 5006 {
	request {
		serverid 0 : integer
		objectid 1 : integer
	}
}

retsearchresult 5007 { #搜索返回
	request {
		code 0 : integer
		x 1 : integer
		y 2 : integer
		index 3 : integer
		count 4 : integer
	}
}

]]

return mapproto