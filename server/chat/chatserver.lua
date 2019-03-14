local skynet = require "skynet"
local timext = require "timext"
local chatmgr = require "chatmgr"
local common = require "common"
local ServiceBase = require "servicebase"
require "static_config"
local ChatMgr = chatmgr.new()
local CMD = {}

CMD.private_chat = register_command(ChatMgr, "private_chat", true)
CMD.add_voice = register_command(ChatMgr, "add_voice", true)
CMD.req_chatrecord = register_command(ChatMgr, "req_chatrecord", true)

CMD.channel_chat = register_command(ChatMgr, "channel_chat")

local function day_event_func()
    printf("chatserver %s time event!", timext.to_unix_time_stamp())
    ChatMgr:dayrefresh()
end

skynet.init(function()
    local base = ServiceBase.new('chatserver')
    base:start(CMD)

    
    local function run(frame)
        ChatMgr:run()
    end

    ChatMgr:loaddb()
    
    timext.reg_time_event(day_event_func) --每日零点
    timext.open_clock(run, 100)
end)

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(CMD[cmd])
        f(...)
    end)
end)