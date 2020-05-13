local icon = nil

function love.conf(t)
  t.console = true
  t.window.icon = icon
  t.window.title = "Gates To Hell"
  
end  

function ChangeIcon(filelocation)
  icon = filelocation
end  