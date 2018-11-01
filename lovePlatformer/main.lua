require ("Player");
require ("Platform");
require ("Block");
require ("Bullet");
function love.load(arg)
  -- body..



  Platforms = {};
  Platforms.platforms = {};
  Platforms.add = function(x,y,w,h)
    local p = Platform:create(x,y,h,w)
    table.insert(Platforms.platforms,p);
  end
  Blocks = {};
  Blocks.blocks =  {};
  Blocks.add = function(x,y)
    local b = Block:create(x,y,8);
    table.insert(Blocks.blocks, b);
  end
  Bullets = {};
  Bullets.bullets = {};
  Bullets.add = function(x,y,vx,vy)
    local b = Bullet:create(x,y,vx,vy);
    table.insert(Bullets.bullets,b);
  end
  Bullets.add_granade = function(x,y,vx,vy)
    local g = Granade:create(x,y,vx,vy);
    table.insert(Bullets.bullets,g);
  end


  Gravity = 7.5;

  scale = 3;

  -- IMAGES

  Box_image = love.graphics.newImage("img/box.png")
  Box_image:getWidth();
  Box_image:getHeight();
  -- IMAGES

  window_size = {};
  window_size.w = 360
  window_size.h = 240
  love.window.setMode(window_size.w*scale,window_size.h*scale,{resizable=false, vsync=false});

  player = Player:create(10,10,1);
  player2 = Player:create(20,20,2);
  Platforms.add(0,220,20,300);
  Platforms.add(50,190,20,50);


  local i = 0;
  while i < 20 do
    Blocks.add(love.math.random(10,340),love.math.random(10,190));
    i = i+1
  end

end
function love.keyreleased(key)
  if player.dead == false then
   if key == "s" then
     if not player.grabing then
     for _,v in pairs(Blocks.blocks) do
       player:grab_block(v);
     end
   else
     for _,v in pairs(Blocks.blocks) do
       if v.is_grabed == 1 then
         v.is_grabed = 0;
         v.is_throwed = true;
         if player.side then
         v.vx = player.throw_power;
         v.vy = player.throw_power/3;
       else
         v.vx = -player.throw_power;
         v.vy = -player.throw_power/3;
       end
         player.grabing = false;
       end
     end
   end
 end
end
if player2.dead == false then
   if key == "k" then
     if not player2.grabing then
     for _,v in pairs(Blocks.blocks) do
       player2:grab_block(v);
     end
   else
     for _,v in pairs(Blocks.blocks) do
       if v.is_grabed == 2 then
         v.is_grabed = 0;
         v.is_throwed = true;
         if player2.side then
         v.vx = player2.throw_power;
         v.vy = player2.throw_power/3;
       else
         v.vx = -player2.throw_power;
         v.vy = -player2.throw_power/3;
       end
         player2.grabing = false;
       end
     end
   end
 end
end
end
function love.update(dt)
  -- body...
    if player.dead == false then
    if love.keyboard.isDown("a") then
      player.vx = -player.speed;
    elseif love.keyboard.isDown("d") then
      player.vx = player.speed;
    else
      player.vx = 0.0;
    end
    if love.keyboard.isDown("w")then
      player:jump();
    end
    if love.keyboard.isDown("e")then
      player:attack(true,Bullets)
    elseif love.keyboard.isDown("q")then
      player:attack(false,Bullets)
    end
  end
  if player2.dead == false then
    if love.keyboard.isDown("j") then
      player2.vx = -player.speed;
    elseif love.keyboard.isDown("l") then
      player2.vx = player.speed;
    else
      player2.vx = 0.0;
    end
    if love.keyboard.isDown("i")then
      player2:jump();
    end
    if love.keyboard.isDown("u")then
      player2:attack(true,Bullets)
    elseif love.keyboard.isDown("o")then
      player2:attack(false,Bullets)
    end
  end
