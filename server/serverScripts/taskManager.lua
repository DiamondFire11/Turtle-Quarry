---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Will.
--- DateTime: 11/26/2020 6:54 PM
---

taskDaemon = {}
taskDaemon.__index = taskDaemon

-- New task constructor.  Will create a new task object and then return the newly created task
function taskDaemon:newEvent(mode, length, width, depth, segmentationSize, x, y, z)
    local event = {}
    setmetatable(event, taskDaemon)

    event.mode = mode
    event.length = tonumber(length)
    event.width = tonumber(width)
    event.depth = tonumber(depth)
    event.segmentationSize = tonumber(segmentationSize)
    event.quarryType = ""
    event.s = 0

    event.x = tonumber(x)
    event.y = tonumber(y)
    event.z = tonumber(z)

    event.status = "INITIALIZE"
    event.level = level

    event.turtlesDeployed = 0
    event.areTurtlesRecalled = false

    event.completionPercent = 0

    return event
end

-- Updates task completion percentage
function taskDaemon:setTaskCompletion(percent)
    self.completionPercent = percent
end

-- Setter method for task status
function taskDaemon:setStatus(status)
    self.status = status:upper()
end

function taskDaemon:setSegmentationSize(size)
    self.segmentationSize = tonumber(size)
end

function taskDaemon:addTurtle()
    self.turtlesDeployed = self.turtlesDeployed + 1
end

function taskDaemon:removeTurtle()
    self.turtlesDeployed = self.turtlesDeployed - 1
end

function taskDaemon:setSValue(s)
    self.s = s
end

function taskDaemon:setQuarryType(type)
    self.quarryType = type
end

-- Gets the valued ore for the task, thus denoting the y-level in which the turtle will quarry at
function taskDaemon:getLevel()
    return self.level
end

function taskDaemon:getSValue()
    return self.s
end

function taskDaemon:getQuarryType()
    return self.quarryType
end

function taskDaemon:getTurtleCount()
    return self.turtlesDeployed
end

-- Returns a percentage value denoting how far along the quarry is.
-- Necessary for on screen progress bar
function taskDaemon:getTaskCompletion()
    return self.completionPercent
end

function taskDaemon:getSegmentationSize()
    return self.segmentationSize
end

-- Returns current operating status of the task
function taskDaemon:getStatus()
    return self.status
end

function taskDaemon:getLength()
    return self.length
end

function taskDaemon:getWidth()
    return self.width
end

function taskDaemon:getDepth()
    return self.depth
end

function taskDaemon:getX()
    return self.x
end

function taskDaemon:getY()
    return self.y
end

function taskDaemon:getZ()
    return self.z
end