local skynet = require "skynet"
local interaction = require "interaction"
local debugcmd = require "debugcmd"
local class = require "class"
local Database = class("Database")

local ServiceBase = class("ServiceBase")

function ServiceBase:ctor(quitweight)
    self.quit_weight = quitweight or 0
end

function ServiceBase:service_init()
end

function ServiceBase:safe_quit()
end

function ServiceBase:service_init_over()
end

function ServiceBase:safe_quit_over()
end

function ServiceBase:__service_start__(CMD)
    interaction.register_service_event({ safe_quit = self.quit_weight, service_init = true, service_init_over = true })
    CMD.service_init = register_command(self, "service_init", true)
    CMD.service_init_over = register_command(self, "service_init_over", true)
    CMD.safe_quit = register_command(self, "safe_quit", true)
    CMD.safe_quit_over = register_command(self, "safe_quit_over", true)
end

return ServiceBase