--  if love.keypressed("s") then
--  end
player.on_platform = false;
player2.on_platform = false;

  for _,v in pairs(Platforms.platforms) do
    if player.dead == false then
      player:platform_collsion(v);
      player:roof_collision(v);
      player:side_collsion(v);
    end
    if player2.dead == false then
      player2:platform_collsion(v);
      player2:roof_collision(v);
      player2:side_collsion(v);
    end
  end
  for _,v in pairs(Blocks.blocks) do
  --  player:grab_block(v);
      v.on_platform = false;
      v.on_wall = false;
      v:check_bad_touch(player);
      v:check_bad_touch(player2);
    for _,x in pairs(Platforms.platforms) do
      v:platform_collsion(x);
      v:roof_collision(x);
    if v:side_collsion(x) then
      v.on_wall = true;
    end
      if player.dead == false then
        v:player_colllsion(player);
      end
      if player2.dead == false then
        v:player_colllsion(player2);
      end
    end
    if v.is_grabed == 1 then
      v:update(dt,Gravity,player);
    elseif v.is_grabed == 2 then
      v:update(dt,Gravity,player2)
    else
      v:update(dt,Gravity,nil);
    end
  end

  for i,v in pairs(Blocks.blocks) do
    for j,x in pairs(Blocks.blocks) do
        if i == j then
        else
          if v.player_touch then
          else
            v:block_platform(x);
            v:player_colllsion(x)
          end
        end
    end
      if player.dead == false then
        player:block_platform(v);
      end
      if player2.dead == false then
        player2:block_platform(v);
      end
  end
  for _,v in pairs(Bullets.bullets) do
    if getmetatable(v)==Bullet then
       v:collision(x)
       if player.dead == false then
         if v:collision(player) then
           player.hp = player.hp - 1
         end
       end
       if player2.dead == false then
         if v:collision(player2) then
             player2.hp = player2.hp - 1
           end
       end
    end
    for _,x in pairs(Platforms.platforms) do
      if getmetatable(v)==Bullet then
         v:collision(x)
         if player.dead == false then
           if v:collision(player) then
             player.hp = player.hp - 1
           end
         end
         if player2.dead == false then
           if v:collision(player2) then
               player2.hp = player2.hp - 1
             end
         end
      elseif getmetatable(v)==Granade then
        v:platform_collsion(x);
        v:side_collsion(x);
        v:roof_collision(x);
      end
    end
    for _,x in pairs(Blocks.blocks) do
      if getmetatable(v)==Bullet then
        if v:collision(x) then
          x.hit = true;
        end
      elseif getmetatable(v)==Granade then
        v:player_colllsion(x);
      end
    end
  end
  for i,v in pairs(Bullets.bullets) do
    if getmetatable(v)==Bullet then
      if v.hit then
        table.remove(Bullets.bullets,i)
      end
    elseif getmetatable(v)==Granade then
      if v.hit then
        for _,x in pairs(Blocks.blocks) do
          if v:explode(x) then
            x.is_throwed = true;
          end
        end
        table.remove(Bullets.bullets,i);
      end
    end
  end
  --tested
  for i,v in pairs(Blocks.blocks) do
    if v.hit then
      table.remove(Blocks.blocks,i);
    end
  end
  for _,v in pairs(Bullets.bullets) do
    v:update(dt,Gravity);
   end
   if player.dead == false then
     player:block_platform(player2);
   end
   if player2.dead == false then
     player2:block_platform(player);
  end

  if player.dead == false then
    player:update(dt,Gravity);
  end
  if player.dead == false then
    player2:update(dt,Gravity);
  end
end
function love.draw()
  -- body...
  love.graphics.setColor(255, 0, 0, 255);
  love.graphics.print("FPS:"..love.timer.getFPS( ), 10, 20);
  if player.dead == false then
    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", player.x*scale, player.y*scale, player.w*scale, player.h*scale);
  end
  if player2.dead == false then
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle("fill", player2.x*scale, player2.y*scale, player2.w*scale, player2.h*scale);
  end
  --love.graphics.setColor(0, 0, 255, 255)
love.graphics.setColor(255,255,255,255);
  for _,v in pairs(Blocks.blocks) do
    love.graphics.draw(Box_image,v.x*scale,v.y*scale,0,v.w*scale/Box_image:getWidth(),v.h*scale/Box_image:getHeight());
    --love.graphics.rectangle("fill", v.x*scale, v.y*scale, v.w*scale, v.h*scale);
  end

  love.graphics.setColor(0, 255, 0, 255)
  for _,v in pairs(Platforms.platforms) do
      love.graphics.rectangle("fill",v.x*scale,v.y*scale,v.w*scale,v.h*scale);
  end

  love.graphics.setColor(255, 0, 0, 255);
  for _,v in pairs(Bullets.bullets)do
    love.graphics.rectangle("fill",v.x*scale, v.y *scale, v.w*scale, v.h*scale);
  end

end
