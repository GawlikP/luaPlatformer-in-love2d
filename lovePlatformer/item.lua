Item = {};
Item.__index = Item;
function Item:create(x,y)
  local i = {};
  setmetatable(i,Item);
  i.x = x;
  i.y = y;
  i.w = 8;
  i.h = 8;
  i.on_platform = false;
  i.vx = 0.0;
  i.vy = 0.0;
  return i;s
end
