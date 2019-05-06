local UserDataPackage = {}

UserDataPackage.userName = ""
UserDataPackage.uid = 0
UserDataPackage.playerInfo = {}  --个人信息
--[[
    playerInfo = {
        name = "",  --昵称
        level = 0,  --等级
        starDust = 0,--星尘
        techPoint = 0   --科技点
    }
]]
UserDataPackage.ownedGalaxyIds = {} --拥有占领的行星系id
UserDataPackage.exploredGalaxyIds = {} --已开图行星系id
UserDataPackage.Items = {}--物品列表，id对应数量,物品是指表格静态配置的道具、材料、金币...
UserDataPackage.ItemByType = {} --根据物品类型分类存储
UserDataPackage.ownedModList = {}--已有的模板数据

UserDataPackage.mapMarkList = {} --地图标记list

UserDataPackage.rewardTimeLeft = {curTime = -1, timeLeft = -1} --领取在线奖励剩余的秒数

return UserDataPackage