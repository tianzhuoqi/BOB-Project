local languageMap = {
    ["ResZYS"] = "粒子",
    ["ResZYSDtl"] = "粒子是一种...",
    ["ResJS"] = "物质",
    ["ResJSDtl"] = "物质是一种...",
    ["ResYT"] = "溶液",
    ["ResYTDtl"] = "溶液是一种...",
    ["ResJT"] = "晶体",
    ["ResJTDtl"] = "晶体是一种",
    ["ResZYS1"] = "初级粒子",
    ["ResZYS2"] = "中级粒子",
    ["ResZYS3"] = "高级粒子",
    ["ResZYS4"] = "复合粒子",
    ["ResZYS5"] = "突变粒子",
    ["ResZYS6"] = "核粒子",
    ["ResZYS7"] = "场粒子",
    ["ResZYS8"] = "热粒子",
    ["ResZYS9"] = "量子粒子",
    ["ResZYS10"] = "高维粒子",
    ["ResZYS11"] = "多态粒子",
    ["ResZYS12"] = "混沌粒子",
    ["ResZYS13"] = "绝对粒子",
    ["ResZYS14"] = "反粒子",
    ["ResZYS15"] = "暗粒子",
    ["ResZYS16"] = "虚无粒子",
    ["ResZYS17"] = "未来粒子",
    ["ResZYS18"] = "未知粒子",
    ["ResZYS19"] = "无尽粒子",
    ["ResZYS20"] = "起源粒子",
    ["ResJS1"] = "初级物质",
    ["ResJS2"] = "中级物质",
    ["ResJS3"] = "高级物质",
    ["ResJS4"] = "复合物质",
    ["ResJS5"] = "突变物质",
    ["ResJS6"] = "核物质",
    ["ResJS7"] = "场物质",
    ["ResJS8"] = "热物质",
    ["ResJS9"] = "量子物质",
    ["ResJS10"] = "高维物质",
    ["ResJS11"] = "多态物质",
    ["ResJS12"] = "混沌物质",
    ["ResJS13"] = "绝对物质",
    ["ResJS14"] = "反物质",
    ["ResJS15"] = "暗物质",
    ["ResJS16"] = "虚无物质",
    ["ResJS17"] = "未来物质",
    ["ResJS18"] = "未知物质",
    ["ResJS19"] = "无尽物质",
    ["ResJS20"] = "起源物质",
    ["ResYT1"] = "初级溶液",
    ["ResYT2"] = "中级溶液",
    ["ResYT3"] = "高级溶液",
    ["ResYT4"] = "复合溶液",
    ["ResYT5"] = "突变溶液",
    ["ResYT6"] = "核溶液",
    ["ResYT7"] = "场溶液",
    ["ResYT8"] = "热溶液",
    ["ResYT9"] = "量子溶液",
    ["ResYT10"] = "高维溶液",
    ["ResYT11"] = "多态溶液",
    ["ResYT12"] = "混沌溶液",
    ["ResYT13"] = "绝对溶液",
    ["ResYT14"] = "反溶液",
    ["ResYT15"] = "暗溶液",
    ["ResYT16"] = "虚无溶液",
    ["ResYT17"] = "未来溶液",
    ["ResYT18"] = "未知溶液",
    ["ResYT19"] = "无尽溶液",
    ["ResYT20"] = "起源溶液",
    ["ResJT1"] = "初级晶体",
    ["ResJT2"] = "中级晶体",
    ["ResJT3"] = "高级晶体",
    ["ResJT4"] = "复合晶体",
    ["ResJT5"] = "突变晶体",
    ["ResJT6"] = "核晶体",
    ["ResJT7"] = "场晶体",
    ["ResJT8"] = "热晶体",
    ["ResJT9"] = "量子晶体",
    ["ResJT10"] = "高维晶体",
    ["ResJT11"] = "多态晶体",
    ["ResJT12"] = "混沌晶体",
    ["ResJT13"] = "绝对晶体",
    ["ResJT14"] = "反晶体",
    ["ResJT15"] = "暗晶体",
    ["ResJT16"] = "虚无晶体",
    ["ResJT17"] = "未来晶体",
    ["ResJT18"] = "未知晶体",
    ["ResJT19"] = "无尽晶体",
    ["ResJT20"] = "起源晶体",
    ["ResZYS1Dtl"] = "初级粒子是一种…",
    ["ResZYS2Dtl"] = "中级粒子是一种…",
    ["ResZYS3Dtl"] = "高级粒子是一种…",
    ["ResZYS4Dtl"] = "复合粒子是一种…",
    ["ResZYS5Dtl"] = "突变粒子是一种…",
    ["ResZYS6Dtl"] = "核粒子是一种…",
    ["ResZYS7Dtl"] = "场粒子是一种…",
    ["ResZYS8Dtl"] = "热粒子是一种…",
    ["ResZYS9Dtl"] = "量子粒子是一种…",
    ["ResZYS10Dtl"] = "高维粒子是一种…",
    ["ResZYS11Dtl"] = "多态粒子是一种…",
    ["ResZYS12Dtl"] = "10级重元素是一种...",
    ["ResZYS13Dtl"] = "11级重元素是一种...",
    ["ResZYS14Dtl"] = "10级重元素是一种...",
    ["ResZYS15Dtl"] = "11级重元素是一种...",
    ["ResZYS16Dtl"] = "10级重元素是一种...",
    ["ResZYS17Dtl"] = "11级重元素是一种...",
    ["ResZYS18Dtl"] = "10级重元素是一种...",
    ["ResZYS19Dtl"] = "11级重元素是一种...",
    ["ResZYS20Dtl"] = "10级重元素是一种...",
    ["ResJS1Dtl"] = "墨钛金属是一种...",
    ["ResJS2Dtl"] = "墨钛-60是一种...",
    ["ResJS3Dtl"] = "墨钛-80是一种...",
    ["ResJS4Dtl"] = "空气合金是一种...",
    ["ResJS5Dtl"] = "多孔合金是一种...",
    ["ResJS6Dtl"] = "非晶合金是一种...",
    ["ResJS7Dtl"] = "记忆合金是一种...",
    ["ResJS8Dtl"] = "纳米合金是一种...",
    ["ResJS9Dtl"] = "磁电合金是一种...",
    ["ResJS10Dtl"] = "液体金属是一种...",
    ["ResJS11Dtl"] = "11级金属是一种...",
    ["ResJS12Dtl"] = "12级金属是一种...",
    ["ResJS13Dtl"] = "13级金属是一种...",
    ["ResJS14Dtl"] = "14级金属是一种...",
    ["ResJS15Dtl"] = "15级金属是一种...",
    ["ResJS16Dtl"] = "16级金属是一种...",
    ["ResJS17Dtl"] = "17级金属是一种...",
    ["ResJS18Dtl"] = "18级金属是一种...",
    ["ResJS19Dtl"] = "19级金属是一种...",
    ["ResJS20Dtl"] = "20级金属是一种...",
    ["ResYT1Dtl"] = "液氢是一种...",
    ["ResYT2Dtl"] = "浓缩液氢是一种...",
    ["ResYT3Dtl"] = "超密度液氢是一种...",
    ["ResYT4Dtl"] = "甲烷是一种...",
    ["ResYT5Dtl"] = "浓缩甲烷是一种...",
    ["ResYT6Dtl"] = "超密度甲烷是一种...",
    ["ResYT7Dtl"] = "离子液体是一种...",
    ["ResYT8Dtl"] = "无限液体是一种...",
    ["ResYT9Dtl"] = "9级液体是一种...",
    ["ResYT10Dtl"] = "10级液体是一种...",
    ["ResYT11Dtl"] = "11级液体是一种...",
    ["ResYT12Dtl"] = "12级液体是一种...",
    ["ResYT13Dtl"] = "13级液体是一种...",
    ["ResYT14Dtl"] = "14级液体是一种...",
    ["ResYT15Dtl"] = "15级液体是一种...",
    ["ResYT16Dtl"] = "16级液体是一种...",
    ["ResYT17Dtl"] = "17级液体是一种...",
    ["ResYT18Dtl"] = "18级液体是一种...",
    ["ResYT19Dtl"] = "19级液体是一种...",
    ["ResYT20Dtl"] = "20级液体是一种...",
    ["ResJT1Dtl"] = "高强度晶体是一种...",
    ["ResJT2Dtl"] = "高强度晶体II是一种...",
    ["ResJT3Dtl"] = "高强度晶体III是一种...",
    ["ResJT4Dtl"] = "反射晶体是一种...",
    ["ResJT5Dtl"] = "反射晶体II是一种...",
    ["ResJT6Dtl"] = "反射晶体III是一种...",
    ["ResJT7Dtl"] = "声波晶体是一种...",
    ["ResJT8Dtl"] = "声波晶体II是一种...",
    ["ResJT9Dtl"] = "声波晶体III是一种...",
    ["ResJT10Dtl"] = "10级水晶是一种...",
    ["ResJT11Dtl"] = "11级水晶是一种...",
    ["ResJT12Dtl"] = "12级水晶是一种...",
    ["ResJT13Dtl"] = "13级水晶是一种...",
    ["ResJT14Dtl"] = "14级水晶是一种...",
    ["ResJT15Dtl"] = "15级水晶是一种...",
    ["ResJT16Dtl"] = "16级水晶是一种...",
    ["ResJT17Dtl"] = "17级水晶是一种...",
    ["ResJT18Dtl"] = "18级水晶是一种...",
    ["ResJT19Dtl"] = "19级水晶是一种...",
    ["ResJT20Dtl"] = "20级水晶是一种...",
    [""] = "",
    ["ModCollect1"] = "采集舰",
    ["ModCollect1Dtl"] = "采集舰是一种...",
    ["ModCollect2"] = "高级采集舰",
    ["ModCollect2Dtl"] = "高级采集舰是一种...",
    ["ModFrigate1"] = "护卫舰",
    ["ModFrigate1Dtl"] = "护卫舰是一种...",
    [""] = "",
    ["HNCollectHead1"] = "",
    ["HNCollectBody1"] = "",
    ["HNGeneralTail1"] = "",
    ["HNFrigateHead1"] = "",
    ["HNFrigateBodyA1"] = "",
    ["HNFrigateBodyB1"] = "",
    ["HNFrigateTail1"] = "",
    ["HNCollectHead1Dtl"] = "",
    ["HNCollectBody1Dtl"] = "",
    ["HNGeneralTail1Dtl"] = "",
    ["HNFrigateHead1Dtl"] = "",
    ["HNFrigateBodyA1Dtl"] = "",
    ["HNFrigateBodyB1Dtl"] = "",
    ["HNFrigateTail1Dtl"] = "",
    [""] = "",
    ["AcNWeapon1"] = "射弹武器增幅器",
    ["AcNShield1"] = "结构加固",
    ["AcNThrusters1"] = "推进辅助器",
    ["AcNWeapon1Dtl"] = "射弹武器增幅器是一种...",
    ["AcNShield1Dtl"] = "结构加固是一种...",
    ["AcNThrusters1Dtl"] = "推进辅助器是一种...",
}
return languageMap