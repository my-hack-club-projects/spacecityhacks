local oo = require 'libs.oo'

local Revolver = oo.class()

function Revolver:init()
    math.randomseed(os.time())

    self.bullets = 1
    self.nBullets = 6

    self.shots = 0
    self.cocked = false

    self.position = math.random(1, self.nBullets)

    self.chamber = {}

    -- load 1 bullet at a random position into the chamber
    local _loadedBullet = false
    local _bulletPosition = math.random(1, self.nBullets)
    for i = 1, self.nBullets do
        self.chamber[i] = i == _bulletPosition
    end

    for i, shot in ipairs(self.chamber) do
        print(i, shot)
    end
end

function Revolver:cock()
    self.position = self.position + 1
    if self.position > #self.chamber then
        self.position = 1
    end
    self.cocked = true
end

function Revolver:shoot()
    self.cocked = false
    self.shots = self.shots + 1
    print(self.position)
    local shot = self.chamber[self.position]
    return shot == true
end

function Revolver:isCocked()
    return self.cocked
end

return Revolver
