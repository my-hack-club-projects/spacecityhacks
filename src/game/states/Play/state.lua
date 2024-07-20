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

    -- self.canShoot = true

    -- self.mousePressedListener = self.game.signals.mousepressed:connect(function()
    --     if not self.canShoot then
    --         return
    --     end

    --     if self.revolver:isCocked() then
    --         print("cocked, shooting")
    --         self.canShoot = false

    --         local playerDies = self.revolver:shoot()

    --         if playerDies then
    --             print("player dies")
    --             return
    --         end

    --         print("player lives")

    --         -- enemy's turn
    --         self.game:defer(self.roundInterval, function()
    --             self.revolver:cock()

    --             print("Enemy cocked gun")

    --             local enemyDies = self.revolver:shoot()

    --             if enemyDies then
    --                 print("enemy dies")
    --                 return
    --             end

    --             print("enemy lives")

    --             self.canShoot = true
    --         end)
    --     else
    --         print("Player cocked gun")
    --         self.revolver:cock()
    --     end
    -- end)

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

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("DemoState", 10, 10)
end

return PlayState
