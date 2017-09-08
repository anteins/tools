��%�i�8�Cof²�=�������� �� ް���aP���.�?�VvK�j�:᧪"bH��	އM:4�8���2���nQ��F0Դ�Fi��A��\���V�_U	�N~0��sl�-nf�|l�B��
--[[
    封装C# LogicStatic
]]

local this = nil
LogicStatic = BaseCom:New("LogicStatic")

function LogicStatic:Ref(ref)
	if ref then
		this = ref
	end
	return this
end

function LogicStatic:Get( data )
    local net = GameLuaApi.NetworkClient()
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
    local net = GameLuaApi.NetworkClient()
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
    local net = GameLuaApi.NetworkClient()
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

