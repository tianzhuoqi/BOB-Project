-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
local db_pb = require("db_pb")
local common_pb = require("common_pb")
local buildingPort_pb = require("buildingPort_pb")
local db_pb = require("db_pb")
local common_pb = require("common_pb")
local db_pb = require("db_pb")
local node_pb = require("node_pb")
local common_pb = require("common_pb")
module('buildingCollectionPlant_pb')


local pb = {}
pb.TCSCOLLECTIONPLANTSTART = protobuf.Descriptor();
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD = protobuf.FieldDescriptor();
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD = protobuf.FieldDescriptor();
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTSTART = protobuf.Descriptor();
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD = protobuf.FieldDescriptor();
pb.TCSCOLLECTIONPLANTCOLLECT = protobuf.Descriptor();
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTCOLLECT = protobuf.Descriptor();
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD = protobuf.FieldDescriptor();
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD = protobuf.FieldDescriptor();
pb.TCSGETCOLLECTIONPLANTINFO = protobuf.Descriptor();
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD = protobuf.FieldDescriptor();
pb.TSCGETCOLLECTIONPLANTINFO = protobuf.Descriptor();
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD = protobuf.FieldDescriptor();
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD = protobuf.FieldDescriptor();
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD = protobuf.FieldDescriptor();
pb.COLLECTINFO = protobuf.Descriptor();
pb.COLLECTINFOREMAININGCOUNT_FIELD = protobuf.FieldDescriptor();
pb.COLLECTINFOSTARTTIME_FIELD = protobuf.FieldDescriptor();
pb.COLLECTINFOSTATUS_FIELD = protobuf.FieldDescriptor();

pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.name = "buildingId"
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.full_name = ".com.nkm.common.proto.client.TCSCollectionPlantStart.buildingId"
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.number = 1
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.index = 0
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.label = 1
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.has_default_value = false
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.default_value = 0
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.type = 3
pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD.cpp_type = 2

pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.name = "resourceId"
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.full_name = ".com.nkm.common.proto.client.TCSCollectionPlantStart.resourceId"
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.number = 2
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.index = 1
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.label = 1
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.has_default_value = false
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.default_value = 0
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.type = 5
pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD.cpp_type = 1

pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.name = "planetId"
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.full_name = ".com.nkm.common.proto.client.TCSCollectionPlantStart.planetId"
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.number = 3
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.index = 2
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.label = 1
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.has_default_value = false
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.default_value = 0
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.type = 5
pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD.cpp_type = 1

pb.TCSCOLLECTIONPLANTSTART.name = "TCSCollectionPlantStart"
pb.TCSCOLLECTIONPLANTSTART.full_name = ".com.nkm.common.proto.client.TCSCollectionPlantStart"
pb.TCSCOLLECTIONPLANTSTART.nested_types = {}
pb.TCSCOLLECTIONPLANTSTART.enum_types = {}
pb.TCSCOLLECTIONPLANTSTART.fields = {pb.TCSCOLLECTIONPLANTSTARTBUILDINGID_FIELD, pb.TCSCOLLECTIONPLANTSTARTRESOURCEID_FIELD, pb.TCSCOLLECTIONPLANTSTARTPLANETID_FIELD}
pb.TCSCOLLECTIONPLANTSTART.is_extendable = false
pb.TCSCOLLECTIONPLANTSTART.extensions = {}
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.name = "buildingId"
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantStart.buildingId"
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.number = 1
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.index = 0
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.label = 1
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.default_value = 0
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.type = 3
pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD.cpp_type = 2

pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.name = "collectInfo"
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantStart.collectInfo"
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.number = 2
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.index = 1
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.label = 1
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.default_value = nil
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.message_type = pb.COLLECTINFO
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.type = 11
pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD.cpp_type = 10

pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.name = "nodeBuilding"
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantStart.nodeBuilding"
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.number = 3
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.index = 2
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.label = 1
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.default_value = nil
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.message_type = node_pb.NodeBuilding
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.type = 11
pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD.cpp_type = 10

pb.TSCCOLLECTIONPLANTSTART.name = "TSCCollectionPlantStart"
pb.TSCCOLLECTIONPLANTSTART.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantStart"
pb.TSCCOLLECTIONPLANTSTART.nested_types = {}
pb.TSCCOLLECTIONPLANTSTART.enum_types = {}
pb.TSCCOLLECTIONPLANTSTART.fields = {pb.TSCCOLLECTIONPLANTSTARTBUILDINGID_FIELD, pb.TSCCOLLECTIONPLANTSTARTCOLLECTINFO_FIELD, pb.TSCCOLLECTIONPLANTSTARTNODEBUILDING_FIELD}
pb.TSCCOLLECTIONPLANTSTART.is_extendable = false
pb.TSCCOLLECTIONPLANTSTART.extensions = {}
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.name = "buildingId"
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.full_name = ".com.nkm.common.proto.client.TCSCollectionPlantCollect.buildingId"
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.number = 1
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.index = 0
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.label = 1
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.has_default_value = false
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.default_value = 0
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.type = 3
pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD.cpp_type = 2

