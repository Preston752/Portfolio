-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

------------------------------------------------------------------------------------------------------------

-- Variables

------------------------------------------------------------------------------------------------------------

-- Environment variables
local widget = require("widget")

-- Display groups
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Landscape orientation
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Sounds for touch animation
local mSound = audio.loadSound("mouth.mp3") -- mouth
local pfSound = audio.loadSound("pelvicFin.mp3") -- pelvic fin
local afSound = audio.loadSound("analFin.mp3") -- anal fin
local srSound = audio.loadSound("softRay.mp3") -- soft ray
local tSound = audio.loadSound("tail.mp3") -- tail 

-- Frames for animation
local options = {
    frames = {
        -- Main body: Static
        { x = 10, y = 10, width = 153, height = 70 },
        
        -- Mouth: 4 frames
        { x = 11, y = 93, width = 59, height = 43 },
        { x = 69, y = 94, width = 60, height = 41 },
        { x = 126, y = 92, width = 56, height = 55 },
        { x = 182, y = 92, width = 54, height = 56 },

        -- Pelvic Fin: 3 frames
        { x = 13, y = 217, width = 53, height = 29 },
        { x = 67, y = 218, width = 53, height = 27 },
        { x = 121, y = 219, width = 55, height = 25 },

        -- Top Fin: Static
        { x = 13, y = 255, width = 66, height = 35 },

        -- Anal Fin: 3 Frames
        { x = 83, y = 259, width = 60, height = 23 },
        { x = 177, y = 216, width = 70, height = 32 },
        { x = 248, y = 217, width = 70, height = 32 },

        -- Soft Ray: 3 Frames
        { x = 145, y = 259, width = 31, height = 25 },
        { x = 175, y = 258, width = 34, height = 27 },
        { x = 208, y = 260, width = 33, height = 25 },

        -- Tail: 5 Frames
        { x = 10, y = 150, width = 67, height = 53 },
        { x = 83, y = 149, width = 64, height = 55 },
        { x = 149, y = 150, width = 58, height = 53 },
        { x = 209, y = 150, width = 63, height = 52 },
        { x = 276, y = 150, width = 55, height = 53 },

    }
}

-- Fish image
local imageSheet = graphics.newImageSheet("fish.png", options)

-- Body group
local body = display.newGroup()
body.x = centerX
body.y = centerY

-- Sequence Data for animation
local sequenceData = {
    -- Default frames: mouth, pelvic fin, anal fin, soft ray and tail.
    { name = "mDefault", start = 2, count = 1 },
    { name = "pfDefault", start = 6, count = 1 },
    { name = "afDefault", start = 10, count = 1 },
    { name = "srDefault", start = 13, count = 1 },
    { name = "tDefault", start = 16, count = 1 },

    -- Mouth sequences
    { name = "mOpen", frames = {2, 3, 4, 5},  time = 400, loopCount = 1 },
    { name = "mClose", frames = { 5, 4, 3, 2 }, time = 400, loopCount = 1 },

    -- Pelvic Fin sequences
    { name = "pfOpen", frames = {6, 7, 8}, time = 400, loopCount = 1 },
    { name = "pfClose", frames = {8, 7, 6}, time = 400, loopCount = 1 },

    -- Anal Fin sequences
    { name = "afOpen", frames = {10, 11, 12}, time = 400, loopCount = 1 },
    { name = "afClose", frames = {12, 11, 10}, time = 400, loopCount = 1 },

    -- Soft Ray sequences
    { name = "srOpen", frames = {13, 14, 15}, time = 400, loopCount = 1 },
    { name = "srClose", frames = {15, 14, 13}, time = 400, loopCount = 1 },

    -- Tail sequences
    { name = "tOpen", frames = {16, 17, 18, 19, 20}, time = 400, loopCount = 1 },
    { name = "tClose", frames = {20, 19, 18, 17, 16}, time = 400, loopCount = 1 },
}

-- Create all static parts
local baseBody = display.newImageRect(imageSheet, 1, 153, 70)
local topFin = display.newImageRect(imageSheet, 9, 66, 35)

-- Create all animation parts
local mouth = display.newSprite(imageSheet, sequenceData)
local pelvicFin = display.newSprite(imageSheet, sequenceData)
local analFin = display.newSprite(imageSheet, sequenceData)
local softRay = display.newSprite(imageSheet, sequenceData)
local tail = display.newSprite(imageSheet, sequenceData)

