local oo = require 'libs.oo'
local Player = require 'game.states.Play.classes.player'

local Enemy = oo.class(Player)

function Enemy:aim(targets)
    -- return targets[math.random(1, #targets)] -- TODO: return a random target (self included)

    return self
end

function Enemy:turn(revolver, targets)
    local target = self:aim(targets)

    self.game:defer(2, function()
        print("Enemy cocks revolver")
        revolver:cock()

        self.game:defer(2, function()
            self:shoot(revolver, target, targets)
        end)
    end)
end

return Enemy