pb.TCSCOLLECTIONPLANTCOLLECT.name = "TCSCollectionPlantCollect"
pb.TCSCOLLECTIONPLANTCOLLECT.full_name = ".com.nkm.common.proto.client.TCSCollectionPlantCollect"
pb.TCSCOLLECTIONPLANTCOLLECT.nested_types = {}
pb.TCSCOLLECTIONPLANTCOLLECT.enum_types = {}
pb.TCSCOLLECTIONPLANTCOLLECT.fields = {pb.TCSCOLLECTIONPLANTCOLLECTBUILDINGID_FIELD}
pb.TCSCOLLECTIONPLANTCOLLECT.is_extendable = false
pb.TCSCOLLECTIONPLANTCOLLECT.extensions = {}
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.name = "result"
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantCollect.result"
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.number = 1
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.index = 0
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.label = 1
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.default_value = 0
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.type = 5
pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD.cpp_type = 1

pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.name = "collectInfo"
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantCollect.collectInfo"
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.number = 2
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.index = 1
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.label = 1
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.default_value = nil
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.message_type = pb.COLLECTINFO
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.type = 11
pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD.cpp_type = 10

pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.name = "item"
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantCollect.item"
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.number = 3
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.index = 2
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.label = 1
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.default_value = nil
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.message_type = db_pb.Item
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.type = 11
pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD.cpp_type = 10

pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.name = "building"
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantCollect.building"
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.number = 4
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.index = 3
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.label = 1
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.has_default_value = false
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.default_value = nil
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.message_type = node_pb.NodeBuilding
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.type = 11
pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD.cpp_type = 10

pb.TSCCOLLECTIONPLANTCOLLECT.name = "TSCCollectionPlantCollect"
pb.TSCCOLLECTIONPLANTCOLLECT.full_name = ".com.nkm.common.proto.client.TSCCollectionPlantCollect"
pb.TSCCOLLECTIONPLANTCOLLECT.nested_types = {}
pb.TSCCOLLECTIONPLANTCOLLECT.enum_types = {}
pb.TSCCOLLECTIONPLANTCOLLECT.fields = {pb.TSCCOLLECTIONPLANTCOLLECTRESULT_FIELD, pb.TSCCOLLECTIONPLANTCOLLECTCOLLECTINFO_FIELD, pb.TSCCOLLECTIONPLANTCOLLECTITEM_FIELD, pb.TSCCOLLECTIONPLANTCOLLECTBUILDING_FIELD}
pb.TSCCOLLECTIONPLANTCOLLECT.is_extendable = false
pb.TSCCOLLECTIONPLANTCOLLECT.extensions = {}
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.name = "buildingId"
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.full_name = ".com.nkm.common.proto.client.TCSGetCollectionPlantInfo.buildingId"
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.number = 1
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.index = 0
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.label = 1
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.has_default_value = false
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.default_value = 0
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.type = 3
pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD.cpp_type = 2

pb.TCSGETCOLLECTIONPLANTINFO.name = "TCSGetCollectionPlantInfo"
pb.TCSGETCOLLECTIONPLANTINFO.full_name = ".com.nkm.common.proto.client.TCSGetCollectionPlantInfo"
pb.TCSGETCOLLECTIONPLANTINFO.nested_types = {}
pb.TCSGETCOLLECTIONPLANTINFO.enum_types = {}
pb.TCSGETCOLLECTIONPLANTINFO.fields = {pb.TCSGETCOLLECTIONPLANTINFOBUILDINGID_FIELD}
pb.TCSGETCOLLECTIONPLANTINFO.is_extendable = false
pb.TCSGETCOLLECTIONPLANTINFO.extensions = {}
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.name = "resourceId"
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetCollectionPlantInfo.resourceId"
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.number = 1
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.index = 0
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.label = 1
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.has_default_value = false
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.default_value = 0
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.type = 5
pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD.cpp_type = 1

pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.name = "planetId"
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetCollectionPlantInfo.planetId"
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.number = 2
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.index = 1
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.label = 1
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.has_default_value = false
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.default_value = 0
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.type = 5
pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD.cpp_type = 1

pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.name = "collectInfo"
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetCollectionPlantInfo.collectInfo"
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.number = 3
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.index = 2
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.label = 1
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.has_default_value = false
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.default_value = nil
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.message_type = pb.COLLECTINFO
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.type = 11
pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD.cpp_type = 10

