local oo = require 'libs.oo'
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

    self.revolver = Revolver()
    self.roundInterval = 2
end

function PlayState:enter(prevState)
    State.enter(self, prevState)

    self.player = Player(self.game)
    self.enemy = Enemy(self.game)

    self.player.humanName = "Player"
    self.enemy.humanName = "Enemy"

    -- self.test = self.entity.new(
    --     Entity,
    --     {
    --         name = "Test",
    --         game = self.game,
    --         position = Vector2(1, 1),
    --         size = Vector2(5, 5),
    --         image = love.graphics.newImage("assets/images/revolver.png"),
    --         zindex = 999,
    --     }
    -- )

    self:loadImages()

    -- Player's turn is first
    self.player:turn(self.revolver, { self.player, self.enemy })
    -- When the player chooses who to shoot, the next enemy will be determined and the turn function will be called
end

function PlayState:loadImages()
    self.background = self.entity.new(
        Entity,
        {
            name = "Background",
            game = self.game,
            image = love.graphics.newImage("assets/images/background.png"),
            scaleAxis = "y",
        }
    )

    self.table = self.entity.new(
        Entity,
        {
            name = "Table",
            game = self.game,
            image = love.graphics.newImage("assets/images/table.png"),
            scaleAxis = "y",
            zindex = 1000,
        }
    )

    self.playerTest = self.entity.new(
        Entity,
        {
            name = "PlayerTest",
            game = self.game,
            position = Vector2(1, 7),
            size = Vector2(0, 15),
            image = love.graphics.newImage("assets/images/player.png"),
            scaleAxis = "y",
            zindex = 500
        }
    )

    self:sizeImages()
end

function PlayState:sizeImages()
    local size = self.camera:getUnitSize()

    self.background.size = size
    self.background.position = Vector2(0, 0)

    self.table.size = size
    self.table.position = Vector2(0, 0)
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
