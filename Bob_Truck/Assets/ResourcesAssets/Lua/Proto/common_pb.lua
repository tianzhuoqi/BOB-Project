-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('common_pb')


local pb = {}
pb.CMD = protobuf.EnumDescriptor();
pb.CMDERROR_ENUM = protobuf.EnumValueDescriptor();
pb.CMDHEART_ENUM = protobuf.EnumValueDescriptor();
pb.CMDLOGIN_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETUSERDATA_ENUM = protobuf.EnumValueDescriptor();
pb.CMDLOGOUT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSCENENODEDATA_ENUM = protobuf.EnumValueDescriptor();
pb.CMDFLEETMOVE_ENUM = protobuf.EnumValueDescriptor();
pb.CMDFLEETMOVESTART_ENUM = protobuf.EnumValueDescriptor();
pb.CMDFLEETMOVEFINISHED_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSCENEOPENMAP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDFLEETSPEEDUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDFLEETLIST_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSETMARK_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCANCELMARK_ENUM = protobuf.EnumValueDescriptor();
pb.CMDMARKLIST_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETNODEDATA_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETFLEETINNODE_ENUM = protobuf.EnumValueDescriptor();
pb.CMDFLEETCOLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDENDFLEETCOLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCREATEBUILDING_ENUM = protobuf.EnumValueDescriptor();
pb.CMDBUILDFINISHED_ENUM = protobuf.EnumValueDescriptor();
pb.CMDBUILDSPEEDUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDADDUSERMOD_ENUM = protobuf.EnumValueDescriptor();
pb.CMDUSERMODS_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSPACEBASEINFO_ENUM = protobuf.EnumValueDescriptor();
pb.CMDREFINERYINFOR_ENUM = protobuf.EnumValueDescriptor();
pb.CMDREFINERYSTART_ENUM = protobuf.EnumValueDescriptor();
pb.CMDREFINERYEND_ENUM = protobuf.EnumValueDescriptor();
pb.CMDREFINERYCOLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETSTOREHOUSE_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCOLLECTIONPLANTSTART_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCOLLECTIONPLANTCOLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCREATESHIP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETCOLLECTIONPLANTINFO_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETPORTSHIP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDLOADGOODS_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETSHIPBYFLEET_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETPORTFLEET_ENUM = protobuf.EnumValueDescriptor();
pb.CMDDISMISSFLEET_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCREATEFLEET_ENUM = protobuf.EnumValueDescriptor();
pb.CMDEDITFLEET_ENUM = protobuf.EnumValueDescriptor();
pb.CMDEDITPOS_ENUM = protobuf.EnumValueDescriptor();
pb.CMDDELSHIP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSPLITSHIP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDEDITFLEETNAME_ENUM = protobuf.EnumValueDescriptor();
pb.CMDHULLFACTMSG_ENUM = protobuf.EnumValueDescriptor();
pb.CMDEDITHULLPRODUCTLINE_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETPRODUCTLINEPRODUCT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDADDMODTOLINE_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETALLEDITSHIP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDDELMOD_ENUM = protobuf.EnumValueDescriptor();
pb.CMDEDITMOD_ENUM = protobuf.EnumValueDescriptor();
pb.CMDEDITSHIP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDBUILDINGLEVELUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDBUILDINGQUEUEMSG_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSELLITEM_ENUM = protobuf.EnumValueDescriptor();
pb.CMDCANCELBUILDING_ENUM = protobuf.EnumValueDescriptor();
pb.CMDREMOVEBUILDING_ENUM = protobuf.EnumValueDescriptor();
pb.CMDMOVEBUILDING_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGETTECH_ENUM = protobuf.EnumValueDescriptor();
pb.CMDTECHLEVELUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDTECHSPEEDUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDTECHFINISHED_ENUM = protobuf.EnumValueDescriptor();
pb.CMDTECHCANCEL_ENUM = protobuf.EnumValueDescriptor();
pb.CMDSPEEDUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDTASKONLINECOLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGUIDE_ENUM = protobuf.EnumValueDescriptor();
pb.CMDUSERLEVELUP_ENUM = protobuf.EnumValueDescriptor();
pb.CMDGM_ENUM = protobuf.EnumValueDescriptor();
pb.NETTYPE = protobuf.EnumDescriptor();
pb.NETTYPENETTYPELOBBY_ENUM = protobuf.EnumValueDescriptor();
pb.ERROR = protobuf.EnumDescriptor();
pb.ERRORSERVER_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORACCOUNT_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORUSER_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBIRTHNODE_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORMOVE_MAP_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORTO_NODE_FLEET_COUNT_FULL_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORMAP_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORMAX_REQUEST_NODE_COUNT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORFLEET_MAP_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORPLANET_EXIST_FLEET_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORFLEET_CANT_ACTION_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORALREADY_EXPLORER_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORDOING_SOMETHING_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORFLEET_CANT_FIND_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORCLIENT_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNOT_EXPLORED_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORFLEET_SPEED_UP_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_STATUS_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORWITHOUT_OWNER_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORCAPPCITY_BOOM_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_MORE_ITEM_NUM_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORWITHOUT_ITEM_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_LEVEL_NOT_ENOUGH_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORWITHOUT_BUILDING_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_MAP_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORWITHOUT_WORKING_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_MOD_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORGM_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_SPACEPORT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_MODFACT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORDEPTH_DIFFER_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNOT_MATCH_MOD_TECH_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_HULL_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_CPNT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNOT_TIME_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_POS_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORPARAM_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_ELECTRICITY_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_LABOR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORPRODUCT_LINE_ERROR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_HULL_RES_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORLABOR_ROOM_BOOM_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_MAX_LEVEL_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNOT_FOUND_REN_PLANT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_MORE_BUILD_QUEUE_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_FINISHED_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORPRE_CONDITION_NOT_ENOUGH_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNO_ELE_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORHAVE_OWNER_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORSPEED_UP_ERROR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_COUNT_LIMIT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORTASK_ONLINE_COUNT_LIMIT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORTASK_ONLINE_TIME_LIMIT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORMARK_COUNT_LIMIT_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORSYS_MARK_CANNOT_CANCEL_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORSKILL_POINT_NOT_ENOUGH_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORSTAR_DUST_NOT_ENOUGH_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORMOD_NAME_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORUSER_LEVEL_NOT_ENOUGH_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORPRODUCT_QUEUE_FULL_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORNOT_FOUND_CONFIG_ENUM = protobuf.EnumValueDescriptor();
pb.ERRORBUILDING_LEVEL_ERR_ENUM = protobuf.EnumValueDescriptor();
pb.FLEETSTATUS = protobuf.EnumDescriptor();
pb.FLEETSTATUSBERTH_ENUM = protobuf.EnumValueDescriptor();
pb.FLEETSTATUSMOVE_ENUM = protobuf.EnumValueDescriptor();
pb.FLEETSTATUSEXPLORE_ENUM = protobuf.EnumValueDescriptor();
pb.FLEETSTATUSCOLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.FLEETSTATUSRETURN_ENUM = protobuf.EnumValueDescriptor();
pb.SHIPTYPE = protobuf.EnumDescriptor();
pb.SHIPTYPESHIP_FUNC_SETTLEMENT_ENUM = protobuf.EnumValueDescriptor();
pb.SHIPTYPESHIP_FUNC_EXPLORE_ENUM = protobuf.EnumValueDescriptor();
pb.SHIPTYPESHIP_FUNC_COLLECT_ENUM = protobuf.EnumValueDescriptor();
pb.SHIPTYPESHIP_FUNC_TARANSPORT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPE = protobuf.EnumDescriptor();
pb.BUILDINGTYPESPACESTATION_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPESPACEPORT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPEHULLFACT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPEMODFACT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPECPNTFACT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPESURFCOL_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPEREFINERY_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPEPOWERPLANT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPEITEMSTG_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGTYPEHABITAT_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGSTATUS = protobuf.EnumDescriptor();
pb.BUILDINGSTATUSNORMAL_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGSTATUSCREATE_ENUM = protobuf.EnumValueDescriptor();
pb.BUILDINGSTATUSWORKING_ENUM = protobuf.EnumValueDescriptor();
pb.NODESTATUS = protobuf.EnumDescriptor();
pb.NODESTATUSCOMMON_ENUM = protobuf.EnumValueDescriptor();
pb.NODESTATUSDEFEND_ENUM = protobuf.EnumValueDescriptor();
pb.NODESTATUSBLOCK_ENUM = protobuf.EnumValueDescriptor();
pb.TECHSTATUS = protobuf.EnumDescriptor();
pb.TECHSTATUSREGULAR_ENUM = protobuf.EnumValueDescriptor();
pb.TECHSTATUSBUILDING_ENUM = protobuf.EnumValueDescriptor();

