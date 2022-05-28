function hasValue (tab, val)
    if (tab ~= nil and not (next(tab) == nil))
    then
        for index, value in ipairs(tab) do
            if value == val then
                return true
            end
        end
    end

    return false
end

function printArr(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(printArr(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n"..printArr(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..tostring(value).."\n"
        end
    end
    return str
end

function findValue(arr, event)
    if (arr == nil or event == nil) then
        return arr
    end

    local i = 1
    printArr(arr)
    for index,value in pairs(arr) do
        if(value == event) then
            return arr[i+1]
        end
        i = i+1
    end

    return nil
end