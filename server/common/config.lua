local sharedata = require "sharedata"

local config = {}

local _config = nil

local function load_config()
	_config = sharedata.query("config")
end

--获取服务器端口配置
function config.get_server_config()
	if not _config then
		load_config()
	end
	return _config.game
end

--获取数据库配置
function config.get_db_config()
	if not _config then
		load_config()
	end
	return _config.dbconfig
end

function config.get_world_config()
	if not _config then
		load_config()
	end
	return _config.world
end

function config.get_cluster_config()
	if not _config then
		load_config()
	end
	return _config.cluster
end

function config.get_gamelist_config()
	if not _config then
		load_config()
	end
	return _config.gamelist
end

function config.get_server_id()
	local gamecfg = config.get_server_config()
	return gamecfg.serverid
end

function config.gate_name()
	return "gateservice"
end

return config