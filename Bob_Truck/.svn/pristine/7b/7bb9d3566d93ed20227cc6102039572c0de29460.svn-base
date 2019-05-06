local ListItem = register("ListItem", WidgetBase)

function ListItem:OnClick()
    LogDebug('ListItem OnClick dataIndex:{0}', self.dataIndex)
end

function ListItem:DrawCell(index, cellIndex, itemsCount)
    self.dataIndex = cellIndex * itemsCount + index + 1
    self.data = self.dataIndex
    --LogDebug('ListItem DrawCell data:{0}', self.data)
end

return ListItem