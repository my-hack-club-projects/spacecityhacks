local oo = require 'libs.oo'
local State = require 'classes.state'

local Revolver = require('game.states.Play.classes.revolver')
local Player = require('game.states.Play.classes.player')
local Enemy = require('game.states.Play.classes.enemy')

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"

    self.revolver = Revolver()
    self.roundInterval = 2
end

function PlayState:enter(prevState)
    State.enter(self, prevState)

    self.player = Player(self.game)
    self.enemy = Enemy(self.game)

    self.player.humanName = "Player"
    self.enemy.humanName = "Enemy"

    -- Player's turn is first
    self.player:turn(self.revolver, { self.player, self.enemy })
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
