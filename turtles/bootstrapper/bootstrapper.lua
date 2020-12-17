term.clear()
term.setCursorPos(1,1)
print("Initializing Turtle Bootstrapper v1.0")

local home = vector.new(gps.locate(5))
local heading = 0

local SERVER = 450
local TURTLE = 453
local modem = peripheral.wrap("left")

-- Table of binaries that will need to be grabbed upon boot up
local bin = {}
bin[1] = {id = "XnPqX18Y", name = "Quarry API", file = "quarry"}
bin[2] = {id = "cisr7dN7", name = "Quarry Inventory Manager API", file = "quarryInventoryManager"}
bin[3] = {id = "39Lp1367", name = "Turtle Navigator API", file = "turtleNavigator"}

-- Poll Pastebin for the necessary binaries and save them to a file on the root directory
function getNecessaryBinaries()
    if not http then
        error("Server has HTTP functionality disabled, cannot continue")
        os.exit()
    end

    for i = 1, #bin do
        print("Fetching binary", bin[i].name)
        local response = http.get("http://pastebin.com/raw.php?i="..textutils.urlEncode(bin[i].id))
        if response then
            local content = response.readAll() -- Read the pastebin contents into a variable

            -- Create the binary file
            local binary = fs.open(bin[i].file, "w")
            binary.write(content)
            binary.close()
            print("Successfully fetched binary", bin[i].name)
        else
            print("Could not fetch binary", bin[i].name)
        end
    end
end

-- Load all the binaries into memory so that the quarry software can be called and executed
function loadBinaries()
    for i = 1, #bin do
        print("Loading binary", bin[i].name)
        os.loadAPI(bin[i].file)
    end
end

function bootRefuel()
    turtle.suckDown(16)
    turtle.select(2)
    turtle.refuel()
    turtle.select(1)
end

function turtleQuarry()
    print("All binaries loaded, executing quarry payload")
    local taskInfo = getTaskDetail()
    local destination = vector.new(taskInfo[2],taskInfo[3]+1,taskInfo[4])
    local safeZone

    sleep(2)
    bootRefuel()
    heading = turtleNavigator.getHeading()
    turtle.down()
    turtle.down()
    safeZone = vector.new(gps.locate(5))

    heading = turtleNavigator.travelToDestination(destination, heading)

    heading = turtleNavigator.changeHeading(heading, 270)
    turtle.digDown()
    turtle.down()

    --BUG FIXING DISAPPEARING TURTLES! THEY ARE BEING CANNIBALIZED DURING MINING DUE TO THREAD ERRORS
    quarry.quarry(taskInfo[6], taskInfo[5], taskInfo[7])
    print("Quarrying finished, returning home")

    -- Send TASK FINISHED signal
    modem.transmit(SERVER,TURTLE,"FINISHED"..tostring(taskInfo[1]))

    -- Navigate back to home
    heading = turtleNavigator.returnHome(safeZone, heading)
    turtleNavigator.returnHome(home, heading)

    -- Empty out the inventory one last time to clear up random junk picked up during return
    if quarryInventoryManager.getInventoryStatus() > 10 then
        quarryInventoryManager.emptyInventory()
    end

    -- Send collection command
    modem.transmit(SERVER,TURTLE,"COLLECT")
end

-- Get the task data relevant to
function getTaskDetail()
    -- Tell server that I am ready to receive task data
    print("Contacting home for quarry detail")
    modem.transmit(SERVER,TURTLE,"READY")

    -- Receive task data
    modem.open(TURTLE)
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    modem.close(TURTLE)

    print("Quarry details received")
    return message
end

getNecessaryBinaries()
loadBinaries()
turtleQuarry()
