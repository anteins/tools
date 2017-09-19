
--[[
    封装C# LogicStatic
]]

mylua = {}
local LogicStatic = {}

function LogicStatic:Get( data )
    local net = XLuaScriptUtils.NetworkClient()
    if net and net._server then
        if net._server and net._server.isReady then
            if net._server._dataCache then
                if not net._server:CheckAndLoadData( data ) then
                    return nil
                end

                return net._server._dataCache:GetDataByCls(data)
            end
        end
    end
end

function LogicStatic:Get( data , key)
    local net = XLuaScriptUtils.NetworkClient()
    if net and net._server then
        if net._server and net._server.isReady then
            if net._server._dataCache then
                if isnil(data) or not net._server:CheckAndLoadData( data ) then
                    return nil
                end
                return net._server._dataCache:GetDataByCls(data, key)
            end
        end
    end
end

function LogicStatic:GetList( data , match)
    local net = XLuaScriptUtils.NetworkClient()
    if net and net._server then
        -- GameLog(">L ", type(net._server), net._server.isReady)
        if net._server and net._server.isReady then
            if net._server._dataCache then
                if not net._server:CheckAndLoadData( data ) then
                    return nil
                end

                return net._server._dataCache:GetDataArrayByCls(data, match)
            end
        end
    end
end

mylua = {
    LogicStatic = LogicStatic,
}

