function DrawWorld(world)

  local lenght = 0

for index1, value1 in pairs (world) do
--  if index1 == "ground4" then
  -- print(value1.position.x)
 -- print(GetPlayer().position.x + value1.position.x)
 -- print(love.graphics:getWidth())
--end
  --if (value1.position.x - GetPlayer().position.x) < love.graphics:getWidth() and (value1.position.x - GetPlayer().position.x) > - love.graphics:getWidth() then--love.graphics:getWidth() / 4
  
  if value1["image"] ~= nil then
  image.new(value1["image"], value1["position"]["x"], value1["position"]["y"], 0, value1["size"]["x"], value1["size"]["y"])
  end

  if value1["image"] == nil then
  love.graphics.rectangle("fill", value1["position"]["x"], value1["position"]["y"], value1["size"]["x"], value1["size"]["y"])
  end
 end

end