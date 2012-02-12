require 'class'

local Debug=class(function(self, level)
    if not level then level = 'info' end
    self.level = level
    self.messages = {}
    self.messages['info'] = ''
    self.messages['warning'] = ''
    self.messages['error'] = ''
end)

function Debug:info(message)
    self.messages['info'] = self.messages['info'] .. message .. '\n'
end

function Debug:warning(message)
    self.messages['warning'] = self.messages['warning'] .. message .. '\n'
end

function Debug:error(message)
    self.messages['error'] = self.messages['error'] .. message .. '\n'
end

function Debug:draw()
    love.graphics.print(self.messages[self.level], 0, 15)
end

return Debug

