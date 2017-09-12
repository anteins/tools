
LINQ={};
LINQ.exec = function(linq)
  local paramList = {};
  local ix = 1;
  return LINQ.execRecursively(linq, ix, paramList);
end;
LINQ.execRecursively = function(linq, ix, paramList)
	local finalRs = {};
	local interRs = {};
	local itemNum = #linq;
	while ix <= itemNum do
		local v = linq[ix];
		local key = v[1];
		ix = ix + 1;
		
		if key=="from" then
		  local nextIx = LINQ.getNextIndex(linq, ix);
		  
		  --��ȡĿ�꼯��
			local coll = v[2](unpack(paramList));
			LINQ.buildIntermediateResult(linq, ix, paramList, coll, interRs, finalRs);
			
			ix = nextIx;
		elseif key=="where" then
		  --���м������Ͻ��й��˴���
		  local temp = interRs;
		  interRs = {};
		  for i,val in ipairs(temp) do
		    if v[2](unpack(val)) then
		      table.insert(interRs, val);
		    end;
		  end;
		elseif key=="orderby" then
		  --���򣨶�ؼ��֣�
			table.sort(interRs, (function(l1, l2) return LINQ.compare(l1, l2, v[2]); end));
		elseif key=="select" then
		  --�������ս����
		  for i,val in ipairs(interRs) do
		    local r = v[2](unpack(val));
		    table.insert(finalRs, r);
		  end;
		else
			--�����Ӿ��ݲ�֧�֡���
		end;
	end;
	return finalRs;
end;
LINQ.buildIntermediateResult = function(linq, ix, paramList, coll, interRs, finalRs)
  --����Ŀ�꼯�ϣ�����������let��where (��ʱwhere���������ڵ���Ԫ�ر���ʱ���У����õ��м������������ٹ���)
	--���������from����ݹ������������ȡ�Ӽ����ϲ�����ǰ�����
	for ii,cv in ipairs(coll) do
		local newParamList = {unpack(paramList)};
		table.insert(newParamList, cv);
		local isMatch = true;
		local newIx = ix;
    local itemNum = #linq;
		while newIx <= itemNum do
			local v = linq[newIx];
			local key = v[1];
			
			if key=="let" then
				table.insert(newParamList, v[2](unpack(newParamList)));
			elseif key=="where" then
				if not v[2](unpack(newParamList)) then
				  --�����������ļ�¼���ŵ��м�����
					isMatch = false;
					break;
				end;
			elseif key=="from" then
			  --�ٴ�����from���ݹ�����ٺϲ������
			  local ts = LINQ.execRecursively(linq, newIx, newParamList);
			  for i,val in ipairs(ts) do
			    table.insert(finalRs, val); 
			  end;
			  isMatch = false;
			  break;
			else
			  --�����Ӿ���Ҫ���м�������ɺ��ٴ�����������
				break;
			end;
			newIx = newIx + 1;
		end;
		if isMatch then
			table.insert(interRs, newParamList);
		end;
	end;
end;
LINQ.compare = function(l1, l2, list)
  for i,v in ipairs(list) do
    local v1 = v[1](unpack(l1));
    local v2 = v[1](unpack(l2));
    local asc = v[2];
    if v1~=v2 then
      if asc then
        return v1<v2;
      else
        return v1>v2;
      end;
    end;
  end;
  return true;
end;
LINQ.getNextIndex = function(linq, ix)
  local itemNum = #linq;
	while ix <= itemNum do
		local v = linq[ix];
		local key = v[1];
		if key=="let" then
		elseif key=="where" then
		elseif key=="from" then
		  return itemNum + 1;
		else
		  return ix;
		end;
		ix = ix + 1;
	end;
	return ix;
end;

local vs = {1,9,6,5,3,7,2,4};
--local rs = LINQ.exec({{"from", function() return vs; end}, {"let", function(v) return v+1; end}, {"where", function(v,v2) return v>2; end}, {"orderby", {{function(v,v2) return v; end, true}}}, {"where", function(v,v2) return v<8; end}, {"select", function(v,v2) return {v1 = v, v2 = v2}; end}});
local rs; rs = LINQ.exec({{"from", (function() return vs; end)}, {"from", (function(v) return {v, v, v, v}; end)}, {"let", (function(v, vv) return v+1; end)}, {"where", (function(v, vv, v2) return (v > 1); end)}, {"let", (function(v, vv, v2) return v2 + 1; end)}, {"where", (function(v, vv, v2, v3) return (v > 4); end)}, {"where", (function(v, vv, v2, v3) return (v < 8); end)}, {"select", (function(v, vv, v2, v3) return {v1 = v, v2 = v2, v3 = v3}; end)}});
--{"orderby", {{(function(v, vv, v2, v3) return v; end), true}}}, 

for i,vs in ipairs(rs) do
  print("{");
  for k,v in pairs(vs) do
    print(" "..k.." = "..v);
  end;
  print("}");
end;

__delegation_keys = {};

function setdelegationkey(func, key, obj, member)
  rawset(__delegation_keys, func, key);
end;
function getdelegationkey(func)
  return rawget(__delegation_keys, func);
end;

local f = function() return 123; end;
setdelegationkey(f, "test");
local key = getdelegationkey(f);
print(key, type(f), f());

local tb = {
	mf = function(this)
		return f();
	end,
};

local ff = (function() local __compiler_delegation_128 = (function() return tb:mf(); end); setdelegationkey(__compiler_delegation_128, "DelegateTest:NormalEnumerator", tb, tb.mf); return __compiler_delegation_128; end)();
key = getdelegationkey(ff);
print(key, type(ff), ff());