Platform = {};
Platform.__index = Platform
function Platform:create(x,y,w,h)
  local p = {};
  setmetatable(p, Platform)
  p.x = x
  p.y = y
  p.w = w
  p.h = h
  return p;
end
