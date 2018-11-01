Bullet = {};
Bullet.__index = Bullet;
function Bullet:create(x,y,vx,vy)
  local b = {};
  setmetatable(b,Bullet);
  b.x = x;
  b.y = y;
  b.w = 2;
  b.h = 2;
  b.vx = vx;
  b.vy = vy;
  b.hit = false
  return b;
end
function Bullet:update(dt,Gravity)

  self.vy = self.vy + Gravity;
  self.x = self.x + self.vx *dt;
  self.y = self.y + self.vy *dt;
end
function Bullet:collision(body)
  if self.x + self.w < body.x or self.y + self.h < body.y
      or body.x + body.w < self.x or body.y + body.h < self.y then
        return false
  else
      self.hit = true;
      return true;
  end
end
  -- GRANADE --

Granade = {};
Granade.__index = Granade;
function Granade:create(x,y,vx,vy)
  local g = {};
  setmetatable(g, Granade);
  g.x = x;
  g.y = y;
  g.w = 2;
  g.h = 2;
  g.vx = vx;
  g.vy = vy;
  g.hit = false;
  g.explosion_time = 100.0;
  g.explosion_power = 40.0;
  g.explosion_timer = 0.0;
  g.on_platform = false;
  g.type = false;
  return g;
end
function Granade:platform_collsion(platform)
if self.y < platform.y and self.vy > 0 then
  if self.x + self.w < platform.x or self.y + self.h < platform.y or platform.x + platform.w < self.x or platform.y + platform.h < self.y  then
    return false
  else
    self.vy = 0.0;
    self.y = platform.y - self.h;
    self.on_platform = true;
    return true;
  end
end
end
function Granade:update(dt,Gravity)
  if self.explosion_timer > self.explosion_time then
    self.hit = true;
  else
    self.explosion_timer = self.explosion_timer + dt *50;
  end
  if math.abs(self.vx) < 5 then
    self.vx = 0.0;
  end
  if self.vx > 0 then
    self.vx = self.vx -1
  elseif self.vx < 0 then
    self.vx = self.vx +1
  end
  if not self.on_platform then
        self.vy = self.vy + Gravity;
  end
  self.x = self.x + self.vx * dt;
  self.y = self.y + self.vy * dt;
end
function Granade:side_collsion(platform)
  if self.x + self.w < platform.x or self.y + self.h < platform.y or platform.x + platform.w < self.x or platform.y + platform.h < self.y  then
    return false
  else
    if self.y < platform.y + platform.h and self.y + self.h > platform.y then
        if self.x + self.w < platform.x + platform.w/2 then
            self.vx = -self.vx;
            return true;
        elseif self.x > platform.x + platform.w/2 then
            self.vx = -self.vx;
            return true;
        end
      return true;
    end
end
end
function Granade:roof_collision(platform)
if self.y > platform.y and self.vy < 0 then
  if self.x + self.w < platform.x or self.y + self.h < platform.y or platform.x + platform.w < self.x or platform.y + platform.h < self.y  then
    return false
  else
  self.y = self.y + 0.0001;
  self.vy = - self.vy;
    return true;
  end
end
end
function Granade:block_platform(platform)
  if platform.on_platform then
  if self.y < platform.y and self.vy > 0 then
    if self.x + self.w < platform.x or self.y + self.h < platform.y or platform.x + platform.w < self.x or platform.y + platform.h < self.y  then
      return false
    else
      self.vy = 0.0;
      self.y = platform.y - self.h;
      self.on_platform = true;
      return true;
    end
  end