-- Position of parts relative to the body
mouth.x = -56
mouth.y = 17

topFin.x = 35
topFin.y = -35

pelvicFin.x = -6
pelvicFin.y = 33

analFin.x = 68
analFin.y = 33

softRay.x = 66
softRay.y = -22

tail.x = 102
tail.y = 7

------------------------------------------------------------------------------------------------------------

-- Insert parts and join as a whole body

------------------------------------------------------------------------------------------------------------

-- Insert parts of body
body:insert(tail)      
body:insert(softRay)
body:insert(analFin)
body:insert(topFin)
body:insert(pelvicFin)
body:insert(mouth)     
body:insert(baseBody) 

-- Add everything to make whole body
mainGroup:insert(body)

------------------------------------------------------------------------------------------------------------

-- Animation initial states

------------------------------------------------------------------------------------------------------------

-- Set initial frames
mouth:setSequence("mDefault")
pelvicFin:setSequence("pfDefault")
analFin:setSequence("afDefault")
softRay:setSequence("srDefault")
tail:setSequence("tDefault")

-- Track animation direction states (open = forward and close = backward)
local mOpen = false -- mouth
local pfOpen = false -- pelvic fin
local afOpen = false -- anal fin
local srOpen = false -- soft ray
local tOpen = false -- tail

------------------------------------------------------------------------------------------------------------

--- Sliders

------------------------------------------------------------------------------------------------------------

-- Slider Labels

------------------------------------------------------------------------------------------------------------

-- Mouth label
local mLabel = display.newText({
    text = "Mouth",
    x = display.contentCenterX + 110,
    y = display.contentHeight - 140,
    font = native.systemFont,
    fontSize = 16,
})

-- Pelvic Fin label
local pfLabel = display.newText({
    text = "Pelvic Fin",
    x = display.contentCenterX + 100,
    y = display.contentHeight - 110,
    font = native.systemFont,
    fontSize = 16,
})

-- Anal Fin label
local afLabel = display.newText({
    text = "Anal Fin",
    x = display.contentCenterX + 105,
    y = display.contentHeight - 80,
    font = native.systemFont,
    fontSize = 16,
})

-- Soft Ray label
local srLabel = display.newText({
    text = "Soft Ray",
    x = display.contentCenterX + 103,
    y = display.contentHeight - 50,
    font = native.systemFont,
    fontSize = 16,
})

-- Tail label
local tLabel = display.newText({
    text = "Tail",
    x = display.contentCenterX + 122,
    y = display.contentHeight - 20,
    font = native.systemFont,
    fontSize = 16,
})

------------------------------------------------------------------------------------------------------------

-- Mouth 

------------------------------------------------------------------------------------------------------------

-- Mouth slider animation
local function onMouthEvent(event)
    if event and event.value then
        -- Map slider value (0-100) for frames (1-4) -> equally distributes frames
        local frame = math.floor(1 + (event.value / 100 * 3))
        mouth:setSequence("mOpen") -- mouth will open when I start sliding.
        mouth:setFrame(frame) -- sets the frame for animation
    end
end

-- Mouth slider
local mouthSlider = widget.newSlider({
    x = display.contentCenterX + 200,
    y = display.contentHeight - 140,
    width = 100,
    value = 0,
    listener = onMouthEvent,
})

------------------------------------------------------------------------------------------------------------

-- Pelvic Fin

------------------------------------------------------------------------------------------------------------


-- Pelvic Fin slider animation
local function onPfEvent(event)
    if event and event.value then
        -- Map slider value (0-100) for frames (1-3) -> equally distributes frames
        local frame = math.floor(1 + (event.value / 100 * 2))
        pelvicFin:setSequence("pfOpen") -- pelvic fin will open when I start sliding.
        pelvicFin:setFrame(frame) -- sets the frame for animation
    end
end

-- Pelvic Fin slider
local pfSlider = widget.newSlider({
    x = display.contentCenterX + 200,
    y = display.contentHeight - 110,
    width = 100,
    value = 0,
    listener = onPfEvent,
})

------------------------------------------------------------------------------------------------------------

-- Anal Fin

------------------------------------------------------------------------------------------------------------

