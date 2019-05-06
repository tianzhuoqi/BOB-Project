local MacroCommand = class("MacroCommand")

function MacroCommand:ctor()
	self.m_subCommands = {}
	self:InitializeMacroCommand()
end

function MacroCommand:Execute(notification)
	while #self.m_subCommands > 0 do
		local commandType = self.m_subCommands[0]
		local commandInstance = commandType.New()
		commandInstance:Execute(notification)
		table.remove(self.m_subCommands, 1)
	end
end

function MacroCommand:InitializeMacroCommand()
end

function MacroCommand:AddSubCommand(commandType)
    self.m_subCommands[#self.m_subCommands] = commandType
end

return MacroCommand
