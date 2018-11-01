Block = {};
Block.__index = Block;
function Block:create(x,y,w)
  local b = {};
  setmetatable(b, Block);
  b.x = x;
  b.y = y;
  b.w = w;
  b.h = w;
  b.vx = 0.0;
  b.vy = 0.0;
  b.on_platform = false;
  b.on_wall = false;
  b.player_touch = false;
  b.is_grabed = 0;
  b.is_throwed = false;
  b.hit = false;
  return b;
end
function Block:check_bad_touch(player)
  if self.x + self.w < player.x or self.y + self.h < player.y or player.x + player.w < self.x or player.y + player.h < self.y  then
    self.player_touch = false;
  else
    self.player_touch = true;
  end
end
function Block:update(dt,Gravity,player)
  if not self.on_platform then
    self.vy = self.vy + Gravity;
 end
  if self.is_throwed then
    if math.abs(self.vx) < 10 then
      self.vx = 0.0;
      self.is_throwed = false;
    end
    if self.vx > 0 then
      self.vx = self.vx -3
    elseif self.vx < 0 then
      self.vx = self.vx +3
    end
    if math.abs(self.vy) < 1.0 then
      self.vy = 0.0;
    end
  end
    if player == nil then
      self.x = self.x + self.vx*dt;
      self.y = self.y + self.vy*dt;
    else
        self.x = player.x;
        self.y = player.y - self.h;
    end
      if self.vy > 260 then
          self.vy = 260;
      end
end
function Block:platform_collsion(platform)
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
function Block:side_collsion(platform)
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
function Block:roof_collision(platform)
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
function Block:block_platform(platform)
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
function Block:player_colllsion(player)
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
        self.vy = player.vy *1.5;
      else
        --self.y = self.y + (self.h/2 + player.h/2 - dy);
      end
    end
    return true;
  end
end
function Block:block_colllsion(block)
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
      if px > sx then
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
      if py > sy then
        self.y = self.y - (self.h/2 + block.h/2 - dy);
        self.vy = block.vy *1.5;
      else
        --self.y = self.y + (self.h/2 + player.h/2 - dy);
      end
    end
    return true;
  end
end
function Block:block_platform(platform)
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
