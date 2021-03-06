local skynet = require "skynet"
local timext = require "timext"
local fcm_mgr = require "fcm_mgr"
local gm_mgr = require "gm_mgr"
require "static_config"
local debugcmd = require "debugcmd"

local CMD = {}
local FCM_Mgr
local GM_Mgr

--注册后台数据
function CMD.register_player_account(playerid, account)
    FCM_Mgr:register_player(playerid, account)
end

--事件推送
function CMD.event_broadcast(eventType, t_playerid, allflag)
    FCM_Mgr:event_broadcast(eventType, t_playerid, allflag)
end

--gm走马灯
function CMD.gm_zmd(param)
    GM_Mgr:gm_zmd(param)
end

--GM推送
function CMD.gm_push(id)
    FCM_Mgr:broadcast_all(id)
end

--帮派战后台推送事件
function CMD.guildwar_push(type, limitlv)
    FCM_Mgr:guildwar_push(type, limitlv)
end

skynet.init(function()
    --初始化后台推送
    FCM_Mgr = fcm_mgr.new()
    --FCM_Mgr:init()

    --初始化GM管理类
    GM_Mgr = gm_mgr:new()

    local function run()
        FCM_Mgr:run()
        GM_Mgr:run()
    end
    local function zero_event_func()
        FCM_Mgr:zerorefresh()
    end

    timext.open_clock(run, 100)
    timext.reg_time_event(zero_event_func)
end)

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(CMD[cmd])
        f(...)
    end)
end)