pb.CMDERROR_ENUM.name = "ERROR"
pb.CMDERROR_ENUM.index = 0
pb.CMDERROR_ENUM.number = -1
pb.CMDHEART_ENUM.name = "HEART"
pb.CMDHEART_ENUM.index = 1
pb.CMDHEART_ENUM.number = 0
pb.CMDLOGIN_ENUM.name = "LOGIN"
pb.CMDLOGIN_ENUM.index = 2
pb.CMDLOGIN_ENUM.number = 1
pb.CMDGETUSERDATA_ENUM.name = "GETUSERDATA"
pb.CMDGETUSERDATA_ENUM.index = 3
pb.CMDGETUSERDATA_ENUM.number = 2
pb.CMDLOGOUT_ENUM.name = "LOGOUT"
pb.CMDLOGOUT_ENUM.index = 4
pb.CMDLOGOUT_ENUM.number = 992
pb.CMDSCENENODEDATA_ENUM.name = "SCENENODEDATA"
pb.CMDSCENENODEDATA_ENUM.index = 5
pb.CMDSCENENODEDATA_ENUM.number = 3
pb.CMDFLEETMOVE_ENUM.name = "FLEETMOVE"
pb.CMDFLEETMOVE_ENUM.index = 6
pb.CMDFLEETMOVE_ENUM.number = 4
pb.CMDFLEETMOVESTART_ENUM.name = "FLEETMOVESTART"
pb.CMDFLEETMOVESTART_ENUM.index = 7
pb.CMDFLEETMOVESTART_ENUM.number = 5
pb.CMDFLEETMOVEFINISHED_ENUM.name = "FLEETMOVEFINISHED"
pb.CMDFLEETMOVEFINISHED_ENUM.index = 8
pb.CMDFLEETMOVEFINISHED_ENUM.number = 6
pb.CMDSCENEOPENMAP_ENUM.name = "SCENEOPENMAP"
pb.CMDSCENEOPENMAP_ENUM.index = 9
pb.CMDSCENEOPENMAP_ENUM.number = 7
pb.CMDFLEETSPEEDUP_ENUM.name = "FLEETSPEEDUP"
pb.CMDFLEETSPEEDUP_ENUM.index = 10
pb.CMDFLEETSPEEDUP_ENUM.number = 8
pb.CMDFLEETLIST_ENUM.name = "FLEETLIST"
pb.CMDFLEETLIST_ENUM.index = 11
pb.CMDFLEETLIST_ENUM.number = 9
pb.CMDSETMARK_ENUM.name = "SETMARK"
pb.CMDSETMARK_ENUM.index = 12
pb.CMDSETMARK_ENUM.number = 10
pb.CMDCANCELMARK_ENUM.name = "CANCELMARK"
pb.CMDCANCELMARK_ENUM.index = 13
pb.CMDCANCELMARK_ENUM.number = 11
pb.CMDMARKLIST_ENUM.name = "MARKLIST"
pb.CMDMARKLIST_ENUM.index = 14
pb.CMDMARKLIST_ENUM.number = 12
pb.CMDGETNODEDATA_ENUM.name = "GETNODEDATA"
pb.CMDGETNODEDATA_ENUM.index = 15
pb.CMDGETNODEDATA_ENUM.number = 41
pb.CMDGETFLEETINNODE_ENUM.name = "GETFLEETINNODE"
pb.CMDGETFLEETINNODE_ENUM.index = 16
pb.CMDGETFLEETINNODE_ENUM.number = 42
pb.CMDFLEETCOLLECT_ENUM.name = "FLEETCOLLECT"
pb.CMDFLEETCOLLECT_ENUM.index = 17
pb.CMDFLEETCOLLECT_ENUM.number = 43
pb.CMDENDFLEETCOLLECT_ENUM.name = "ENDFLEETCOLLECT"
pb.CMDENDFLEETCOLLECT_ENUM.index = 18
pb.CMDENDFLEETCOLLECT_ENUM.number = 44
pb.CMDCREATEBUILDING_ENUM.name = "CREATEBUILDING"
pb.CMDCREATEBUILDING_ENUM.index = 19
pb.CMDCREATEBUILDING_ENUM.number = 60
pb.CMDBUILDFINISHED_ENUM.name = "BUILDFINISHED"
pb.CMDBUILDFINISHED_ENUM.index = 20
pb.CMDBUILDFINISHED_ENUM.number = 61
pb.CMDBUILDSPEEDUP_ENUM.name = "BUILDSPEEDUP"
pb.CMDBUILDSPEEDUP_ENUM.index = 21
pb.CMDBUILDSPEEDUP_ENUM.number = 62
pb.CMDADDUSERMOD_ENUM.name = "ADDUSERMOD"
pb.CMDADDUSERMOD_ENUM.index = 22
pb.CMDADDUSERMOD_ENUM.number = 63
pb.CMDUSERMODS_ENUM.name = "USERMODS"
pb.CMDUSERMODS_ENUM.index = 23
pb.CMDUSERMODS_ENUM.number = 64
pb.CMDSPACEBASEINFO_ENUM.name = "SPACEBASEINFO"
pb.CMDSPACEBASEINFO_ENUM.index = 24
pb.CMDSPACEBASEINFO_ENUM.number = 79
pb.CMDREFINERYINFOR_ENUM.name = "REFINERYINFOR"
pb.CMDREFINERYINFOR_ENUM.index = 25
pb.CMDREFINERYINFOR_ENUM.number = 65
pb.CMDREFINERYSTART_ENUM.name = "REFINERYSTART"
pb.CMDREFINERYSTART_ENUM.index = 26
pb.CMDREFINERYSTART_ENUM.number = 66
pb.CMDREFINERYEND_ENUM.name = "REFINERYEND"
pb.CMDREFINERYEND_ENUM.index = 27
pb.CMDREFINERYEND_ENUM.number = 67
pb.CMDREFINERYCOLLECT_ENUM.name = "REFINERYCOLLECT"
pb.CMDREFINERYCOLLECT_ENUM.index = 28
pb.CMDREFINERYCOLLECT_ENUM.number = 68
pb.CMDGETSTOREHOUSE_ENUM.name = "GETSTOREHOUSE"
pb.CMDGETSTOREHOUSE_ENUM.index = 29
pb.CMDGETSTOREHOUSE_ENUM.number = 69
pb.CMDCOLLECTIONPLANTSTART_ENUM.name = "COLLECTIONPLANTSTART"
pb.CMDCOLLECTIONPLANTSTART_ENUM.index = 30
pb.CMDCOLLECTIONPLANTSTART_ENUM.number = 70
pb.CMDCOLLECTIONPLANTCOLLECT_ENUM.name = "COLLECTIONPLANTCOLLECT"
pb.CMDCOLLECTIONPLANTCOLLECT_ENUM.index = 31
pb.CMDCOLLECTIONPLANTCOLLECT_ENUM.number = 71
pb.CMDCREATESHIP_ENUM.name = "CREATESHIP"
pb.CMDCREATESHIP_ENUM.index = 32
pb.CMDCREATESHIP_ENUM.number = 72
pb.CMDGETCOLLECTIONPLANTINFO_ENUM.name = "GETCOLLECTIONPLANTINFO"
pb.CMDGETCOLLECTIONPLANTINFO_ENUM.index = 33
pb.CMDGETCOLLECTIONPLANTINFO_ENUM.number = 73
pb.CMDGETPORTSHIP_ENUM.name = "GETPORTSHIP"
pb.CMDGETPORTSHIP_ENUM.index = 34
pb.CMDGETPORTSHIP_ENUM.number = 80
pb.CMDLOADGOODS_ENUM.name = "LOADGOODS"
pb.CMDLOADGOODS_ENUM.index = 35
pb.CMDLOADGOODS_ENUM.number = 81
pb.CMDGETSHIPBYFLEET_ENUM.name = "GETSHIPBYFLEET"
pb.CMDGETSHIPBYFLEET_ENUM.index = 36
pb.CMDGETSHIPBYFLEET_ENUM.number = 82
pb.CMDGETPORTFLEET_ENUM.name = "GETPORTFLEET"
pb.CMDGETPORTFLEET_ENUM.index = 37
pb.CMDGETPORTFLEET_ENUM.number = 83
pb.CMDDISMISSFLEET_ENUM.name = "DISMISSFLEET"
pb.CMDDISMISSFLEET_ENUM.index = 38
pb.CMDDISMISSFLEET_ENUM.number = 84
pb.CMDCREATEFLEET_ENUM.name = "CREATEFLEET"
pb.CMDCREATEFLEET_ENUM.index = 39
pb.CMDCREATEFLEET_ENUM.number = 85
pb.CMDEDITFLEET_ENUM.name = "EDITFLEET"
pb.CMDEDITFLEET_ENUM.index = 40
pb.CMDEDITFLEET_ENUM.number = 86
pb.CMDEDITPOS_ENUM.name = "EDITPOS"
pb.CMDEDITPOS_ENUM.index = 41
pb.CMDEDITPOS_ENUM.number = 87
pb.CMDDELSHIP_ENUM.name = "DELSHIP"
pb.CMDDELSHIP_ENUM.index = 42
pb.CMDDELSHIP_ENUM.number = 88
pb.CMDSPLITSHIP_ENUM.name = "SPLITSHIP"
pb.CMDSPLITSHIP_ENUM.index = 43
pb.CMDSPLITSHIP_ENUM.number = 89
pb.CMDEDITFLEETNAME_ENUM.name = "EDITFLEETNAME"
pb.CMDEDITFLEETNAME_ENUM.index = 44
pb.CMDEDITFLEETNAME_ENUM.number = 90
pb.CMDHULLFACTMSG_ENUM.name = "HULLFACTMSG"
pb.CMDHULLFACTMSG_ENUM.index = 45
pb.CMDHULLFACTMSG_ENUM.number = 100
pb.CMDEDITHULLPRODUCTLINE_ENUM.name = "EDITHULLPRODUCTLINE"
pb.CMDEDITHULLPRODUCTLINE_ENUM.index = 46
pb.CMDEDITHULLPRODUCTLINE_ENUM.number = 101
pb.CMDGETPRODUCTLINEPRODUCT_ENUM.name = "GETPRODUCTLINEPRODUCT"
pb.CMDGETPRODUCTLINEPRODUCT_ENUM.index = 47
pb.CMDGETPRODUCTLINEPRODUCT_ENUM.number = 102
pb.CMDADDMODTOLINE_ENUM.name = "ADDMODTOLINE"
pb.CMDADDMODTOLINE_ENUM.index = 48
pb.CMDADDMODTOLINE_ENUM.number = 103
pb.CMDGETALLEDITSHIP_ENUM.name = "GETALLEDITSHIP"
pb.CMDGETALLEDITSHIP_ENUM.index = 49
pb.CMDGETALLEDITSHIP_ENUM.number = 109
pb.CMDDELMOD_ENUM.name = "DELMOD"
pb.CMDDELMOD_ENUM.index = 50
pb.CMDDELMOD_ENUM.number = 110
pb.CMDEDITMOD_ENUM.name = "EDITMOD"
pb.CMDEDITMOD_ENUM.index = 51
pb.CMDEDITMOD_ENUM.number = 111
pb.CMDEDITSHIP_ENUM.name = "EDITSHIP"
pb.CMDEDITSHIP_ENUM.index = 52
pb.CMDEDITSHIP_ENUM.number = 112
pb.CMDBUILDINGLEVELUP_ENUM.name = "BUILDINGLEVELUP"
pb.CMDBUILDINGLEVELUP_ENUM.index = 53
pb.CMDBUILDINGLEVELUP_ENUM.number = 113
pb.CMDBUILDINGQUEUEMSG_ENUM.name = "BUILDINGQUEUEMSG"
pb.CMDBUILDINGQUEUEMSG_ENUM.index = 54
pb.CMDBUILDINGQUEUEMSG_ENUM.number = 114
pb.CMDSELLITEM_ENUM.name = "SELLITEM"
pb.CMDSELLITEM_ENUM.index = 55
pb.CMDSELLITEM_ENUM.number = 115
pb.CMDCANCELBUILDING_ENUM.name = "CANCELBUILDING"
pb.CMDCANCELBUILDING_ENUM.index = 56
pb.CMDCANCELBUILDING_ENUM.number = 116
pb.CMDREMOVEBUILDING_ENUM.name = "REMOVEBUILDING"
pb.CMDREMOVEBUILDING_ENUM.index = 57
pb.CMDREMOVEBUILDING_ENUM.number = 117
pb.CMDMOVEBUILDING_ENUM.name = "MOVEBUILDING"
pb.CMDMOVEBUILDING_ENUM.index = 58
pb.CMDMOVEBUILDING_ENUM.number = 118
pb.CMDGETTECH_ENUM.name = "GETTECH"
pb.CMDGETTECH_ENUM.index = 59
pb.CMDGETTECH_ENUM.number = 120
pb.CMDTECHLEVELUP_ENUM.name = "TECHLEVELUP"
pb.CMDTECHLEVELUP_ENUM.index = 60
pb.CMDTECHLEVELUP_ENUM.number = 121
pb.CMDTECHSPEEDUP_ENUM.name = "TECHSPEEDUP"
pb.CMDTECHSPEEDUP_ENUM.index = 61
pb.CMDTECHSPEEDUP_ENUM.number = 122
pb.CMDTECHFINISHED_ENUM.name = "TECHFINISHED"
pb.CMDTECHFINISHED_ENUM.index = 62
pb.CMDTECHFINISHED_ENUM.number = 123
pb.CMDTECHCANCEL_ENUM.name = "TECHCANCEL"
pb.CMDTECHCANCEL_ENUM.index = 63
pb.CMDTECHCANCEL_ENUM.number = 124
pb.CMDSPEEDUP_ENUM.name = "SPEEDUP"
pb.CMDSPEEDUP_ENUM.index = 64
pb.CMDSPEEDUP_ENUM.number = 125
pb.CMDTASKONLINECOLLECT_ENUM.name = "TASKONLINECOLLECT"
pb.CMDTASKONLINECOLLECT_ENUM.index = 65
pb.CMDTASKONLINECOLLECT_ENUM.number = 950
pb.CMDGUIDE_ENUM.name = "GUIDE"
pb.CMDGUIDE_ENUM.index = 66
pb.CMDGUIDE_ENUM.number = 951
pb.CMDUSERLEVELUP_ENUM.name = "USERLEVELUP"
pb.CMDUSERLEVELUP_ENUM.index = 67
pb.CMDUSERLEVELUP_ENUM.number = 952
pb.CMDGM_ENUM.name = "GM"
pb.CMDGM_ENUM.index = 68
pb.CMDGM_ENUM.number = 990
pb.CMD.name = "Cmd"
pb.CMD.full_name = ".com.nkm.common.proto.client.Cmd"
pb.CMD.values = {pb.CMDERROR_ENUM,pb.CMDHEART_ENUM,pb.CMDLOGIN_ENUM,pb.CMDGETUSERDATA_ENUM,pb.CMDLOGOUT_ENUM,pb.CMDSCENENODEDATA_ENUM,pb.CMDFLEETMOVE_ENUM,pb.CMDFLEETMOVESTART_ENUM,pb.CMDFLEETMOVEFINISHED_ENUM,pb.CMDSCENEOPENMAP_ENUM,pb.CMDFLEETSPEEDUP_ENUM,pb.CMDFLEETLIST_ENUM,pb.CMDSETMARK_ENUM,pb.CMDCANCELMARK_ENUM,pb.CMDMARKLIST_ENUM,pb.CMDGETNODEDATA_ENUM,pb.CMDGETFLEETINNODE_ENUM,pb.CMDFLEETCOLLECT_ENUM,pb.CMDENDFLEETCOLLECT_ENUM,pb.CMDCREATEBUILDING_ENUM,pb.CMDBUILDFINISHED_ENUM,pb.CMDBUILDSPEEDUP_ENUM,pb.CMDADDUSERMOD_ENUM,pb.CMDUSERMODS_ENUM,pb.CMDSPACEBASEINFO_ENUM,pb.CMDREFINERYINFOR_ENUM,pb.CMDREFINERYSTART_ENUM,pb.CMDREFINERYEND_ENUM,pb.CMDREFINERYCOLLECT_ENUM,pb.CMDGETSTOREHOUSE_ENUM,pb.CMDCOLLECTIONPLANTSTART_ENUM,pb.CMDCOLLECTIONPLANTCOLLECT_ENUM,pb.CMDCREATESHIP_ENUM,pb.CMDGETCOLLECTIONPLANTINFO_ENUM,pb.CMDGETPORTSHIP_ENUM,pb.CMDLOADGOODS_ENUM,pb.CMDGETSHIPBYFLEET_ENUM,pb.CMDGETPORTFLEET_ENUM,pb.CMDDISMISSFLEET_ENUM,pb.CMDCREATEFLEET_ENUM,pb.CMDEDITFLEET_ENUM,pb.CMDEDITPOS_ENUM,pb.CMDDELSHIP_ENUM,pb.CMDSPLITSHIP_ENUM,pb.CMDEDITFLEETNAME_ENUM,pb.CMDHULLFACTMSG_ENUM,pb.CMDEDITHULLPRODUCTLINE_ENUM,pb.CMDGETPRODUCTLINEPRODUCT_ENUM,pb.CMDADDMODTOLINE_ENUM,pb.CMDGETALLEDITSHIP_ENUM,pb.CMDDELMOD_ENUM,pb.CMDEDITMOD_ENUM,pb.CMDEDITSHIP_ENUM,pb.CMDBUILDINGLEVELUP_ENUM,pb.CMDBUILDINGQUEUEMSG_ENUM,pb.CMDSELLITEM_ENUM,pb.CMDCANCELBUILDING_ENUM,pb.CMDREMOVEBUILDING_ENUM,pb.CMDMOVEBUILDING_ENUM,pb.CMDGETTECH_ENUM,pb.CMDTECHLEVELUP_ENUM,pb.CMDTECHSPEEDUP_ENUM,pb.CMDTECHFINISHED_ENUM,pb.CMDTECHCANCEL_ENUM,pb.CMDSPEEDUP_ENUM,pb.CMDTASKONLINECOLLECT_ENUM,pb.CMDGUIDE_ENUM,pb.CMDUSERLEVELUP_ENUM,pb.CMDGM_ENUM}
pb.NETTYPENETTYPELOBBY_ENUM.name = "NETTYPELOBBY"
pb.NETTYPENETTYPELOBBY_ENUM.index = 0
pb.NETTYPENETTYPELOBBY_ENUM.number = 1
pb.NETTYPE.name = "NetType"
pb.NETTYPE.full_name = ".com.nkm.common.proto.client.NetType"
pb.NETTYPE.values = {pb.NETTYPENETTYPELOBBY_ENUM}
pb.ERRORSERVER_ERR_ENUM.name = "SERVER_ERR"
pb.ERRORSERVER_ERR_ENUM.index = 0
pb.ERRORSERVER_ERR_ENUM.number = 1
pb.ERRORACCOUNT_ERR_ENUM.name = "ACCOUNT_ERR"
pb.ERRORACCOUNT_ERR_ENUM.index = 1
pb.ERRORACCOUNT_ERR_ENUM.number = 2
pb.ERRORUSER_ERR_ENUM.name = "USER_ERR"
pb.ERRORUSER_ERR_ENUM.index = 2
pb.ERRORUSER_ERR_ENUM.number = 3
pb.ERRORBIRTHNODE_ERR_ENUM.name = "BIRTHNODE_ERR"
pb.ERRORBIRTHNODE_ERR_ENUM.index = 3
pb.ERRORBIRTHNODE_ERR_ENUM.number = 4
pb.ERRORBUILDING_ERR_ENUM.name = "BUILDING_ERR"
pb.ERRORBUILDING_ERR_ENUM.index = 4
pb.ERRORBUILDING_ERR_ENUM.number = 5
pb.ERRORMOVE_MAP_ERR_ENUM.name = "MOVE_MAP_ERR"
pb.ERRORMOVE_MAP_ERR_ENUM.index = 5
pb.ERRORMOVE_MAP_ERR_ENUM.number = 6
pb.ERRORTO_NODE_FLEET_COUNT_FULL_ENUM.name = "TO_NODE_FLEET_COUNT_FULL"
pb.ERRORTO_NODE_FLEET_COUNT_FULL_ENUM.index = 6
pb.ERRORTO_NODE_FLEET_COUNT_FULL_ENUM.number = 7
pb.ERRORMAP_ERR_ENUM.name = "MAP_ERR"
pb.ERRORMAP_ERR_ENUM.index = 7
pb.ERRORMAP_ERR_ENUM.number = 8
pb.ERRORMAX_REQUEST_NODE_COUNT_ENUM.name = "MAX_REQUEST_NODE_COUNT"
pb.ERRORMAX_REQUEST_NODE_COUNT_ENUM.index = 8
pb.ERRORMAX_REQUEST_NODE_COUNT_ENUM.number = 9
pb.ERRORFLEET_MAP_ERR_ENUM.name = "FLEET_MAP_ERR"
pb.ERRORFLEET_MAP_ERR_ENUM.index = 9
pb.ERRORFLEET_MAP_ERR_ENUM.number = 10
pb.ERRORPLANET_EXIST_FLEET_ENUM.name = "PLANET_EXIST_FLEET"
pb.ERRORPLANET_EXIST_FLEET_ENUM.index = 10
pb.ERRORPLANET_EXIST_FLEET_ENUM.number = 11
pb.ERRORFLEET_CANT_ACTION_ENUM.name = "FLEET_CANT_ACTION"
pb.ERRORFLEET_CANT_ACTION_ENUM.index = 11
pb.ERRORFLEET_CANT_ACTION_ENUM.number = 12
pb.ERRORALREADY_EXPLORER_ENUM.name = "ALREADY_EXPLORER"
pb.ERRORALREADY_EXPLORER_ENUM.index = 12
pb.ERRORALREADY_EXPLORER_ENUM.number = 13
pb.ERRORDOING_SOMETHING_ERR_ENUM.name = "DOING_SOMETHING_ERR"
pb.ERRORDOING_SOMETHING_ERR_ENUM.index = 13
pb.ERRORDOING_SOMETHING_ERR_ENUM.number = 14
pb.ERRORFLEET_CANT_FIND_ENUM.name = "FLEET_CANT_FIND"
pb.ERRORFLEET_CANT_FIND_ENUM.index = 14
pb.ERRORFLEET_CANT_FIND_ENUM.number = 15
pb.ERRORCLIENT_ERR_ENUM.name = "CLIENT_ERR"
pb.ERRORCLIENT_ERR_ENUM.index = 15
pb.ERRORCLIENT_ERR_ENUM.number = 16
pb.ERRORNOT_EXPLORED_ENUM.name = "NOT_EXPLORED"
pb.ERRORNOT_EXPLORED_ENUM.index = 16
pb.ERRORNOT_EXPLORED_ENUM.number = 17
pb.ERRORFLEET_SPEED_UP_ERR_ENUM.name = "FLEET_SPEED_UP_ERR"
pb.ERRORFLEET_SPEED_UP_ERR_ENUM.index = 17
pb.ERRORFLEET_SPEED_UP_ERR_ENUM.number = 18
pb.ERRORBUILDING_STATUS_ERR_ENUM.name = "BUILDING_STATUS_ERR"
pb.ERRORBUILDING_STATUS_ERR_ENUM.index = 18
pb.ERRORBUILDING_STATUS_ERR_ENUM.number = 19
pb.ERRORWITHOUT_OWNER_ENUM.name = "WITHOUT_OWNER"
pb.ERRORWITHOUT_OWNER_ENUM.index = 19
pb.ERRORWITHOUT_OWNER_ENUM.number = 20
pb.ERRORCAPPCITY_BOOM_ENUM.name = "CAPPCITY_BOOM"
pb.ERRORCAPPCITY_BOOM_ENUM.index = 20
pb.ERRORCAPPCITY_BOOM_ENUM.number = 21
pb.ERRORNO_MORE_ITEM_NUM_ENUM.name = "NO_MORE_ITEM_NUM"
pb.ERRORNO_MORE_ITEM_NUM_ENUM.index = 21
pb.ERRORNO_MORE_ITEM_NUM_ENUM.number = 22
pb.ERRORWITHOUT_ITEM_ENUM.name = "WITHOUT_ITEM"
pb.ERRORWITHOUT_ITEM_ENUM.index = 22
pb.ERRORWITHOUT_ITEM_ENUM.number = 23
pb.ERRORBUILDING_LEVEL_NOT_ENOUGH_ENUM.name = "BUILDING_LEVEL_NOT_ENOUGH"
pb.ERRORBUILDING_LEVEL_NOT_ENOUGH_ENUM.index = 23
pb.ERRORBUILDING_LEVEL_NOT_ENOUGH_ENUM.number = 24
pb.ERRORWITHOUT_BUILDING_ENUM.name = "WITHOUT_BUILDING"
pb.ERRORWITHOUT_BUILDING_ENUM.index = 24
pb.ERRORWITHOUT_BUILDING_ENUM.number = 25
pb.ERRORBUILDING_MAP_ERR_ENUM.name = "BUILDING_MAP_ERR"
pb.ERRORBUILDING_MAP_ERR_ENUM.index = 25
pb.ERRORBUILDING_MAP_ERR_ENUM.number = 26
pb.ERRORWITHOUT_WORKING_ENUM.name = "WITHOUT_WORKING"
pb.ERRORWITHOUT_WORKING_ENUM.index = 26
pb.ERRORWITHOUT_WORKING_ENUM.number = 27
pb.ERRORNO_MOD_ENUM.name = "NO_MOD"
pb.ERRORNO_MOD_ENUM.index = 27
pb.ERRORNO_MOD_ENUM.number = 28
pb.ERRORGM_ERR_ENUM.name = "GM_ERR"
pb.ERRORGM_ERR_ENUM.index = 28
pb.ERRORGM_ERR_ENUM.number = 29
pb.ERRORNO_SPACEPORT_ENUM.name = "NO_SPACEPORT"
pb.ERRORNO_SPACEPORT_ENUM.index = 29
pb.ERRORNO_SPACEPORT_ENUM.number = 30
pb.ERRORNO_MODFACT_ENUM.name = "NO_MODFACT"
pb.ERRORNO_MODFACT_ENUM.index = 30
pb.ERRORNO_MODFACT_ENUM.number = 31
pb.ERRORDEPTH_DIFFER_ENUM.name = "DEPTH_DIFFER"
pb.ERRORDEPTH_DIFFER_ENUM.index = 31
pb.ERRORDEPTH_DIFFER_ENUM.number = 32
pb.ERRORNOT_MATCH_MOD_TECH_ENUM.name = "NOT_MATCH_MOD_TECH"
pb.ERRORNOT_MATCH_MOD_TECH_ENUM.index = 32
pb.ERRORNOT_MATCH_MOD_TECH_ENUM.number = 33
pb.ERRORNO_HULL_ENUM.name = "NO_HULL"
pb.ERRORNO_HULL_ENUM.index = 33
pb.ERRORNO_HULL_ENUM.number = 34
pb.ERRORNO_CPNT_ENUM.name = "NO_CPNT"
pb.ERRORNO_CPNT_ENUM.index = 34
pb.ERRORNO_CPNT_ENUM.number = 35
pb.ERRORNOT_TIME_ENUM.name = "NOT_TIME"
pb.ERRORNOT_TIME_ENUM.index = 35
pb.ERRORNOT_TIME_ENUM.number = 36
pb.ERRORNO_POS_ENUM.name = "NO_POS"
pb.ERRORNO_POS_ENUM.index = 36
pb.ERRORNO_POS_ENUM.number = 37
pb.ERRORPARAM_ERR_ENUM.name = "PARAM_ERR"
pb.ERRORPARAM_ERR_ENUM.index = 37
pb.ERRORPARAM_ERR_ENUM.number = 38
pb.ERRORNO_ELECTRICITY_ENUM.name = "NO_ELECTRICITY"
pb.ERRORNO_ELECTRICITY_ENUM.index = 38
pb.ERRORNO_ELECTRICITY_ENUM.number = 39
pb.ERRORNO_LABOR_ENUM.name = "NO_LABOR"
pb.ERRORNO_LABOR_ENUM.index = 39
pb.ERRORNO_LABOR_ENUM.number = 40
pb.ERRORPRODUCT_LINE_ERROR_ENUM.name = "PRODUCT_LINE_ERROR"
pb.ERRORPRODUCT_LINE_ERROR_ENUM.index = 40
pb.ERRORPRODUCT_LINE_ERROR_ENUM.number = 41
pb.ERRORNO_HULL_RES_ENUM.name = "NO_HULL_RES"
pb.ERRORNO_HULL_RES_ENUM.index = 41
pb.ERRORNO_HULL_RES_ENUM.number = 42
pb.ERRORLABOR_ROOM_BOOM_ENUM.name = "LABOR_ROOM_BOOM"
pb.ERRORLABOR_ROOM_BOOM_ENUM.index = 42
pb.ERRORLABOR_ROOM_BOOM_ENUM.number = 43
pb.ERRORBUILDING_MAX_LEVEL_ENUM.name = "BUILDING_MAX_LEVEL"
pb.ERRORBUILDING_MAX_LEVEL_ENUM.index = 43
pb.ERRORBUILDING_MAX_LEVEL_ENUM.number = 44
pb.ERRORNOT_FOUND_REN_PLANT_ENUM.name = "NOT_FOUND_REN_PLANT"
pb.ERRORNOT_FOUND_REN_PLANT_ENUM.index = 44
pb.ERRORNOT_FOUND_REN_PLANT_ENUM.number = 45
pb.ERRORNO_MORE_BUILD_QUEUE_ENUM.name = "NO_MORE_BUILD_QUEUE"
pb.ERRORNO_MORE_BUILD_QUEUE_ENUM.index = 45
pb.ERRORNO_MORE_BUILD_QUEUE_ENUM.number = 46
pb.ERRORBUILDING_FINISHED_ENUM.name = "BUILDING_FINISHED"
pb.ERRORBUILDING_FINISHED_ENUM.index = 46
pb.ERRORBUILDING_FINISHED_ENUM.number = 47
pb.ERRORPRE_CONDITION_NOT_ENOUGH_ENUM.name = "PRE_CONDITION_NOT_ENOUGH"
pb.ERRORPRE_CONDITION_NOT_ENOUGH_ENUM.index = 47
pb.ERRORPRE_CONDITION_NOT_ENOUGH_ENUM.number = 48
pb.ERRORNO_ELE_ENUM.name = "NO_ELE"
pb.ERRORNO_ELE_ENUM.index = 48
pb.ERRORNO_ELE_ENUM.number = 49
pb.ERRORHAVE_OWNER_ENUM.name = "HAVE_OWNER"
pb.ERRORHAVE_OWNER_ENUM.index = 49
pb.ERRORHAVE_OWNER_ENUM.number = 50
pb.ERRORSPEED_UP_ERROR_ENUM.name = "SPEED_UP_ERROR"
pb.ERRORSPEED_UP_ERROR_ENUM.index = 50
pb.ERRORSPEED_UP_ERROR_ENUM.number = 51
pb.ERRORBUILDING_COUNT_LIMIT_ENUM.name = "BUILDING_COUNT_LIMIT"
pb.ERRORBUILDING_COUNT_LIMIT_ENUM.index = 51
pb.ERRORBUILDING_COUNT_LIMIT_ENUM.number = 52
pb.ERRORTASK_ONLINE_COUNT_LIMIT_ENUM.name = "TASK_ONLINE_COUNT_LIMIT"
pb.ERRORTASK_ONLINE_COUNT_LIMIT_ENUM.index = 52
pb.ERRORTASK_ONLINE_COUNT_LIMIT_ENUM.number = 53
pb.ERRORTASK_ONLINE_TIME_LIMIT_ENUM.name = "TASK_ONLINE_TIME_LIMIT"
pb.ERRORTASK_ONLINE_TIME_LIMIT_ENUM.index = 53
pb.ERRORTASK_ONLINE_TIME_LIMIT_ENUM.number = 54
pb.ERRORMARK_COUNT_LIMIT_ENUM.name = "MARK_COUNT_LIMIT"
pb.ERRORMARK_COUNT_LIMIT_ENUM.index = 54
pb.ERRORMARK_COUNT_LIMIT_ENUM.number = 55
pb.ERRORSYS_MARK_CANNOT_CANCEL_ENUM.name = "SYS_MARK_CANNOT_CANCEL"
pb.ERRORSYS_MARK_CANNOT_CANCEL_ENUM.index = 55
pb.ERRORSYS_MARK_CANNOT_CANCEL_ENUM.number = 56
pb.ERRORSKILL_POINT_NOT_ENOUGH_ENUM.name = "SKILL_POINT_NOT_ENOUGH"
pb.ERRORSKILL_POINT_NOT_ENOUGH_ENUM.index = 56
pb.ERRORSKILL_POINT_NOT_ENOUGH_ENUM.number = 57
pb.ERRORSTAR_DUST_NOT_ENOUGH_ENUM.name = "STAR_DUST_NOT_ENOUGH"
pb.ERRORSTAR_DUST_NOT_ENOUGH_ENUM.index = 57
pb.ERRORSTAR_DUST_NOT_ENOUGH_ENUM.number = 58
pb.ERRORMOD_NAME_ERR_ENUM.name = "MOD_NAME_ERR"
pb.ERRORMOD_NAME_ERR_ENUM.index = 58
pb.ERRORMOD_NAME_ERR_ENUM.number = 59
pb.ERRORUSER_LEVEL_NOT_ENOUGH_ENUM.name = "USER_LEVEL_NOT_ENOUGH"
pb.ERRORUSER_LEVEL_NOT_ENOUGH_ENUM.index = 59
pb.ERRORUSER_LEVEL_NOT_ENOUGH_ENUM.number = 60
pb.ERRORPRODUCT_QUEUE_FULL_ENUM.name = "PRODUCT_QUEUE_FULL"
pb.ERRORPRODUCT_QUEUE_FULL_ENUM.index = 60
pb.ERRORPRODUCT_QUEUE_FULL_ENUM.number = 61
pb.ERRORNOT_FOUND_CONFIG_ENUM.name = "NOT_FOUND_CONFIG"
pb.ERRORNOT_FOUND_CONFIG_ENUM.index = 61
pb.ERRORNOT_FOUND_CONFIG_ENUM.number = 62
pb.ERRORBUILDING_LEVEL_ERR_ENUM.name = "BUILDING_LEVEL_ERR"
pb.ERRORBUILDING_LEVEL_ERR_ENUM.index = 62
pb.ERRORBUILDING_LEVEL_ERR_ENUM.number = 63
pb.ERROR.name = "Error"
pb.ERROR.full_name = ".com.nkm.common.proto.client.Error"
pb.ERROR.values = {pb.ERRORSERVER_ERR_ENUM,pb.ERRORACCOUNT_ERR_ENUM,pb.ERRORUSER_ERR_ENUM,pb.ERRORBIRTHNODE_ERR_ENUM,pb.ERRORBUILDING_ERR_ENUM,pb.ERRORMOVE_MAP_ERR_ENUM,pb.ERRORTO_NODE_FLEET_COUNT_FULL_ENUM,pb.ERRORMAP_ERR_ENUM,pb.ERRORMAX_REQUEST_NODE_COUNT_ENUM,pb.ERRORFLEET_MAP_ERR_ENUM,pb.ERRORPLANET_EXIST_FLEET_ENUM,pb.ERRORFLEET_CANT_ACTION_ENUM,pb.ERRORALREADY_EXPLORER_ENUM,pb.ERRORDOING_SOMETHING_ERR_ENUM,pb.ERRORFLEET_CANT_FIND_ENUM,pb.ERRORCLIENT_ERR_ENUM,pb.ERRORNOT_EXPLORED_ENUM,pb.ERRORFLEET_SPEED_UP_ERR_ENUM,pb.ERRORBUILDING_STATUS_ERR_ENUM,pb.ERRORWITHOUT_OWNER_ENUM,pb.ERRORCAPPCITY_BOOM_ENUM,pb.ERRORNO_MORE_ITEM_NUM_ENUM,pb.ERRORWITHOUT_ITEM_ENUM,pb.ERRORBUILDING_LEVEL_NOT_ENOUGH_ENUM,pb.ERRORWITHOUT_BUILDING_ENUM,pb.ERRORBUILDING_MAP_ERR_ENUM,pb.ERRORWITHOUT_WORKING_ENUM,pb.ERRORNO_MOD_ENUM,pb.ERRORGM_ERR_ENUM,pb.ERRORNO_SPACEPORT_ENUM,pb.ERRORNO_MODFACT_ENUM,pb.ERRORDEPTH_DIFFER_ENUM,pb.ERRORNOT_MATCH_MOD_TECH_ENUM,pb.ERRORNO_HULL_ENUM,pb.ERRORNO_CPNT_ENUM,pb.ERRORNOT_TIME_ENUM,pb.ERRORNO_POS_ENUM,pb.ERRORPARAM_ERR_ENUM,pb.ERRORNO_ELECTRICITY_ENUM,pb.ERRORNO_LABOR_ENUM,pb.ERRORPRODUCT_LINE_ERROR_ENUM,pb.ERRORNO_HULL_RES_ENUM,pb.ERRORLABOR_ROOM_BOOM_ENUM,pb.ERRORBUILDING_MAX_LEVEL_ENUM,pb.ERRORNOT_FOUND_REN_PLANT_ENUM,pb.ERRORNO_MORE_BUILD_QUEUE_ENUM,pb.ERRORBUILDING_FINISHED_ENUM,pb.ERRORPRE_CONDITION_NOT_ENOUGH_ENUM,pb.ERRORNO_ELE_ENUM,pb.ERRORHAVE_OWNER_ENUM,pb.ERRORSPEED_UP_ERROR_ENUM,pb.ERRORBUILDING_COUNT_LIMIT_ENUM,pb.ERRORTASK_ONLINE_COUNT_LIMIT_ENUM,pb.ERRORTASK_ONLINE_TIME_LIMIT_ENUM,pb.ERRORMARK_COUNT_LIMIT_ENUM,pb.ERRORSYS_MARK_CANNOT_CANCEL_ENUM,pb.ERRORSKILL_POINT_NOT_ENOUGH_ENUM,pb.ERRORSTAR_DUST_NOT_ENOUGH_ENUM,pb.ERRORMOD_NAME_ERR_ENUM,pb.ERRORUSER_LEVEL_NOT_ENOUGH_ENUM,pb.ERRORPRODUCT_QUEUE_FULL_ENUM,pb.ERRORNOT_FOUND_CONFIG_ENUM,pb.ERRORBUILDING_LEVEL_ERR_ENUM}
pb.FLEETSTATUSBERTH_ENUM.name = "BERTH"
pb.FLEETSTATUSBERTH_ENUM.index = 0
pb.FLEETSTATUSBERTH_ENUM.number = 1
pb.FLEETSTATUSMOVE_ENUM.name = "MOVE"
pb.FLEETSTATUSMOVE_ENUM.index = 1
pb.FLEETSTATUSMOVE_ENUM.number = 2
pb.FLEETSTATUSEXPLORE_ENUM.name = "EXPLORE"
pb.FLEETSTATUSEXPLORE_ENUM.index = 2
pb.FLEETSTATUSEXPLORE_ENUM.number = 3
pb.FLEETSTATUSCOLLECT_ENUM.name = "COLLECT"
pb.FLEETSTATUSCOLLECT_ENUM.index = 3
pb.FLEETSTATUSCOLLECT_ENUM.number = 4
pb.FLEETSTATUSRETURN_ENUM.name = "RETURN"
pb.FLEETSTATUSRETURN_ENUM.index = 4
pb.FLEETSTATUSRETURN_ENUM.number = 5
pb.FLEETSTATUS.name = "FleetStatus"
pb.FLEETSTATUS.full_name = ".com.nkm.common.proto.client.FleetStatus"
pb.FLEETSTATUS.values = {pb.FLEETSTATUSBERTH_ENUM,pb.FLEETSTATUSMOVE_ENUM,pb.FLEETSTATUSEXPLORE_ENUM,pb.FLEETSTATUSCOLLECT_ENUM,pb.FLEETSTATUSRETURN_ENUM}
pb.SHIPTYPESHIP_FUNC_SETTLEMENT_ENUM.name = "SHIP_FUNC_SETTLEMENT"
pb.SHIPTYPESHIP_FUNC_SETTLEMENT_ENUM.index = 0
pb.SHIPTYPESHIP_FUNC_SETTLEMENT_ENUM.number = 1
pb.SHIPTYPESHIP_FUNC_EXPLORE_ENUM.name = "SHIP_FUNC_EXPLORE"
pb.SHIPTYPESHIP_FUNC_EXPLORE_ENUM.index = 1
pb.SHIPTYPESHIP_FUNC_EXPLORE_ENUM.number = 2
pb.SHIPTYPESHIP_FUNC_COLLECT_ENUM.name = "SHIP_FUNC_COLLECT"
pb.SHIPTYPESHIP_FUNC_COLLECT_ENUM.index = 2
pb.SHIPTYPESHIP_FUNC_COLLECT_ENUM.number = 3
pb.SHIPTYPESHIP_FUNC_TARANSPORT_ENUM.name = "SHIP_FUNC_TARANSPORT"
pb.SHIPTYPESHIP_FUNC_TARANSPORT_ENUM.index = 3
pb.SHIPTYPESHIP_FUNC_TARANSPORT_ENUM.number = 4
pb.SHIPTYPE.name = "ShipType"
pb.SHIPTYPE.full_name = ".com.nkm.common.proto.client.ShipType"
pb.SHIPTYPE.values = {pb.SHIPTYPESHIP_FUNC_SETTLEMENT_ENUM,pb.SHIPTYPESHIP_FUNC_EXPLORE_ENUM,pb.SHIPTYPESHIP_FUNC_COLLECT_ENUM,pb.SHIPTYPESHIP_FUNC_TARANSPORT_ENUM}
pb.BUILDINGTYPESPACESTATION_ENUM.name = "SPACESTATION"
pb.BUILDINGTYPESPACESTATION_ENUM.index = 0
pb.BUILDINGTYPESPACESTATION_ENUM.number = 101
pb.BUILDINGTYPESPACEPORT_ENUM.name = "SPACEPORT"
pb.BUILDINGTYPESPACEPORT_ENUM.index = 1
pb.BUILDINGTYPESPACEPORT_ENUM.number = 102
pb.BUILDINGTYPEHULLFACT_ENUM.name = "HULLFACT"
pb.BUILDINGTYPEHULLFACT_ENUM.index = 2
pb.BUILDINGTYPEHULLFACT_ENUM.number = 103
pb.BUILDINGTYPEMODFACT_ENUM.name = "MODFACT"
pb.BUILDINGTYPEMODFACT_ENUM.index = 3
pb.BUILDINGTYPEMODFACT_ENUM.number = 104
pb.BUILDINGTYPECPNTFACT_ENUM.name = "CPNTFACT"
pb.BUILDINGTYPECPNTFACT_ENUM.index = 4
pb.BUILDINGTYPECPNTFACT_ENUM.number = 105
pb.BUILDINGTYPESURFCOL_ENUM.name = "SURFCOL"
pb.BUILDINGTYPESURFCOL_ENUM.index = 5
pb.BUILDINGTYPESURFCOL_ENUM.number = 201
pb.BUILDINGTYPEREFINERY_ENUM.name = "REFINERY"
pb.BUILDINGTYPEREFINERY_ENUM.index = 6
pb.BUILDINGTYPEREFINERY_ENUM.number = 202
pb.BUILDINGTYPEPOWERPLANT_ENUM.name = "POWERPLANT"
pb.BUILDINGTYPEPOWERPLANT_ENUM.index = 7
pb.BUILDINGTYPEPOWERPLANT_ENUM.number = 203
pb.BUILDINGTYPEITEMSTG_ENUM.name = "ITEMSTG"
pb.BUILDINGTYPEITEMSTG_ENUM.index = 8
pb.BUILDINGTYPEITEMSTG_ENUM.number = 204
pb.BUILDINGTYPEHABITAT_ENUM.name = "HABITAT"
pb.BUILDINGTYPEHABITAT_ENUM.index = 9
pb.BUILDINGTYPEHABITAT_ENUM.number = 301
pb.BUILDINGTYPE.name = "BuildingType"
pb.BUILDINGTYPE.full_name = ".com.nkm.common.proto.client.BuildingType"
pb.BUILDINGTYPE.values = {pb.BUILDINGTYPESPACESTATION_ENUM,pb.BUILDINGTYPESPACEPORT_ENUM,pb.BUILDINGTYPEHULLFACT_ENUM,pb.BUILDINGTYPEMODFACT_ENUM,pb.BUILDINGTYPECPNTFACT_ENUM,pb.BUILDINGTYPESURFCOL_ENUM,pb.BUILDINGTYPEREFINERY_ENUM,pb.BUILDINGTYPEPOWERPLANT_ENUM,pb.BUILDINGTYPEITEMSTG_ENUM,pb.BUILDINGTYPEHABITAT_ENUM}
pb.BUILDINGSTATUSNORMAL_ENUM.name = "NORMAL"
pb.BUILDINGSTATUSNORMAL_ENUM.index = 0
pb.BUILDINGSTATUSNORMAL_ENUM.number = 0
pb.BUILDINGSTATUSCREATE_ENUM.name = "CREATE"
pb.BUILDINGSTATUSCREATE_ENUM.index = 1
pb.BUILDINGSTATUSCREATE_ENUM.number = 1
pb.BUILDINGSTATUSWORKING_ENUM.name = "WORKING"
pb.BUILDINGSTATUSWORKING_ENUM.index = 2
pb.BUILDINGSTATUSWORKING_ENUM.number = 2
pb.BUILDINGSTATUS.name = "BuildingStatus"
pb.BUILDINGSTATUS.full_name = ".com.nkm.common.proto.client.BuildingStatus"
pb.BUILDINGSTATUS.values = {pb.BUILDINGSTATUSNORMAL_ENUM,pb.BUILDINGSTATUSCREATE_ENUM,pb.BUILDINGSTATUSWORKING_ENUM}
pb.NODESTATUSCOMMON_ENUM.name = "COMMON"
pb.NODESTATUSCOMMON_ENUM.index = 0
pb.NODESTATUSCOMMON_ENUM.number = 0
pb.NODESTATUSDEFEND_ENUM.name = "DEFEND"
pb.NODESTATUSDEFEND_ENUM.index = 1
pb.NODESTATUSDEFEND_ENUM.number = 1
pb.NODESTATUSBLOCK_ENUM.name = "BLOCK"
pb.NODESTATUSBLOCK_ENUM.index = 2
pb.NODESTATUSBLOCK_ENUM.number = 2
pb.NODESTATUS.name = "NodeStatus"
pb.NODESTATUS.full_name = ".com.nkm.common.proto.client.NodeStatus"
pb.NODESTATUS.values = {pb.NODESTATUSCOMMON_ENUM,pb.NODESTATUSDEFEND_ENUM,pb.NODESTATUSBLOCK_ENUM}
pb.TECHSTATUSREGULAR_ENUM.name = "REGULAR"
pb.TECHSTATUSREGULAR_ENUM.index = 0
pb.TECHSTATUSREGULAR_ENUM.number = 0
pb.TECHSTATUSBUILDING_ENUM.name = "BUILDING"
pb.TECHSTATUSBUILDING_ENUM.index = 1
pb.TECHSTATUSBUILDING_ENUM.number = 1
pb.TECHSTATUS.name = "TechStatus"
pb.TECHSTATUS.full_name = ".com.nkm.common.proto.client.TechStatus"
pb.TECHSTATUS.values = {pb.TECHSTATUSREGULAR_ENUM,pb.TECHSTATUSBUILDING_ENUM}

