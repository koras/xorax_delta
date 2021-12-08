 require('socket');
 local http = require 'socket.core'
--require "socket"
--require("socket.core")
 --local http = require "socket.core"

-- https://quik2dde.ru/viewtopic.php?id=18
local host = "http://localhost/send";
local port = "80"
local h ={};

local script_path = getScriptPath()
local loger = dofile(script_path .. "\\engine\\loger.lua");

local socket = require("socket.core")
local _M = socket;

function _M.connect4(address, port, laddress, lport)
   return socket.connect(address, port, laddress, lport, "inet")
end


function _M.bind(host, port, backlog)
if host == "*" then host = "0.0.0.0" end
local addrinfo, err = socket.dns.getaddrinfo(host);
if not addrinfo then return nil, err end
local sock, res
err = "no info on address"
for i, alt in base.ipairs(addrinfo) do
    if alt.family == "inet" then
        sock, err = socket.tcp4()
    else
        sock, err = socket.tcp6()
    end
    if not sock then return nil, err end
    sock:setoption("reuseaddr", true)
    res, err = sock:bind(alt.addr, port)
    if not res then
        sock:close()
    else
        res, err = sock:listen(backlog)
        if not res then
            sock:close()
        else
            return sock
        end
    end
end
return nil, err
end



local function sendHttp(setting, messages)
local mess =   host.."?login="..setting.ACCOUNT.."&psw=" .. setting.password.."&token=" .. setting.token.."&mes="..messages
 


local host  = "127.0.0.1"
local port = 80
local c = assert(socket.udp())
local i = 0
--while 1 do
    local message = string.format("hello all %d!", i)
    assert(c:sendto(mess, host, port))
    loger.save("sent " .. mess)
    socket.sleep(1)
    c:settimeout(0.5)
  --  print(c:receivefrom())

  -- loger.save(string.format(c:receivefrom()));
    i = i + 1
--end
  -- loger.save(text)
end;

h.sendHttp = sendHttp;
return h;