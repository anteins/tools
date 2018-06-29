--==============================================
-- PlatformUtil
-- 
--==============================================
local PlatformUtil = {}

function PlatformUtil:IsIOS()
    local sPlatform = CS.PlatformUtil:GetDeviceOS()
    return string.find(sPlatform, "iPhone")
end

return PlatformUtil