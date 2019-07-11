local maxsend = 60000

function net.WriteBuffer(data)
    if type(data) ~= "table" then
        dtype = type(data)
        data = {data}
    else
        dtype = "table"
    end

    local comp = util.Compress(util.TableToJSON(data))
    local length = string.len(comp)
    local bits = math.ceil(length / maxsend)
    local startbyte = 0
    local typesent = false

    for i = 1, bits do
        local endbyte = math.min(startbyte + maxsend, length)
        local size = endbyte - startbyte

        if not typesent then
            net.WriteString(dtype)
            typesent = true
        end

        net.WriteBool(i == bits)
        net.WriteUInt(size, 16)
        net.WriteData(comp:sub(startbyte + 1, endbyte + 1), size)
    end
end

function net.ReadBuffer(buffer)
    buffer = buffer or ""
    local dtype = net.ReadString(dtype)
    local done = net.ReadBool()
    local length = net.ReadUInt(16)
    local data = net.ReadData(length)
    buffer = buffer .. data

    if not done then
        return net.ReadBuffer(buffer)
    else
        local data = util.Decompress(buffer)

        if dtype == "table" then
            return util.JSONToTable(data)
        else
            return unpack(util.JSONToTable(data))
        end
    end
end