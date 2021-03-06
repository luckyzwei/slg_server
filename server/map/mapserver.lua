local skynet = require "skynet"
local MapServerMgr = require "mapservermgr"
local mapcommon = require "mapcommon"
local mapinterface = require "mapinterface"
local timext = require "timext"
local class = require "class"

require "static_config"
local mapservermgr = nil
local CMD = {}

local mapcode = mapcommon.map_code
function CMD.req_playercitydata(playerid)
	local ret = {}
	local code = mapcode.success
	local playermgr = MapServerMgrInstance():MapPlayerMgr()
	local object = playermgr:get_playercityobj(playerid)
	if not object then
		code = mapcode.nocitydata
	else
		ret.data = mapinterface.Pack_MapObject_MSG(object)
	end
	ret.code = code
	skynet.retpack(ret)
end

--请求创建地图玩家活物
function CMD.req_createmapplayerobj(playerid, data)
	--默认初始区域为1级区
	local msg = nil
	local playermgr = MapServerMgrInstance():MapPlayerMgr()
	local object = playermgr:create_mapplayerobject(playerid, data)
	if object then
		msg = mapinterface.Pack_MapObject_MSG(object)
	end
	skynet.retpack(msg)
end

function CMD.player_watchmap(playerparam)
	local MapBlockMgr = MapServerMgrInstance():MapBlockMgr()
	skynet.retpack(MapBlockMgr:handle_playerwatch(playerparam))
end

function CMD.cancle_watch(playerid)
	local MapBlockMgr = MapServerMgrInstance():MapBlockMgr()
	MapBlockMgr:handle_canclewatch(playerid)
end

function CMD.player_march(marchparam)
	--TODOX
	local marchdata 
	local code = mapcode.unknow
	repeat
		--验证活物信息
		if false then
		end
		--活物添加行军队列

		local MapMarchMgr = MapServerMgrInstance():MapMarchMgr()
		local marchobj = MapMarchMgr:create_march(marchparam)
		marchdata =mapinterface.Pack_MapMarchObject_MSG(marchobj)
		code = mapcode.success
	until 0;
	
	local ret = {
		code = code,
		marchdata = marchdata
	}
	skynet.retpack(ret)
end

function CMD.player_search(playerid, searchtype, level, index)
	local ret = {}
	local object, count
	local code = mapcode.unknow
	local MapPlayerMgr = MapServerMgrInstance():MapPlayerMgr()
	local MapBlockMgr = MapServerMgrInstance():MapBlockMgr()
	repeat
		local playerobj = MapPlayerMgr:get_playercityobj(playerid)
		if not playerobj then
			code = mapcode.nocitydata
			break
		end

		local x,y = playerobj:get_xy()
		local object,count = MapBlockMgr:search_object(playerid, x, y, searchtype, level, index)
		if not object then
			code = mapcode.unsearchtag
			break
		end

		ret.count = count
		ret.x, ret.y = object:get_xy()
		code = mapcode.success
	until 0;
	ret.code = code
	ret.index = index	
	skynet.retpack(ret)
end

function MapServerMgrInstance()
	return mapservermgr
end

skynet.init(function()
end)

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(CMD[cmd])
        f(...)
    end)

	local function run()
		mapservermgr:run()
	end

	local ServiceBase = require "servicebase"
	local MapServer = class("MapServer", ServiceBase)
	function MapServer:service_init()
    	timext.open_clock(run, 100)
    end
    function MapServer:safe_quit()
        ServiceBase.safe_quit(self)
       	MapServerMgrInstance():serverquit()
    end


	local base = MapServer.new()
    base:__service_start__(CMD)

    init_static_config()

 	mapservermgr = MapServerMgr.new()
 	mapservermgr:loaddb()
 	mapservermgr:init()
 	mapservermgr:initcomplete()
end)