ACCOUNT_ERR = 2
ADDMODTOLINE = 103
ADDUSERMOD = 63
ALREADY_EXPLORER = 13
BERTH = 1
BIRTHNODE_ERR = 4
BLOCK = 2
BUILDFINISHED = 61
BUILDING = 1
BUILDINGLEVELUP = 113
BUILDINGQUEUEMSG = 114
BUILDING_COUNT_LIMIT = 52
BUILDING_ERR = 5
BUILDING_FINISHED = 47
BUILDING_LEVEL_ERR = 63
BUILDING_LEVEL_NOT_ENOUGH = 24
BUILDING_MAP_ERR = 26
BUILDING_MAX_LEVEL = 44
BUILDING_STATUS_ERR = 19
BUILDSPEEDUP = 62
CANCELBUILDING = 116
CANCELMARK = 11
CAPPCITY_BOOM = 21
CLIENT_ERR = 16
COLLECT = 4
COLLECTIONPLANTCOLLECT = 71
COLLECTIONPLANTSTART = 70
COMMON = 0
CPNTFACT = 105
CREATE = 1
CREATEBUILDING = 60
CREATEFLEET = 85
CREATESHIP = 72
DEFEND = 1
DELMOD = 110
DELSHIP = 88
DEPTH_DIFFER = 32
DISMISSFLEET = 84
DOING_SOMETHING_ERR = 14
EDITFLEET = 86
EDITFLEETNAME = 90
EDITHULLPRODUCTLINE = 101
EDITMOD = 111
EDITPOS = 87
EDITSHIP = 112
ENDFLEETCOLLECT = 44
ERROR = -1
EXPLORE = 3
FLEETCOLLECT = 43
FLEETLIST = 9
FLEETMOVE = 4
FLEETMOVEFINISHED = 6
FLEETMOVESTART = 5
FLEETSPEEDUP = 8
FLEET_CANT_ACTION = 12
FLEET_CANT_FIND = 15
FLEET_MAP_ERR = 10
FLEET_SPEED_UP_ERR = 18
GETALLEDITSHIP = 109
GETCOLLECTIONPLANTINFO = 73
GETFLEETINNODE = 42
GETNODEDATA = 41
GETPORTFLEET = 83
GETPORTSHIP = 80
GETPRODUCTLINEPRODUCT = 102
GETSHIPBYFLEET = 82
GETSTOREHOUSE = 69
GETTECH = 120
GETUSERDATA = 2
GM = 990
GM_ERR = 29
GUIDE = 951
HABITAT = 301
HAVE_OWNER = 50
HEART = 0
HULLFACT = 103
HULLFACTMSG = 100
ITEMSTG = 204
LABOR_ROOM_BOOM = 43
LOADGOODS = 81
LOGIN = 1
LOGOUT = 992
MAP_ERR = 8
MARKLIST = 12
MARK_COUNT_LIMIT = 55
MAX_REQUEST_NODE_COUNT = 9
MODFACT = 104
MOD_NAME_ERR = 59
MOVE = 2
MOVEBUILDING = 118
MOVE_MAP_ERR = 6
NETTYPELOBBY = 1
NORMAL = 0
NOT_EXPLORED = 17
NOT_FOUND_CONFIG = 62
NOT_FOUND_REN_PLANT = 45
NOT_MATCH_MOD_TECH = 33
NOT_TIME = 36
NO_CPNT = 35
NO_ELE = 49
NO_ELECTRICITY = 39
NO_HULL = 34
NO_HULL_RES = 42
NO_LABOR = 40
NO_MOD = 28
NO_MODFACT = 31
NO_MORE_BUILD_QUEUE = 46
NO_MORE_ITEM_NUM = 22
NO_POS = 37
NO_SPACEPORT = 30
PARAM_ERR = 38
PLANET_EXIST_FLEET = 11
POWERPLANT = 203
PRE_CONDITION_NOT_ENOUGH = 48
PRODUCT_LINE_ERROR = 41
PRODUCT_QUEUE_FULL = 61
REFINERY = 202
REFINERYCOLLECT = 68
REFINERYEND = 67
REFINERYINFOR = 65
REFINERYSTART = 66
REGULAR = 0
REMOVEBUILDING = 117
RETURN = 5
SCENENODEDATA = 3
SCENEOPENMAP = 7
SELLITEM = 115
SERVER_ERR = 1
SETMARK = 10
SHIP_FUNC_COLLECT = 3
SHIP_FUNC_EXPLORE = 2
SHIP_FUNC_SETTLEMENT = 1
SHIP_FUNC_TARANSPORT = 4
SKILL_POINT_NOT_ENOUGH = 57
SPACEBASEINFO = 79
SPACEPORT = 102
SPACESTATION = 101
SPEEDUP = 125
SPEED_UP_ERROR = 51
SPLITSHIP = 89
STAR_DUST_NOT_ENOUGH = 58
SURFCOL = 201
SYS_MARK_CANNOT_CANCEL = 56
TASKONLINECOLLECT = 950
TASK_ONLINE_COUNT_LIMIT = 53
TASK_ONLINE_TIME_LIMIT = 54
TECHCANCEL = 124
TECHFINISHED = 123
TECHLEVELUP = 121
TECHSPEEDUP = 122
TO_NODE_FLEET_COUNT_FULL = 7
USERLEVELUP = 952
USERMODS = 64
USER_ERR = 3
USER_LEVEL_NOT_ENOUGH = 60
WITHOUT_BUILDING = 25
WITHOUT_ITEM = 23
WITHOUT_OWNER = 20
WITHOUT_WORKING = 27
WORKING = 2
