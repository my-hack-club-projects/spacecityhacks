local oo = require 'libs.oo'

local Revolver = oo.class()

function Revolver:init()
    self.bullets = 6
    self.shots = 0
    self.cocked = false

    self.position = math.random(1, self.bullets)

    self.chamber = {}
    for i = 1, self.bullets do
        self.chamber[i] = math.random(1, 2) == 1
    end
end

function Revolver:cock()
    self.position = self.position + 1
    if self.position > self.bullets then
        self.position = 1
    end
    self.cocked = true
end

function Revolver:shoot()
    self.cocked = false
    self.shots = self.shots + 1
    local shot = self.chamber[self.position]
    return shot
end

function Revolver:isCocked()
    return self.cocked
end

return Revolver
