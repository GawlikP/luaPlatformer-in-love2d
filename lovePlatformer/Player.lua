Player = {};
Player.__index = Player;
function Player:create(x,y,id)
  local p = {};
  setmetatable(p, Player);
  p.x = x;
  p.y = y;
  p.w = 8;
  p.h = 8;
  p.speed = 100;
  p.vx = 0.0;
  p.vy = 0.0;
  p.on_platform = false;
  p.jumping = false;
  p.falling = false;
  p.can_jump = false;
  p.jump_speed = -150;
  p.grabing = false;
  p.throw_power = 200;
  p.side = false;
  p.attack_timer = 0;
  p.attack_speed = 10;
  p.can_attack = false;
  p.gun = "granade";
  p.ammuniton = 50;
  p.id = id;
  p.hp = 10;
  p.dmg = 1;
  p.dead = false;
  return p;
end
function Player:Block_touching(block)
  if self.x + self.w < block.x or self.y + self.h < block.y or block.x + block.w < self.x or block.y + block.h < self.y  then
    return false;
  else
    return true;
  end
end
function Player:attack(side,table)

  if self.can_attack then

    if side then
    if self.gun == "pistol" then
      table.add(self.x+self.w+2,self.y + self.h+2 /2,100,-100);
    elseif self.gun == "shotgun" then
      local i = 0;
      while(i < 10) do
      table.add(self.x+self.w+2,self.y + self.h/2 +2,100,-140+i*20)
      i= i +1;
      end
    elseif self.gun == "granade" then
      table.add_granade(self.x+self.w,self.y + self.h /2,100,-100);
    end
  self.attack_timer = 0.0;
  self.can_attack = false;
elseif not side then
  if self.gun == "pistol" then
    table.add(self.x-2,self.y + self.h /2+2,-100,-100);
  elseif self.gun == "shotgun" then
    local i = 0;
    while(i < 10) do
    table.add(self.x-3,self.y + self.h/2+2,-100,-140+i*20)
    i= i +1;
    end
  elseif self.gun == "granade" then
    table.add_granade(self.x-2,self.y + self.h /2,-100,-100);
  end
  self.attack_timer = 0.0;
  self.can_attack = false;
    end
  end
end
function Player:grab_block(block)
  if self.grabing == false then
    if self:Block_touching(block) then
      block.is_grabed = self.id;
      self.grabing = true;
    end
  end
end
function Player:jump()
  if self.on_platform then
    self.on_platform = false;
    self.jumping = true;
    self.vy = self.jump_speed;
  end
end
function Player:platform_collsion(platform)
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
function Player:block_platform(platform)
--  if platform.on_platform then
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
--end
end
function Player:side_collsion(platform)
  if self.x + self.w < platform.x or self.y + self.h < platform.y or platform.x + platform.w < self.x or platform.y + platform.h < self.y  then
    return false
  else
    if self.y < platform.y + platform.h and self.y + self.h > platform.y then
        if self.x + self.w < platform.x + platform.w/2 then
            self.vx = -self.vx;
        elseif self.x > platform.x + platform.w/2 then
            self.vx = math.abs(self.vx);
        end
    end
end
end
function Player:roof_collision(platform)
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
function Player:update(dt,gravity)
  if self.attack_timer > self.attack_speed then
    self.can_attack = true;
  end
  if not self.can_attack and self.attack_timer < self.attack_speed then
    self.attack_timer = self.attack_timer + dt*50;
  end

  if not self.on_platform then
      self.vy = self.vy + gravity;
  end
  if self.jumping then
    if self.vy > 0 then
      self.jumping = false;
    end
  end
  if self.vx > 0 then
    self.side = true
  elseif self.vx < 0 then
    self.side = false;
  end
  if self.hp < 0 then
    self.dead = true;
  end
  self.x = self.x + self.vx * dt;
  self.y = self.y + self.vy * dt;
end
function Player:draw()

end


function getImageScaleForNewDimensions( image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end
