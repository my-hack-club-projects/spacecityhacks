local oo = require 'libs.oo'
local mathf = require 'classes.mathf'
local State = require 'classes.state'

local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'

local Entity = require 'classes.entity'
local Camera = require 'classes.camera'

local Revolver = require('game.states.Play.classes.revolver')
local Player = require('game.states.Play.classes.player')
local Enemy = require('game.states.Play.classes.enemy')

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"

    self.camera = Camera(self.game)

    self.roundInterval = 2
    self.revolverPositionOffset = Vector2(5, -1)

    self.revolver = self.entity.new(Revolver, {
        game = self.game,
        position = Vector2(),
        size = Vector2(1, 1) * 5,
        scaleAxis = "y",
        zindex = 900,
    })
end

function PlayState:enter(prevState)
    State.enter(self, prevState)

    self.player = self.entity.new(Player, {
        game = self.game,
        name = "Player",
        image = love.graphics.newImage("assets/images/player.png"),
        scaleAxis = "y",
        zindex = 500,
    })

    self.enemy = self.entity.new(Enemy, {
        game = self.game,
        name = "Enemy",
        image = love.graphics.newImage("assets/images/enemy.png"),
        scaleAxis = "y",
        zindex = 500,
    })

    self.player.humanName = "Player"
    self.enemy.humanName = "Enemy"

    self:loadImages()

    self.onResize = self.game.signals.resize:connect(function()
        self:sizeImages()
    end)

    self.player.turnChanged:connect(self.turnChanged, self)
    self.enemy.turnChanged:connect(self.turnChanged, self)

    self.player.aimed:connect(self.aimed, self)
    self.enemy.aimed:connect(self.aimed, self)

    -- Player's turn is first
    self.player:turn(self.revolver, { self.player, self.enemy })
    -- When the player chooses who to shoot, the next enemy will be determined and the turn function will be called
end

function PlayState:turnChanged(entity)
    -- entity is who has the turn now

    self.revolver.position = entity.position + self.revolverPositionOffset * Vector2(-mathf.sign(entity.position.x), 1)
    self.revolver.size = Vector2(math.abs(self.revolver.size.x) * mathf.sign(entity.position.x), self.revolver.size.y)
    self.revolver.rotation = -35
end

function PlayState:aimed(entity)
    -- aim the gun at the entity
    local target = entity.aimingAt
    local xDirection = (target == entity and -1 or 1) * (target == self.player and 1 or -1)
    local angle = xDirection * (target == entity and 0 or 145)

    self.revolver.rotation = math.rad(angle)
    self.revolver.size = Vector2(math.abs(self.revolver.size.x) * xDirection, self.revolver.size.y)
end

function PlayState:loadImages()
    self.background = self.entity.new(
        Entity,
        {
            name = "Background",
            game = self.game,
            image = love.graphics.newImage("assets/images/background.png"),
            zindex = 0,
        }
    )

    self.table = self.entity.new(
        Entity,
        {
            name = "Table",
            game = self.game,
            image = love.graphics.newImage("assets/images/table.png"),
            zindex = 1000,
        }
    )

    self.revolver.image = love.graphics.newImage("assets/images/revolver.png")

    -- self.revolverImage = self.entity.new(
    --     Entity,
    --     {
    --         name = "Revolver",
    --         game = self.game,
    --         image = love.graphics.newImage("assets/images/revolver.png"),
    --         size = Vector2(1, 1) * 5,
    --         zindex = 1000,
    --     }
    -- )

    self:sizeImages()
end

function PlayState:sizeImages()
    local size = self.camera:getUnitSize()
    local aspect = size.x / size.y
    local bgAspect = self.background.image:getWidth() / self.background.image:getHeight()
    local bigFits = aspect > bgAspect

    self.background.size = size
    self.background.position = Vector2(0, size.y)
    self.background.anchorPoint = Vector2(0.5, 0)
    self.background.scaleAxis = bigFits and "x" or "y"

    self.table.size = size
    self.table.position = Vector2(0, size.y)
    self.table.anchorPoint = Vector2(0.5, 0)
    self.table.scaleAxis = bigFits and "x" or "y"

    local playersSize = size / 2

    self.player.size = playersSize
    self.enemy.size = playersSize

    local playersY = size.y / 2 - playersSize.y / 2
    local playersX = size.x / 4

    self.player.position = Vector2.new(-playersX, playersY)
    self.enemy.position = Vector2.new(playersX, playersY)
end

function PlayState:exit()
    State.exit(self)
end

function PlayState:update(dt)
    State.update(self, dt)
end

function PlayState:draw()
    State.draw(self)
end

return PlayState
