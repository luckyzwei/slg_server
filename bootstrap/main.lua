local skynet = require "skynet"
local snax = require "snax"
local debugcmd = require "debugcmd"
local config = require "config"
require "cluster_service"
local clusterext = require "clusterext"
require "skynet.manager"
require("cluster")

skynet.start(function()
    --local log = skynet.uniqueservice("logservice")
    --skynet.call(log, "lua", "start")
    skynet.uniqueservice("configd")

    local conf = config.get_server_config()

    --clusterext.open(serverconfig.interaction.cluster)
    skynet.uniqueservice("dbservice")
    local hubd = clusterservice("interactionhubd")
    clusterservice("interactiond")

    --[[打印截断
    if not skynet.getenv "daemon" then
       local console = skynet.newservice("console")
    end
    ]]
    local console = skynet.newservice("debug_console",conf.debug_port)
    debugcmd.init(console)
    skynet.newservice ("protod")
    local loginserver = clusterservice("loginservice")
    skynet.call(loginserver, "lua", "open")
    skynet.name(".logind", loginserver)

    local cache = clusterservice("cacheservice")
    skynet.call(cache, "lua", "open")

    local gamed = skynet.newservice ("gateservice")
    
    clusterservice("mapserver") 
    clusterservice("mailserver") 
    clusterservice("imageserver")
    --clusterservice("spaceservice")
    --clusterservice("relationservice")
    clusterservice("chatserver")
    --local rankd = clusterservice("rankserver")
	--clusterservice("arenaserver")
	--clusterservice("burnserver")
    clusterservice("gmweb")
    clusterservice("gmserver")

    -- local guildd = clusterservice("guildservice")
    -- skynet.call(guildd, "lua", "open")

    skynet.call(gamed, "lua", "open")

    --skynet.name(conf.cluster, gamed)
    --clusterservice("flowerserver")`

    --clusterservice("marryserver")

    skynet.open_sign()
    
    skynet.call(".launcher", "lua", "GC")

    skynet.call(hubd, "lua", "init_over")

    skynet.exit()
end)