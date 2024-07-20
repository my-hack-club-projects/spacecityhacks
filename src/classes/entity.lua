local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'

local Entity = oo.class()

function Entity:init(props)
    self.name = props.name or "Entity"
    self.game = props.game or nil

    self.position = props.position or Vector2()
    self.size = props.size or Vector2()
    self.color = props.color or Color4()
    self.image = props.image or nil
    self.scaleAxis = props.scaleAxis
    self.zindex = props.zindex or 0

    assert(self.scaleAxis == "x" or self.scaleAxis == "y" or self.scaleAxis == nil, "Invalid scale axis")
end

function Entity.update()
end

function Entity:draw()
    local unitSize = self.game.UnitSize

    local w, h = self.size.x * unitSize, self.size.y * unitSize
    local x, y = self.position.x * unitSize, self.position.y * unitSize

    love.graphics.translate(x, y)
    love.graphics.setColor(self.color:unpack())

    if self.image then
        local scaleX = w / self.image:getWidth()
        local scaleY = h / self.image:getHeight()

        if self.scaleAxis == "x" then
            scaleY = scaleX
        elseif self.scaleAxis == "y" then
            scaleX = scaleY
        end

        local realSizeScaledX, realSizeScaledY = self.image:getWidth() * scaleX, self.image:getHeight() * scaleY

        love.graphics.draw(self.image, -realSizeScaledX / 2, -realSizeScaledY / 2, 0, scaleX, scaleY)
    else
        love.graphics.rectangle("fill", -w / 2, -h / 2, w, h)
    end
end

return Entity
