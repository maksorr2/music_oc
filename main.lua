local component = require("component")
local term = require("term")
local computer = require("computer")
local key = require("keyboard")
local shell = require("shell")
local sides = require("sides")
local filesystem = require("filesystem")
local unicode = require('unicode')

local rs = component.redstone
local tape = component.tape_drive
local gpu = component.gpu

local oldbg = gpu.getBackground()
local oldfg = gpu.getForeground()
local w, h = gpu.maxResolution()

--black or white
local theme = 'white'

--local colorLight = {
--    background = getColor('#'),
--    top = getColor('#'),
--    tline = getColor('#'),
--    font = getColor('#')
--}
--local colorBlack = {
--    background = getColor('#'),
--    top = getColor('#'),
--    tline = getColor('#'),
--    font = getColor('#')
--}

--function getColor(color)
--    return tonumber(color:sub(2),16)
--end

function drawPixel(x,y,bg,fg,text)
    gpu.setBackground(bg)
    gpu.setForeground(fg)
    gpu.set(x,y, tostring(text))
    gpu.setBackground(oldbg)
    gpu.setForeground(oldfg)
end
  
function drawRectangle(x, y, width, height, bg, fg, text, value)
    gpu.setBackground(bg)
    gpu.setForeground(fg)

    local topRightX = w - width
    local bottomLeft = h - 1
    local bottomRight = w - width
    local centerX = (w - width) // 2
    local centerY = (h // 2) - 1

    if value == "topLeft" then
        gpu.fill(x,y, width, height, text)
    elseif value == "topRight" then
        gpu.fill(topRightX,y,width, height, text)
    elseif value == "bottomLeft" then
        gpu.fill(x,bottomLeft,  width, height, text)
    elseif value == "bottomRight" then
        gpu.fill(bottomRight, bottomLeft,  width, height, text)
    elseif value == "centerX" then
        gpu.fill(centerX, y, width, height, text)
    elseif value == "center" then
        gpu.fill(centerX, centerY, width, height, text)
    end
    gpu.setBackground(oldbg)
    gpu.setForeground(oldfg)
end 

function drawString(text, x, y, bg, fg, value)
    local x = x or 0
    local y = y or 0
    local textLength = string.len(text)
    --local split = splitString(text)
  
    --print(split)
  
    local topRightX = w - textLength
    local bottomLeft = h - 1
    local bottomRight = w - textLength
    local centerX = (w - textLength) // 2
    local centerY = (h // 2) - 1
      
    if value == "topLeft" then
        drawPixel(x,y, bg, fg, text)
    elseif value == "topRight" then
        drawPixel(topRightX,y,bg,fg,text)
    elseif value == "bottomLeft" then
        drawPixel(x,bottomLeft, bg, fg, text)
    elseif value == "bottomRight" then
        drawPixel(bottomRight, bottomLeft, bg, fg, text)
    elseif value == "centerX" then
        drawPixel(centerX, y, bg, fg, text)
    elseif value == "centerY" then
        drawPixel(x, centerY, bg, fg, text)
    elseif value == "center" then
        gpu.fill(centerX, centerY, bg, fg, text)
    end
    return x, y, value
end

function checkTape()
    if not tape.isReady() then
        drawError('Insert tape!')
        os.sleep(0.5)
        term.clear()
    end
    return tape.isReady()
end

function exit()
    local tEvent = {event.pull("touch")}
    if tEvent[1] ~= nil then
        if tEvent[3] == 1 and tEvent[4] == 1 then
            drawString(language['exit'], nil, 49, 0x000000, 0xFFFFFF, "centerX")
            os.sleep(1)
            terminal.clear()
            os.exit()
        end
    end
end

function drawError(err)
    drawRectangle(w, 20, 60, 10, 0x990000, 0x000000, " ", "centerX")
    drawString(err, 78, h, 0x990000, 0x3C3C3C, "center")
    
end
--function drawUI()

--end

function main()
    while not tape.isReady() do
        drawError('Insert tape!')
    end
    term.clear()
    --drawUI()
    print('test')
end

while true do
    main()
end
