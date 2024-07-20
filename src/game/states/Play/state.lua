local oo = require 'libs.oo'
local State = require 'classes.state'
local Revolver = require('game.states.Play.classes.revolver')

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"

    self.revolver = Revolver()
    self.roundInterval = 2
end

function PlayState:enter(prevState)
    State.enter(self, prevState)

    self.canShoot = true

    self.mousePressedListener = self.game.signals.mousepressed:connect(function()
        if not self.canShoot then
            return
        end

        if self.revolver:isCocked() then
            local die = self.revolver:shoot()
            if die then
                print("player dies")
                return
            end
            -- enemies' turn
            self.game:defer(self.roundInterval, function()
                self.revolver:cock()
                print("Enemy cocked gun")
                local die = self.revolver:shoot()
                if die then
                    print("enemy dies")
                end
            end)
        else
            self.revolver:cock()
        end
    end)
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