end
end
function Granade:player_colllsion(player)
  if self.x + self.w < player.x or self.y + self.h < player.y or player.x + player.w < self.x or player.y + player.h < self.y then
    return false;
  else
    local sx = self.x + self.w /2;
    local sy = self.y + self.h /2;
    local px = player.x + player.w /2;
    local py = player.y + player.h /2;

    local dx = math.abs(sx - px);
    local dy = math.abs(sy - py);

    if dx > dy then
    --  if not self.on_wall then
        --if player.y + player.w/2 < self.y then
      if self.on_wall then
        if sx > px then
          self.x = self.x - (self.w/2 + player.w/2 - dx);
          player.x = player.x - (player.w/2 + self.w/2 - dx);
          if player.vx > 0 then
          player.vx = 0.0---math.abs(player.vx)
          end
        else
          self.x = self.x + (self.w/2 + player.w/2 - dx);
          player.x = player.x + (player.w/2 + self.w/2 - dx);
          if player.vx < 0 then
             player.vx = 0.0
          end--math.abs(player.vx)
        end
    else
      if px > sx then
        self.x = self.x - (self.w/2 + player.w/2 - dx);
      else
        self.x = self.x + (self.w/2 + player.w/2 - dx);
      --end
    --end
    --else
    --  if sx > px then
    --    player.x = player.x - (player.w/2 + self.w/2 - dx);
    --  else
    --    player.x = player.x + (player.w/2 + self.w/2 - dx);
    --  end
    end
    end
    else
      if py > sy then
        self.y = self.y - (self.h/2 + player.h/2 - dy);
        self.vy = player.vy *2;
      else
        --self.y = self.y + (self.h/2 + player.h/2 - dy);
      end
    end
    return true;
  end
end
function Granade:block_colllsion(block)
  if self.x + self.w < block.x or self.y + self.h < block.y or block.x + block.w < self.x or block.y + block.h < self.y then
    return false;
  else
    local sx = self.x + self.w /2;
    local sy = self.y + self.h /2;
    local bx = block.x + block.w /2;
    local by = block.y + block.h /2;

    local dx = math.abs(sx - bx);
    local dy = math.abs(sy - by);

    if dx > dy then
    --  if not self.on_wall then
        --if player.y + player.w/2 < self.y then
      if self.on_wall then
        if sx > bx then
          self.x = self.x - (self.w/2 + block.w/2 - dx);
          block.x = block.x - (block.w/2 + self.w/2 - dx);
          if block.vx > 0 then
          block.vx = 0.0---math.abs(player.vx)
          end
      elseif self.player_touch then
        if sx > bx then
          self.x = self.x - (self.w/2 + block.w/2 - dx);
          block.x = block.x - (block.w/2 + self.w/2 - dx);
          if block.vx > 0 then
          block.vx = 0.0---math.abs(player.vx)
        end
      end
        else
          self.x = self.x + (self.w/2 + block.w/2 - dx);
          block.x = block.x + (block.w/2 + self.w/2 - dx);
          if block.vx < 0 then
             block.vx = 0.0
          end--math.abs(player.vx)
        end
    else
      if bx > sx then
        self.x = self.x - (self.w/2 + block.w/2 - dx);
      else
        self.x = self.x + (self.w/2 + block.w/2 - dx);
      --end
    --end
    --else
    --  if sx > px then
    --    player.x = player.x - (player.w/2 + self.w/2 - dx);
    --  else
    --    player.x = player.x + (player.w/2 + self.w/2 - dx);
    --  end
    end
    end
    else
      if by > sy then
        self.y = self.y - (self.h/2 + block.h/2 - dy);
        self.vy = block.vy *2;
      else
        --self.y = self.y + (self.h/2 + player.h/2 - dy);
      end
    end
    return true;
  end
end
function Granade:explode(block)
if self.hit then
		  local cx = self.x + self.w/2;
  		local cy = self.y + self.h/2;
  		local closeX = cx;
  		local closeY = cy;
    if cx < block.x then
      closeX = block.x;
    end
    if cx > block.x + block.w then
      closeX = block.x + block.w;
    end
    if cy < block.y then
      closeY = block.y;
    end
    if cy > block.y + block.h then
      closeY = block.y + block.h;
    end

    local dis = math.sqrt((closeX -cx)*(closeX - cx) + (closeY - cy)*(closeY - cy));

    if dis < self.explosion_power then
      if self.type then
      local delta_x = cx - block.x + block.w/2;
      local delta_y = cy - block.y + block.h/2;
      block.vx = delta_x * (dis - self.explosion_power/2)
      block.vy = delta_y * (dis - self.explosion_power/2);
    elseif not self.type then
      local delta_x = cx - block.x + block.w/2;
      local delta_y = cy - block.y + block.h/2;
      block.vx = (-delta_x* dis)/2
      block.vy = (-delta_y* dis)/2
      end
      block.is_throwed = true;
      return true;
    else
        return false;
    end
	end
end