pb.TSCGETCOLLECTIONPLANTINFO.name = "TSCGetCollectionPlantInfo"
pb.TSCGETCOLLECTIONPLANTINFO.full_name = ".com.nkm.common.proto.client.TSCGetCollectionPlantInfo"
pb.TSCGETCOLLECTIONPLANTINFO.nested_types = {}
pb.TSCGETCOLLECTIONPLANTINFO.enum_types = {}
pb.TSCGETCOLLECTIONPLANTINFO.fields = {pb.TSCGETCOLLECTIONPLANTINFORESOURCEID_FIELD, pb.TSCGETCOLLECTIONPLANTINFOPLANETID_FIELD, pb.TSCGETCOLLECTIONPLANTINFOCOLLECTINFO_FIELD}
pb.TSCGETCOLLECTIONPLANTINFO.is_extendable = false
pb.TSCGETCOLLECTIONPLANTINFO.extensions = {}
pb.COLLECTINFOREMAININGCOUNT_FIELD.name = "remainingCount"
pb.COLLECTINFOREMAININGCOUNT_FIELD.full_name = ".com.nkm.common.proto.client.CollectInfo.remainingCount"
pb.COLLECTINFOREMAININGCOUNT_FIELD.number = 1
pb.COLLECTINFOREMAININGCOUNT_FIELD.index = 0
pb.COLLECTINFOREMAININGCOUNT_FIELD.label = 1
pb.COLLECTINFOREMAININGCOUNT_FIELD.has_default_value = false
pb.COLLECTINFOREMAININGCOUNT_FIELD.default_value = 0
pb.COLLECTINFOREMAININGCOUNT_FIELD.type = 5
pb.COLLECTINFOREMAININGCOUNT_FIELD.cpp_type = 1

pb.COLLECTINFOSTARTTIME_FIELD.name = "startTime"
pb.COLLECTINFOSTARTTIME_FIELD.full_name = ".com.nkm.common.proto.client.CollectInfo.startTime"
pb.COLLECTINFOSTARTTIME_FIELD.number = 2
pb.COLLECTINFOSTARTTIME_FIELD.index = 1
pb.COLLECTINFOSTARTTIME_FIELD.label = 1
pb.COLLECTINFOSTARTTIME_FIELD.has_default_value = false
pb.COLLECTINFOSTARTTIME_FIELD.default_value = 0
pb.COLLECTINFOSTARTTIME_FIELD.type = 3
pb.COLLECTINFOSTARTTIME_FIELD.cpp_type = 2

pb.COLLECTINFOSTATUS_FIELD.name = "status"
pb.COLLECTINFOSTATUS_FIELD.full_name = ".com.nkm.common.proto.client.CollectInfo.status"
pb.COLLECTINFOSTATUS_FIELD.number = 3
pb.COLLECTINFOSTATUS_FIELD.index = 2
pb.COLLECTINFOSTATUS_FIELD.label = 1
pb.COLLECTINFOSTATUS_FIELD.has_default_value = false
pb.COLLECTINFOSTATUS_FIELD.default_value = 0
pb.COLLECTINFOSTATUS_FIELD.type = 5
pb.COLLECTINFOSTATUS_FIELD.cpp_type = 1

pb.COLLECTINFO.name = "CollectInfo"
pb.COLLECTINFO.full_name = ".com.nkm.common.proto.client.CollectInfo"
pb.COLLECTINFO.nested_types = {}
pb.COLLECTINFO.enum_types = {}
pb.COLLECTINFO.fields = {pb.COLLECTINFOREMAININGCOUNT_FIELD, pb.COLLECTINFOSTARTTIME_FIELD, pb.COLLECTINFOSTATUS_FIELD}
pb.COLLECTINFO.is_extendable = false
pb.COLLECTINFO.extensions = {}

CollectInfo = protobuf.Message(pb.COLLECTINFO)
TCSCollectionPlantCollect = protobuf.Message(pb.TCSCOLLECTIONPLANTCOLLECT)
TCSCollectionPlantStart = protobuf.Message(pb.TCSCOLLECTIONPLANTSTART)
TCSGetCollectionPlantInfo = protobuf.Message(pb.TCSGETCOLLECTIONPLANTINFO)
TSCCollectionPlantCollect = protobuf.Message(pb.TSCCOLLECTIONPLANTCOLLECT)
TSCCollectionPlantStart = protobuf.Message(pb.TSCCOLLECTIONPLANTSTART)
TSCGetCollectionPlantInfo = protobuf.Message(pb.TSCGETCOLLECTIONPLANTINFO)
