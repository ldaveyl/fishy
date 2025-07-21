local Score = {}

function Score:new()
    local score = {
        x = WINDOW_WIDTH / 2,
        y = WINDOW_HEIGHT * 0.05,
        score = 0,
        sx = 2,
        sy = 2
    }

    setmetatable(score, self)
    self.__index = self

    return score
end

function Score:increase_score(score_increase)
    self.score = self.score + score_increase
end

function Score:draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(FONT)
    love.graphics.print(self.score, self.x, self.y, 0, self.sx, self.sy)
    love.graphics.setColor(1, 1, 1, 1)
end

return Score
