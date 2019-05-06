local ListCell = register("ListCell", WidgetBase)

function ListCell:OnClick()
    LogDebug('ListCell OnClick dataIndex:{0}', self.dataIndex)
end

function ListCell:DrawCell(index)
    self.dataIndex = index + 1
    self.data = self.dataIndex
    --LogDebug('ListCell DrawCell data:{0}', self.data)
end

return ListCell