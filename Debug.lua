require 'class'

local Debug=class(function(self, level, length)
    self.level = level or info
    self.length = length or 20
    self.messages = {}
    self.messages['info'] = {}
    self.messages['warning'] = {}
    self.messages['error'] = {}
end)

function Debug:info(message)
    table.insert(self.messages['info'], message)
    self:trim('info')
end

function Debug:warning(message)
    table.insert(self.messages['warning'], message)
    self.trim('warning')
end

function Debug:error(message)
    table.insert(self.messages['error'], message)
    self.trim('error')
end

function Debug:draw()
    message = table.concat(self.messages[self.level], '\n')
    love.graphics.print(message, 0, 15)
end

function Debug:trim(level)
    if #self.messages[level] > self.length then
        table.remove(self.messages[level], 1)
    end
end

return Debug