-- Anal Fin slider animation
local function onAfEvent(event)
    if event and event.value then
        -- Map slider value (0-100) for frames (1-3) -> equally distributes frames
        local frame = math.floor(1 + (event.value / 100 * 2))
        analFin:setSequence("afOpen") -- anal fin will open when I start sliding.
        analFin:setFrame(frame) -- sets the frame for animation
    end
end

-- Anal Fin slider
local afSlider = widget.newSlider({
    x = display.contentCenterX + 200,
    y = display.contentHeight - 80,
    width = 100,
    value = 0,
    listener = onAfEvent,
})

------------------------------------------------------------------------------------------------------------

-- Soft Ray

------------------------------------------------------------------------------------------------------------

-- Soft Ray slider animation
local function onSrEvent(event)
    if event and event.value then
        -- Map slider value (0-100) for frames (1-3) -> equally distributes frames
        local frame = math.floor(1 + (event.value / 100 * 2))
        softRay:setSequence("srOpen") -- soft ray will open when I start sliding.
        softRay:setFrame(frame) -- sets the frame for animation
    end
end

-- Soft Ray slider
local srSlider = widget.newSlider({
    x = display.contentCenterX + 200,
    y = display.contentHeight - 50,
    width = 100,
    value = 0,
    listener = onSrEvent,
})

------------------------------------------------------------------------------------------------------------

-- Tail

------------------------------------------------------------------------------------------------------------

-- Tail slider animation
local function onTailEvent(event)
    if event and event.value then
        -- Map slider value (0-100) for frames (1-5) -> equally distributes frames
        local frame = math.floor(1 + (event.value / 100 * 4))
        tail:setSequence("tOpen") -- tail will open when I start sliding.
        tail:setFrame(frame) -- sets the frame for animation
    end
end

-- Tail slider
local tSlider = widget.newSlider({
    x = display.contentCenterX + 200,
    y = display.contentHeight - 20,
    width = 100,
    value = 0,
    listener = onTailEvent,
})

------------------------------------------------------------------------------------------------------------

-- Touch Event handlers: "Open" is forward animation and "Close" is backward animation

------------------------------------------------------------------------------------------------------------

-- Mouth
local function onMouthTouch(event)
    if event.phase == "began" then
        if not mOpen then
            mouth:setSequence("mOpen")
            mouth:play()
            audio.play(mSound)
            mOpen = true
        else
            mouth:setSequence("mClose")
            mouth:play()
            audio.play(mSound)
            mOpen = false
        end
        return true
    end
end

-- Pelvic Fin
local function onPfTouch(event)
    if event.phase == "began" then
        if not pfOpen then
            pelvicFin:setSequence("pfOpen")
            pelvicFin:play()
            audio.play(pfSound)
            pfOpen = true
        else
            pelvicFin:setSequence("pfClose")
            pelvicFin:play()
            audio.play(pfSound)
            pfOpen = false
        end
        return true
    end
end

-- Anal Fin
local function onAfTouch(event)
    if event.phase == "began" then
        if not afOpen then
            analFin:setSequence("afOpen")
            analFin:play()
            audio.play(afSound)
            afOpen = true
        else
            analFin:setSequence("afClose")
            analFin:play()
            audio.play(afSound)
            afOpen = false
        end
        return true
    end
end

-- Soft Ray
local function onSrTouch(event)
    if event.phase == "began" then
        if not srOpen then
            softRay:setSequence("srOpen")
            softRay:play()
            audio.play(srSound)
            srOpen = true
        else
            softRay:setSequence("srClose")
            softRay:play()
            audio.play(srSound)
            srOpen = false
        end
        return true
    end
end

-- Tail
local function onTailTouch(event)
    if event.phase == "began" then
        if not tOpen  then
            tail:setSequence("tOpen")
            tail:play()
            audio.play(tSound)
            tOpen = true
        else
            tail:setSequence("tClose")
            tail:play()
            audio.play(tSound)
            tOpen = false
        end
        return true
    end
end

------------------------------------------------------------------------------------------------------------

-- Radio Buttons

------------------------------------------------------------------------------------------------------------

-- Radio button group
local radioGroup = display.newGroup()
uiGroup:insert(radioGroup)

-- Background for radio buttons
local radioBg = display.newRoundedRect(radioGroup,
    100, -- x position
    235,  -- y position
    120, -- width
    80,  -- height
    10   -- corner radius
)

