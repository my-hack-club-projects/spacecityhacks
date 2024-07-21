local oo = require 'libs.oo'
local Player = require 'game.states.Play.classes.player'

local Enemy = oo.class(Player)

function Enemy:aim(targets)
    -- return targets[math.random(1, #targets)] -- TODO: return a random target (self included)
    local targets = { self, table.unpack(targets) }
    local target = targets[math.random(1, #targets)]

    self.aimingAt = target
    self.aimed:dispatch(target)
    return target
end

function Enemy:turn(revolver, targets)
    self.isTurn = true
    self.turnChanged:dispatch(self)

    local target = self:aim(targets)

    self.game:defer(2, function()
        self.isTurn = false
        self:shoot(revolver, target, targets)
    end)
end

return Enemy
