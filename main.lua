dofile("graphics.lua")
--local vector = require "vector"

-- Screen object, containing basic data about the screen
Square = {}

Square.new = function(x, y, w, h)
    self = {
        x = 1,
        y = 1,
        width = 1,
        height = 1,
        vec = nil,
        draw = nil
    }
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.vec = vector.new(1, 0, 0)
    
    function self.bounce()
        local w, h = term.getSize()
        term.setCursorPos(3,7)
        print("x:"..self.x+self.width..", y:"..self.y..", w:"..w..", h:"..h..", Vx:"..self.vec.x)
        if(self.x + self.width >= w or self.x <= 1)
        then
            self.vec = self.vec:unm()
        end
    end
    
    function self.draw()
        print(self.x)
        paintutils.drawBox(self.x, self.y, self.x+self.width, self.y+self.height, colors.red)
        term.setBackgroundColor(colors.white)
    end
    
    return self
end


testSquareFuncInit = function (args)
    obj = args[1]
    sq = Square.new(3,5,4,4)
    obj.printArgs = {sq}
    -- obj.printFuncNum = obj.printFuncNum + 1
    obj.printFuncNum = "loop"
end
testSquareFuncLoop = function (args)
    sq = args[1]
    sq.draw()
    sq.bounce()
    sq.x = sq.x + sq.vec.x
end

functionMap = {
    init = testSquareFuncInit, loop = testSquareFuncLoop
}


--local g = Graphics.new(functionMap)
local g = Graphics.new(nil)
g.init()