-- Semi-transparent dark background
radioBg:setFillColor(0.1, 0.1, 0.1, 0.8)

-- Create radio buttons 
local touchRadio = display.newCircle(radioGroup, 70, 220, 8)
local sliderRadio = display.newCircle(radioGroup, 70, 250, 8)

-- Function to remove all touch listeners
local function removeTouchListeners()
    mouth:removeEventListener("touch", onMouthTouch)
    pelvicFin:removeEventListener("touch", onPfTouch)
    analFin:removeEventListener("touch", onAfTouch)
    softRay:removeEventListener("touch", onSrTouch)
    tail:removeEventListener("touch", onTailTouch)
end

-- Function to add all touch listeners
local function addTouchListeners()
    mouth:addEventListener("touch", onMouthTouch)
    pelvicFin:addEventListener("touch", onPfTouch)
    analFin:addEventListener("touch", onAfTouch)
    softRay:addEventListener("touch", onSrTouch)
    tail:addEventListener("touch", onTailTouch)
end

    
-- Radio button selection
local function onRadioPress(event)
    -- Tracks which button is selected
    local switch = event.target
    
    -- Remove duplicate touch listeners
    removeTouchListeners()
    
    -- Update flags
    touchEnabled = (switch.id == "touch")
    slidersEnabled = (switch.id == "slider")
    
    -- Touch events
    if touchEnabled then
        addTouchListeners()
    end
    
    -- Sliders
    mouthSlider.isVisible = slidersEnabled
    mouthSlider.isEnabled = slidersEnabled
    pfSlider.isVisible = slidersEnabled
    pfSlider.isEnabled = slidersEnabled
    afSlider.isVisible = slidersEnabled
    afSlider.isEnabled = slidersEnabled
    srSlider.isVisible = slidersEnabled
    srSlider.isEnabled = slidersEnabled
    tSlider.isVisible = slidersEnabled
    tSlider.isEnabled = slidersEnabled

    -- Update radio button appearances with active/inactive states
    if touchEnabled then
        touchRadio:setFillColor(0.4, 0.6, 1)  -- Active blue
        sliderRadio:setFillColor(0, 0, 0)     -- Inactive black
    else
        touchRadio:setFillColor(0, 0, 0)      -- Inactive black
        sliderRadio:setFillColor(0.4, 0.6, 1) -- Active blue
    end
    
    return true
end


-- Radio Button Set Up
touchRadio:setFillColor(0.4, 0.6, 1) -- Active color for default
touchRadio.id = "touch"
touchRadio:addEventListener("tap", onRadioPress)

sliderRadio:setFillColor(0, 0, 0) -- Inactive color
sliderRadio.id = "slider"
sliderRadio:addEventListener("tap", onRadioPress)

-- Touch Radio Button Label
local touchLabel = display.newText({
    parent = radioGroup,
    text = "Touch",
    x = 110,
    y = 220,
    font = native.systemFont,
    fontSize = 16
})
touchLabel:setFillColor(1, 1, 1)


-- Slider Radio Button Label
local sliderLabel = display.newText({
    parent = radioGroup,
    text = "Slider",
    x = 110,
    y = 250,
    font = native.systemFont,
    fontSize = 16
})
sliderLabel:setFillColor(1, 1, 1)

-- Allows the radio buttons to be selected
local initialEvent = { target = touchRadio }
onRadioPress(initialEvent)

------------------------------------------------------------------------------------------------------------

-- Moving the whole body

------------------------------------------------------------------------------------------------------------

-- Random movement calculation
local function moveRandomly()
    local minX = display.contentWidth * 0.2
    local maxX = display.contentWidth * 0.8
    local minY = display.contentHeight * 0.2
    local maxY = display.contentHeight * 0.8
    
    local newX = math.random(math.ceil(minX), math.floor(maxX))
    local newY = math.random(math.ceil(minY), math.floor(maxY))
    
    -- Flip the fish based on movement direction
    if newX > body.x then
        body.xScale = -1
    else
        body.xScale = 1
    end
    
    -- Hesitate and then move the fish
    transition.to(body, {
        x = newX,
        y = newY,
        time = 2000,
        onComplete = function()
            timer.performWithDelay(1000, moveRandomly)
        end
    })
end

-- Start random movement of the whole body
moveRandomly()