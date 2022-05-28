dofile("utils.lua")

local colorsList = {
    colors.orange,
    colors.magenta,
    colors.lightBlue,
    colors.yellow,
    colors.lime,
    colors.pink,
    colors.cyan,
    colors.purple,
    colors.blue,
    colors.brown,
    colors.green,
    colors.red,
    colors.black,
    colors.white,
    colors.gray,
    colors.lightGray
}

-- Screen object, containing basic data about the screen
local Screen = {}
Screen.new = function(monitor)
    local self = {}
    self.width, self.height = term.getSize()
    if(monitor == nil) then
        self.output = term
    else
        self.output = monitor
    end
    
    function self.reset() -- Resets the screen to its default state
        self.output.setBackgroundColor(colors.black)
        self.output.setTextColor(colors.white)
        self.output.setCursorPos(1, 1)
        self.output.clear()
    end

    return self
end

local Button = {}
Button.new = function()
    local self = {}
    self.width = 5
    self.height = 3
    self.border = {1, 1, color=colors.red}
    
    self.draw = function(){

    }
    
    self.onClick = function(){
        
    }
    
    return self
end

a, b = 0, 0

-- Graphics object, most of the functions occur here
Graphics = {}
Graphics.new = function(func) -- initializes the Graphics object
    self = {
        loop = false, -- boolean for the status of the loop function
        x = 0,
        y = 0,
        t = "wooooooah", -- temporary text variable
        screen = nil, -- screen object
        blink = false, -- temporary blink variable
        eventData = {""}, -- collection of the events
        printFunc = nil, -- list of functions to print in the loop
        printFuncNum = nil, -- number of function to print in the loop
        printArgs = nil, -- parameters for the functions to print in the loop
        monitors = nil, -- list of available monitors
        window = nil, -- program's window
        term = nil -- original term object, used for restoration
    }
    self.loop = true -- boolean for the status of the loop function
    self.x = 0
    self.y = 0
    self.t = "wooooooah" -- temporary text variable
    --self.screen = Screen.new() -- screen object
    self.screen = nil
    self.blink = false -- temporary blink variable
    self.eventData = {""} -- collection of the events
    self.printFunc = nil -- list of functions to print in the loop
    --self.printFuncNum = 1 -- number of function to print in the loop
    self.printFuncNum = "init" -- selector of the current function to print in the loop
    self.printArgs = {self} -- parameters for the functions to print in the loop
    if(func == nil)
    then
        self.printFunc = {}
        self.printFunc = defaultPrint()
    else
        self.printFunc = func
    end

    
    function self.stop() -- stops the Graphics loop
        self.loop = false
    end

    function self.onStart() -- function on startup of Graphics

        --[[local isKey = false
        while not isKey do
            self.printBackground()
            print("Choose an output device: ")

            local eventData = {os.pullEvent()}
            local event = eventData[1]
        
            if event == "key" then
                isKey = true
            end
        end]]--

        --[[
        local completion = require "cc.completion"
        local history = { "potato", "orange", "apple" }
        local choices = { "apple", "orange", "banana", "strawberry" }
        write("> ")
        local msg = read(nil, history, function(text) return completion.choice(text, choices) end, "app")
        print(msg)
        ]]

        term.setCursorPos(Screen.new().width, 0)
        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.black)
        term.clear()
        print("Choose an output device: ")
        print("1) computer")
        self.monitors = {peripheral.find("monitor")}
        local i = 1
        for _, monitor in pairs(self.monitors) do
            monitor.setBackgroundColor(colorsList[i])
            monitor.clear()
            term.setTextColor(colorsList[i])
            i = i+1
            print(i..") monitor")
        end
        term.setTextColor(colors.black)
        --self.screen = Screen.new(self.monitors[1])
        --self.screen = Screen.new()
        while(self.screen == nil) do
            --local input = tonumber(read())-1

            self.activeEvents = {os.pullEvent()}
            if ( hasValue(self.activeEvents, "mouse_click") or hasValue(self.activeEvents, "monitor_touch") or hasValue(self.activeEvents, "monitor_touch"))
            then
                self.t = self.t.."jjj"
                self.stop()
            elseif (hasValue(self.activeEvents, "key")) then
                local input = tonumber(findValue(self.activeEvents, "key")-2)
                if(input == 0) then
                    self.screen = Screen.new(nil)
                    self.term = term.current()
                elseif (input >= 1 and input <= i-1) then
                    term.setBackgroundColor(colors.black)
                    term.clear()
                    term.setTextColor(colors.white)
                    self.screen = Screen.new(self.monitors[input])
                    self.term = term.redirect(self.monitors[input])
                end
            end
        end
        

        -- reset all the other monitors
        for _, monitor in pairs(self.monitors) do
            monitor.setBackgroundColor(colors.black)
            monitor.clear()
            monitor.setTextColor(colors.white)
        end


        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.purple)
    end
    
    function self.onFinish() -- function on closing of Graphics
        term.redirect(self.term)
        self.screen.reset()
        self.screen = Screen.new()
        self.screen.reset()
        print("Thank you for using BadLib!")
    end
    
    function self.onLoop() -- main loop function
        while(self.loop)
        do
            parallel.waitForAny (self.stopProgram, self.draw)
        end
    end
    
    function self.draw() -- main draw function
        self.printBackground() -- prints the background
        term.setCursorPos(self.screen.width+1, 0)
        --self.printFunc.init(self.printArgs)
        self.printFunc[self.printFuncNum](self.printArgs) -- prints the content
        --self.printFunc[self.printFuncNum](self.printArgs) -- prints the content
        coroutine.yield()
    end
    
    function self.printBackground()
        term.clear()
        term.setCursorPos(self.screen.width, 0)
    end

    function self.stopProgram()
        local tim = os.startTimer(0.05)
        self.activeEvents = {os.pullEvent()}
        if ( hasValue(self.activeEvents, "mouse_click") or hasValue(self.activeEvents, "monitor_touch"))
        then
            self.t = self.t.."jjj"
            self.stop()
        end
    end

    function self.setPrintArgs(args)
        self.printArgs = args
    end


    function self.init() -- starts the Graphics
        self.onStart()
        self.onLoop()
        self.onFinish()
    end

    function self.middleText(text)
        w, h = term.getSize()
        s = (#(text))/2
        term.setCursorPos(w/2-s, h/2)
        term.write(text)
    end
    
    return self
end


-- Default code for testing and showcasing purposes
counter = 0

function defaultPrint()
    return {
        init = function(args)
            if(args[1].blink)
            then
                local g = "false"
                paintutils.drawBox(2, 2, 5, 5, colors.green)
                term.setBackgroundColor(colors.white)
                term.setTextColor(colors.orange)
                if(args[1].loop)
                then 
                    g = "true"
                end
                term.setCursorPos(args[1].screen.width, 0)
            end
            args[1].blink = not (args[1].blink)

            args[1].middleText("Default function test - Ticks: "..counter)
            counter = counter + 1
        end 
    }
end
