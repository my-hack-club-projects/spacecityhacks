local oo = require 'libs.oo'
local State = require 'classes.state'

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"
end

function PlayState:enter(prevState)
    State.enter(self, prevState)
end

function PlayState:exit()
    State.exit(self)
end

function PlayState:update(dt)
    State.update(self, dt)
end

function PlayState:draw()
    State.draw(self)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("DemoState", 10, 10)
end

return PlayState
