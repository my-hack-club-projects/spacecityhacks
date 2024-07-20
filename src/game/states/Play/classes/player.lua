local oo = require 'libs.oo'
local Entity = require 'classes.entity'

local Player = oo.class(Entity)

function Player:init(props)
    Entity.init(self, props)

    self.isTurn = false
    self.aimingAt = nil
    self.alive = true
end

function Player:findNext(targets)
    local index
    do
        for i, target in ipairs(targets) do
            if target == self then
                index = i + 1 -- The next target
            end
        end
    end

    if index > #targets then
        index = 1
    end

    return targets[index]
end

function Player:aim(targets)
    -- TODO: Display a UI dialogue asking the player who they want to aim at
    -- should show a "YOURSELF" button and a button for each target
    -- function must return a Player object

    -- placeholder code (always aim at yourself)
    self.aimingAt = self
    return self
end

function Player:shoot(revolver, target, targets)
    local kill = revolver:shoot()

    if kill then
        target:die()
    else
        print("Target survives")
        self:findNext(targets):turn(revolver, targets)
    end
end

function Player:turn(revolver, targets)
    self.isTurn = true

    local target = self:aim(targets)

    local listener
    listener = self.game.signals.mousepressed:connect(function()
        if revolver.cocked then
            -- Shoot the revolver
            self.isTurn = false
            listener:disconnect()

            self:shoot(revolver, target, targets)
        else
            -- Cock the revolver
            print("Revolver cocked")
            revolver:cock()
        end
    end)
end

function Player:die()
    print(self.name .. " dies")
    self.alive = false
end

return Player
