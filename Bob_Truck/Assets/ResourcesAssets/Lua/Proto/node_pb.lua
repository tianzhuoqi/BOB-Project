-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
local db_pb = require("db_pb")
local common_pb = require("common_pb")
local buildingPort_pb = require("buildingPort_pb")
local db_pb = require("db_pb")
local common_pb = require("common_pb")
module('node_pb')


local pb = {}
pb.TCSGETNODEDATA = protobuf.Descriptor();
pb.TCSGETNODEDATANODEID_FIELD = protobuf.FieldDescriptor();
pb.TSCGETNODEDATA = protobuf.Descriptor();
pb.TSCGETNODEDATAPLANET_FIELD = protobuf.FieldDescriptor();
pb.TSCGETNODEDATAFLEET_FIELD = protobuf.FieldDescriptor();
pb.TSCGETNODEDATABUILDING_FIELD = protobuf.FieldDescriptor();
pb.TSCGETNODEDATATOTALCAP_FIELD = protobuf.FieldDescriptor();
pb.TSCGETNODEDATARESTOFCAP_FIELD = protobuf.FieldDescriptor();
pb.TSCGETNODEDATAELECMSG_FIELD = protobuf.FieldDescriptor();
pb.ELECMSG = protobuf.Descriptor();
pb.ELECMSGTOTALELECT_FIELD = protobuf.FieldDescriptor();
pb.ELECMSGRESTOFELECT_FIELD = protobuf.FieldDescriptor();
pb.ELECMSGELECRECOVERCOUNT_FIELD = protobuf.FieldDescriptor();
pb.ELECMSGELECTRICITYSTARTTIME_FIELD = protobuf.FieldDescriptor();
pb.TCSGETFLEETINNODE = protobuf.Descriptor();
pb.TCSGETFLEETINNODENODEID_FIELD = protobuf.FieldDescriptor();
pb.TSCGETFLEETINNODE = protobuf.Descriptor();
pb.TSCGETFLEETINNODEFLEET_FIELD = protobuf.FieldDescriptor();
pb.TSCGETFLEETINNODEOWNER_FIELD = protobuf.FieldDescriptor();
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD = protobuf.FieldDescriptor();
pb.TCSFLEETCOLLECT = protobuf.Descriptor();
pb.TCSFLEETCOLLECTNODEID_FIELD = protobuf.FieldDescriptor();
pb.TCSFLEETCOLLECTFLEETID_FIELD = protobuf.FieldDescriptor();
pb.TSCFLEETCOLLECT = protobuf.Descriptor();
pb.TSCFLEETCOLLECTNODEID_FIELD = protobuf.FieldDescriptor();
pb.TSCFLEETCOLLECTFLEETID_FIELD = protobuf.FieldDescriptor();
pb.TSCFLEETCOLLECTENDTIME_FIELD = protobuf.FieldDescriptor();
pb.TCSENDFLEETCOLLECT = protobuf.Descriptor();
pb.TCSENDFLEETCOLLECTNODEID_FIELD = protobuf.FieldDescriptor();
pb.TCSENDFLEETCOLLECTFLEETID_FIELD = protobuf.FieldDescriptor();
pb.TSCENDFLEETCOLLECT = protobuf.Descriptor();
pb.TSCENDFLEETCOLLECTNODEID_FIELD = protobuf.FieldDescriptor();
pb.TSCENDFLEETCOLLECTFLEETID_FIELD = protobuf.FieldDescriptor();
pb.TSCENDFLEETCOLLECTITEM_FIELD = protobuf.FieldDescriptor();
pb.PLANET = protobuf.Descriptor();
pb.PLANETID_FIELD = protobuf.FieldDescriptor();
pb.PLANETDEPTH_FIELD = protobuf.FieldDescriptor();
pb.PLANETS = protobuf.Descriptor();
pb.PLANETSPLANET_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEET = protobuf.Descriptor();
pb.NODEFLEETFLEETID_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETUID_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETNODEID_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETUSERNAME_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETCOLLECTSPEED_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETRESOURCECAPACITY_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETFLEETCAPACITY_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETSTATUS_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETTIME_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETENDTIME_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETUSERSHIPS_FIELD = protobuf.FieldDescriptor();
pb.NODEFLEETFLEETNAME_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDING = protobuf.Descriptor();
pb.NODEBUILDINGID_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGPOS_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGSTATUS_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGSTARTTIME_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGENDTIME_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGGETITEMTIME_FIELD = protobuf.FieldDescriptor();
pb.NODEBUILDINGFLEETS_FIELD = protobuf.FieldDescriptor();

pb.TCSGETNODEDATANODEID_FIELD.name = "nodeId"
pb.TCSGETNODEDATANODEID_FIELD.full_name = ".com.nkm.common.proto.client.TCSGetNodeData.nodeId"
pb.TCSGETNODEDATANODEID_FIELD.number = 1
pb.TCSGETNODEDATANODEID_FIELD.index = 0
pb.TCSGETNODEDATANODEID_FIELD.label = 2
pb.TCSGETNODEDATANODEID_FIELD.has_default_value = false
pb.TCSGETNODEDATANODEID_FIELD.default_value = 0
pb.TCSGETNODEDATANODEID_FIELD.type = 3
pb.TCSGETNODEDATANODEID_FIELD.cpp_type = 2

pb.TCSGETNODEDATA.name = "TCSGetNodeData"
pb.TCSGETNODEDATA.full_name = ".com.nkm.common.proto.client.TCSGetNodeData"
pb.TCSGETNODEDATA.nested_types = {}
pb.TCSGETNODEDATA.enum_types = {}
pb.TCSGETNODEDATA.fields = {pb.TCSGETNODEDATANODEID_FIELD}
pb.TCSGETNODEDATA.is_extendable = false
pb.TCSGETNODEDATA.extensions = {}
pb.TSCGETNODEDATAPLANET_FIELD.name = "planet"
pb.TSCGETNODEDATAPLANET_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetNodeData.planet"
pb.TSCGETNODEDATAPLANET_FIELD.number = 1
pb.TSCGETNODEDATAPLANET_FIELD.index = 0
pb.TSCGETNODEDATAPLANET_FIELD.label = 3
pb.TSCGETNODEDATAPLANET_FIELD.has_default_value = false
pb.TSCGETNODEDATAPLANET_FIELD.default_value = {}
pb.TSCGETNODEDATAPLANET_FIELD.message_type = pb.PLANET
pb.TSCGETNODEDATAPLANET_FIELD.type = 11
pb.TSCGETNODEDATAPLANET_FIELD.cpp_type = 10

pb.TSCGETNODEDATAFLEET_FIELD.name = "fleet"
pb.TSCGETNODEDATAFLEET_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetNodeData.fleet"
pb.TSCGETNODEDATAFLEET_FIELD.number = 2
pb.TSCGETNODEDATAFLEET_FIELD.index = 1
pb.TSCGETNODEDATAFLEET_FIELD.label = 3
pb.TSCGETNODEDATAFLEET_FIELD.has_default_value = false
pb.TSCGETNODEDATAFLEET_FIELD.default_value = {}
pb.TSCGETNODEDATAFLEET_FIELD.message_type = pb.NODEFLEET
pb.TSCGETNODEDATAFLEET_FIELD.type = 11
pb.TSCGETNODEDATAFLEET_FIELD.cpp_type = 10

pb.TSCGETNODEDATABUILDING_FIELD.name = "building"
pb.TSCGETNODEDATABUILDING_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetNodeData.building"
pb.TSCGETNODEDATABUILDING_FIELD.number = 3
pb.TSCGETNODEDATABUILDING_FIELD.index = 2
pb.TSCGETNODEDATABUILDING_FIELD.label = 3
pb.TSCGETNODEDATABUILDING_FIELD.has_default_value = false
pb.TSCGETNODEDATABUILDING_FIELD.default_value = {}
pb.TSCGETNODEDATABUILDING_FIELD.message_type = pb.NODEBUILDING
pb.TSCGETNODEDATABUILDING_FIELD.type = 11
pb.TSCGETNODEDATABUILDING_FIELD.cpp_type = 10

pb.TSCGETNODEDATATOTALCAP_FIELD.name = "totalCap"
pb.TSCGETNODEDATATOTALCAP_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetNodeData.totalCap"
pb.TSCGETNODEDATATOTALCAP_FIELD.number = 4
pb.TSCGETNODEDATATOTALCAP_FIELD.index = 3
pb.TSCGETNODEDATATOTALCAP_FIELD.label = 1
pb.TSCGETNODEDATATOTALCAP_FIELD.has_default_value = false
pb.TSCGETNODEDATATOTALCAP_FIELD.default_value = 0
pb.TSCGETNODEDATATOTALCAP_FIELD.type = 5
pb.TSCGETNODEDATATOTALCAP_FIELD.cpp_type = 1

pb.TSCGETNODEDATARESTOFCAP_FIELD.name = "restOfCap"
pb.TSCGETNODEDATARESTOFCAP_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetNodeData.restOfCap"
pb.TSCGETNODEDATARESTOFCAP_FIELD.number = 5
pb.TSCGETNODEDATARESTOFCAP_FIELD.index = 4
pb.TSCGETNODEDATARESTOFCAP_FIELD.label = 1
pb.TSCGETNODEDATARESTOFCAP_FIELD.has_default_value = false
pb.TSCGETNODEDATARESTOFCAP_FIELD.default_value = 0
pb.TSCGETNODEDATARESTOFCAP_FIELD.type = 5
pb.TSCGETNODEDATARESTOFCAP_FIELD.cpp_type = 1

pb.TSCGETNODEDATAELECMSG_FIELD.name = "elecMsg"
pb.TSCGETNODEDATAELECMSG_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetNodeData.elecMsg"
pb.TSCGETNODEDATAELECMSG_FIELD.number = 6
pb.TSCGETNODEDATAELECMSG_FIELD.index = 5
pb.TSCGETNODEDATAELECMSG_FIELD.label = 1
pb.TSCGETNODEDATAELECMSG_FIELD.has_default_value = false
pb.TSCGETNODEDATAELECMSG_FIELD.default_value = nil
pb.TSCGETNODEDATAELECMSG_FIELD.message_type = pb.ELECMSG
pb.TSCGETNODEDATAELECMSG_FIELD.type = 11
pb.TSCGETNODEDATAELECMSG_FIELD.cpp_type = 10

pb.TSCGETNODEDATA.name = "TSCGetNodeData"
pb.TSCGETNODEDATA.full_name = ".com.nkm.common.proto.client.TSCGetNodeData"
pb.TSCGETNODEDATA.nested_types = {}
pb.TSCGETNODEDATA.enum_types = {}
pb.TSCGETNODEDATA.fields = {pb.TSCGETNODEDATAPLANET_FIELD, pb.TSCGETNODEDATAFLEET_FIELD, pb.TSCGETNODEDATABUILDING_FIELD, pb.TSCGETNODEDATATOTALCAP_FIELD, pb.TSCGETNODEDATARESTOFCAP_FIELD, pb.TSCGETNODEDATAELECMSG_FIELD}
pb.TSCGETNODEDATA.is_extendable = false
pb.TSCGETNODEDATA.extensions = {}
pb.ELECMSGTOTALELECT_FIELD.name = "totalElect"
pb.ELECMSGTOTALELECT_FIELD.full_name = ".com.nkm.common.proto.client.ElecMsg.totalElect"
pb.ELECMSGTOTALELECT_FIELD.number = 1
pb.ELECMSGTOTALELECT_FIELD.index = 0
pb.ELECMSGTOTALELECT_FIELD.label = 1
pb.ELECMSGTOTALELECT_FIELD.has_default_value = false
pb.ELECMSGTOTALELECT_FIELD.default_value = 0
pb.ELECMSGTOTALELECT_FIELD.type = 5
pb.ELECMSGTOTALELECT_FIELD.cpp_type = 1

pb.ELECMSGRESTOFELECT_FIELD.name = "restOfElect"
pb.ELECMSGRESTOFELECT_FIELD.full_name = ".com.nkm.common.proto.client.ElecMsg.restOfElect"
pb.ELECMSGRESTOFELECT_FIELD.number = 2
pb.ELECMSGRESTOFELECT_FIELD.index = 1
pb.ELECMSGRESTOFELECT_FIELD.label = 1
pb.ELECMSGRESTOFELECT_FIELD.has_default_value = false
pb.ELECMSGRESTOFELECT_FIELD.default_value = 0
pb.ELECMSGRESTOFELECT_FIELD.type = 5
pb.ELECMSGRESTOFELECT_FIELD.cpp_type = 1

pb.ELECMSGELECRECOVERCOUNT_FIELD.name = "elecRecoverCount"
pb.ELECMSGELECRECOVERCOUNT_FIELD.full_name = ".com.nkm.common.proto.client.ElecMsg.elecRecoverCount"
pb.ELECMSGELECRECOVERCOUNT_FIELD.number = 3
pb.ELECMSGELECRECOVERCOUNT_FIELD.index = 2
pb.ELECMSGELECRECOVERCOUNT_FIELD.label = 1
pb.ELECMSGELECRECOVERCOUNT_FIELD.has_default_value = false
pb.ELECMSGELECRECOVERCOUNT_FIELD.default_value = 0
pb.ELECMSGELECRECOVERCOUNT_FIELD.type = 5
pb.ELECMSGELECRECOVERCOUNT_FIELD.cpp_type = 1

pb.ELECMSGELECTRICITYSTARTTIME_FIELD.name = "electricityStartTime"
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.full_name = ".com.nkm.common.proto.client.ElecMsg.electricityStartTime"
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.number = 4
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.index = 3
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.label = 1
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.has_default_value = false
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.default_value = 0
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.type = 3
pb.ELECMSGELECTRICITYSTARTTIME_FIELD.cpp_type = 2

pb.ELECMSG.name = "ElecMsg"
pb.ELECMSG.full_name = ".com.nkm.common.proto.client.ElecMsg"
pb.ELECMSG.nested_types = {}
pb.ELECMSG.enum_types = {}
pb.ELECMSG.fields = {pb.ELECMSGTOTALELECT_FIELD, pb.ELECMSGRESTOFELECT_FIELD, pb.ELECMSGELECRECOVERCOUNT_FIELD, pb.ELECMSGELECTRICITYSTARTTIME_FIELD}
pb.ELECMSG.is_extendable = false
pb.ELECMSG.extensions = {}
pb.TCSGETFLEETINNODENODEID_FIELD.name = "nodeId"
pb.TCSGETFLEETINNODENODEID_FIELD.full_name = ".com.nkm.common.proto.client.TCSGetFleetInNode.nodeId"
pb.TCSGETFLEETINNODENODEID_FIELD.number = 1
pb.TCSGETFLEETINNODENODEID_FIELD.index = 0
pb.TCSGETFLEETINNODENODEID_FIELD.label = 1
pb.TCSGETFLEETINNODENODEID_FIELD.has_default_value = false
pb.TCSGETFLEETINNODENODEID_FIELD.default_value = 0
pb.TCSGETFLEETINNODENODEID_FIELD.type = 3
pb.TCSGETFLEETINNODENODEID_FIELD.cpp_type = 2

pb.TCSGETFLEETINNODE.name = "TCSGetFleetInNode"
pb.TCSGETFLEETINNODE.full_name = ".com.nkm.common.proto.client.TCSGetFleetInNode"
pb.TCSGETFLEETINNODE.nested_types = {}
pb.TCSGETFLEETINNODE.enum_types = {}
pb.TCSGETFLEETINNODE.fields = {pb.TCSGETFLEETINNODENODEID_FIELD}
pb.TCSGETFLEETINNODE.is_extendable = false
pb.TCSGETFLEETINNODE.extensions = {}
pb.TSCGETFLEETINNODEFLEET_FIELD.name = "fleet"
pb.TSCGETFLEETINNODEFLEET_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetFleetInNode.fleet"
pb.TSCGETFLEETINNODEFLEET_FIELD.number = 1
pb.TSCGETFLEETINNODEFLEET_FIELD.index = 0
pb.TSCGETFLEETINNODEFLEET_FIELD.label = 3
pb.TSCGETFLEETINNODEFLEET_FIELD.has_default_value = false
pb.TSCGETFLEETINNODEFLEET_FIELD.default_value = {}
pb.TSCGETFLEETINNODEFLEET_FIELD.message_type = pb.NODEFLEET
pb.TSCGETFLEETINNODEFLEET_FIELD.type = 11
pb.TSCGETFLEETINNODEFLEET_FIELD.cpp_type = 10

pb.TSCGETFLEETINNODEOWNER_FIELD.name = "owner"
pb.TSCGETFLEETINNODEOWNER_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetFleetInNode.owner"
pb.TSCGETFLEETINNODEOWNER_FIELD.number = 2
pb.TSCGETFLEETINNODEOWNER_FIELD.index = 1
pb.TSCGETFLEETINNODEOWNER_FIELD.label = 1
pb.TSCGETFLEETINNODEOWNER_FIELD.has_default_value = false
pb.TSCGETFLEETINNODEOWNER_FIELD.default_value = 0
pb.TSCGETFLEETINNODEOWNER_FIELD.type = 5
pb.TSCGETFLEETINNODEOWNER_FIELD.cpp_type = 1

pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.name = "fleetCollect"
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetFleetInNode.fleetCollect"
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.number = 3
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.index = 2
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.label = 1
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.has_default_value = false
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.default_value = 0
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.type = 5
pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD.cpp_type = 1

pb.TSCGETFLEETINNODE.name = "TSCGetFleetInNode"
pb.TSCGETFLEETINNODE.full_name = ".com.nkm.common.proto.client.TSCGetFleetInNode"
pb.TSCGETFLEETINNODE.nested_types = {}
pb.TSCGETFLEETINNODE.enum_types = {}
pb.TSCGETFLEETINNODE.fields = {pb.TSCGETFLEETINNODEFLEET_FIELD, pb.TSCGETFLEETINNODEOWNER_FIELD, pb.TSCGETFLEETINNODEFLEETCOLLECT_FIELD}
pb.TSCGETFLEETINNODE.is_extendable = false
pb.TSCGETFLEETINNODE.extensions = {}
pb.TCSFLEETCOLLECTNODEID_FIELD.name = "nodeId"
pb.TCSFLEETCOLLECTNODEID_FIELD.full_name = ".com.nkm.common.proto.client.TCSFleetCollect.nodeId"
pb.TCSFLEETCOLLECTNODEID_FIELD.number = 1
pb.TCSFLEETCOLLECTNODEID_FIELD.index = 0
pb.TCSFLEETCOLLECTNODEID_FIELD.label = 1
pb.TCSFLEETCOLLECTNODEID_FIELD.has_default_value = false
pb.TCSFLEETCOLLECTNODEID_FIELD.default_value = 0
pb.TCSFLEETCOLLECTNODEID_FIELD.type = 3
pb.TCSFLEETCOLLECTNODEID_FIELD.cpp_type = 2

pb.TCSFLEETCOLLECTFLEETID_FIELD.name = "fleetId"
pb.TCSFLEETCOLLECTFLEETID_FIELD.full_name = ".com.nkm.common.proto.client.TCSFleetCollect.fleetId"
pb.TCSFLEETCOLLECTFLEETID_FIELD.number = 2
pb.TCSFLEETCOLLECTFLEETID_FIELD.index = 1
pb.TCSFLEETCOLLECTFLEETID_FIELD.label = 1
pb.TCSFLEETCOLLECTFLEETID_FIELD.has_default_value = false
pb.TCSFLEETCOLLECTFLEETID_FIELD.default_value = 0
pb.TCSFLEETCOLLECTFLEETID_FIELD.type = 3
pb.TCSFLEETCOLLECTFLEETID_FIELD.cpp_type = 2

pb.TCSFLEETCOLLECT.name = "TCSFleetCollect"
pb.TCSFLEETCOLLECT.full_name = ".com.nkm.common.proto.client.TCSFleetCollect"
pb.TCSFLEETCOLLECT.nested_types = {}
pb.TCSFLEETCOLLECT.enum_types = {}
pb.TCSFLEETCOLLECT.fields = {pb.TCSFLEETCOLLECTNODEID_FIELD, pb.TCSFLEETCOLLECTFLEETID_FIELD}
pb.TCSFLEETCOLLECT.is_extendable = false
pb.TCSFLEETCOLLECT.extensions = {}
pb.TSCFLEETCOLLECTNODEID_FIELD.name = "nodeId"
pb.TSCFLEETCOLLECTNODEID_FIELD.full_name = ".com.nkm.common.proto.client.TSCFleetCollect.nodeId"
pb.TSCFLEETCOLLECTNODEID_FIELD.number = 1
pb.TSCFLEETCOLLECTNODEID_FIELD.index = 0
pb.TSCFLEETCOLLECTNODEID_FIELD.label = 1
pb.TSCFLEETCOLLECTNODEID_FIELD.has_default_value = false
pb.TSCFLEETCOLLECTNODEID_FIELD.default_value = 0
pb.TSCFLEETCOLLECTNODEID_FIELD.type = 3
pb.TSCFLEETCOLLECTNODEID_FIELD.cpp_type = 2

pb.TSCFLEETCOLLECTFLEETID_FIELD.name = "fleetId"
pb.TSCFLEETCOLLECTFLEETID_FIELD.full_name = ".com.nkm.common.proto.client.TSCFleetCollect.fleetId"
pb.TSCFLEETCOLLECTFLEETID_FIELD.number = 2
pb.TSCFLEETCOLLECTFLEETID_FIELD.index = 1
pb.TSCFLEETCOLLECTFLEETID_FIELD.label = 1
pb.TSCFLEETCOLLECTFLEETID_FIELD.has_default_value = false
pb.TSCFLEETCOLLECTFLEETID_FIELD.default_value = 0
pb.TSCFLEETCOLLECTFLEETID_FIELD.type = 3
pb.TSCFLEETCOLLECTFLEETID_FIELD.cpp_type = 2

pb.TSCFLEETCOLLECTENDTIME_FIELD.name = "endTime"
pb.TSCFLEETCOLLECTENDTIME_FIELD.full_name = ".com.nkm.common.proto.client.TSCFleetCollect.endTime"
pb.TSCFLEETCOLLECTENDTIME_FIELD.number = 3
pb.TSCFLEETCOLLECTENDTIME_FIELD.index = 2
pb.TSCFLEETCOLLECTENDTIME_FIELD.label = 1
pb.TSCFLEETCOLLECTENDTIME_FIELD.has_default_value = false
pb.TSCFLEETCOLLECTENDTIME_FIELD.default_value = 0
pb.TSCFLEETCOLLECTENDTIME_FIELD.type = 3
pb.TSCFLEETCOLLECTENDTIME_FIELD.cpp_type = 2

pb.TSCFLEETCOLLECT.name = "TSCFleetCollect"
pb.TSCFLEETCOLLECT.full_name = ".com.nkm.common.proto.client.TSCFleetCollect"
pb.TSCFLEETCOLLECT.nested_types = {}
pb.TSCFLEETCOLLECT.enum_types = {}
pb.TSCFLEETCOLLECT.fields = {pb.TSCFLEETCOLLECTNODEID_FIELD, pb.TSCFLEETCOLLECTFLEETID_FIELD, pb.TSCFLEETCOLLECTENDTIME_FIELD}
pb.TSCFLEETCOLLECT.is_extendable = false
pb.TSCFLEETCOLLECT.extensions = {}
pb.TCSENDFLEETCOLLECTNODEID_FIELD.name = "nodeId"
pb.TCSENDFLEETCOLLECTNODEID_FIELD.full_name = ".com.nkm.common.proto.client.TCSEndFleetCollect.nodeId"
pb.TCSENDFLEETCOLLECTNODEID_FIELD.number = 1
pb.TCSENDFLEETCOLLECTNODEID_FIELD.index = 0
pb.TCSENDFLEETCOLLECTNODEID_FIELD.label = 1
pb.TCSENDFLEETCOLLECTNODEID_FIELD.has_default_value = false
pb.TCSENDFLEETCOLLECTNODEID_FIELD.default_value = 0
pb.TCSENDFLEETCOLLECTNODEID_FIELD.type = 3
pb.TCSENDFLEETCOLLECTNODEID_FIELD.cpp_type = 2

pb.TCSENDFLEETCOLLECTFLEETID_FIELD.name = "fleetId"
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.full_name = ".com.nkm.common.proto.client.TCSEndFleetCollect.fleetId"
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.number = 2
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.index = 1
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.label = 1
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.has_default_value = false
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.default_value = 0
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.type = 3
pb.TCSENDFLEETCOLLECTFLEETID_FIELD.cpp_type = 2

pb.TCSENDFLEETCOLLECT.name = "TCSEndFleetCollect"
pb.TCSENDFLEETCOLLECT.full_name = ".com.nkm.common.proto.client.TCSEndFleetCollect"
pb.TCSENDFLEETCOLLECT.nested_types = {}
pb.TCSENDFLEETCOLLECT.enum_types = {}
pb.TCSENDFLEETCOLLECT.fields = {pb.TCSENDFLEETCOLLECTNODEID_FIELD, pb.TCSENDFLEETCOLLECTFLEETID_FIELD}
pb.TCSENDFLEETCOLLECT.is_extendable = false
pb.TCSENDFLEETCOLLECT.extensions = {}
pb.TSCENDFLEETCOLLECTNODEID_FIELD.name = "nodeId"
pb.TSCENDFLEETCOLLECTNODEID_FIELD.full_name = ".com.nkm.common.proto.client.TSCEndFleetCollect.nodeId"
pb.TSCENDFLEETCOLLECTNODEID_FIELD.number = 1
pb.TSCENDFLEETCOLLECTNODEID_FIELD.index = 0
pb.TSCENDFLEETCOLLECTNODEID_FIELD.label = 1
pb.TSCENDFLEETCOLLECTNODEID_FIELD.has_default_value = false
pb.TSCENDFLEETCOLLECTNODEID_FIELD.default_value = 0
pb.TSCENDFLEETCOLLECTNODEID_FIELD.type = 3
pb.TSCENDFLEETCOLLECTNODEID_FIELD.cpp_type = 2

pb.TSCENDFLEETCOLLECTFLEETID_FIELD.name = "fleetId"
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.full_name = ".com.nkm.common.proto.client.TSCEndFleetCollect.fleetId"
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.number = 2
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.index = 1
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.label = 1
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.has_default_value = false
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.default_value = 0
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.type = 3
pb.TSCENDFLEETCOLLECTFLEETID_FIELD.cpp_type = 2

pb.TSCENDFLEETCOLLECTITEM_FIELD.name = "item"
pb.TSCENDFLEETCOLLECTITEM_FIELD.full_name = ".com.nkm.common.proto.client.TSCEndFleetCollect.item"
pb.TSCENDFLEETCOLLECTITEM_FIELD.number = 3
pb.TSCENDFLEETCOLLECTITEM_FIELD.index = 2
pb.TSCENDFLEETCOLLECTITEM_FIELD.label = 3
pb.TSCENDFLEETCOLLECTITEM_FIELD.has_default_value = false
pb.TSCENDFLEETCOLLECTITEM_FIELD.default_value = {}
pb.TSCENDFLEETCOLLECTITEM_FIELD.message_type = db_pb.Item
pb.TSCENDFLEETCOLLECTITEM_FIELD.type = 11
pb.TSCENDFLEETCOLLECTITEM_FIELD.cpp_type = 10

pb.TSCENDFLEETCOLLECT.name = "TSCEndFleetCollect"
pb.TSCENDFLEETCOLLECT.full_name = ".com.nkm.common.proto.client.TSCEndFleetCollect"
pb.TSCENDFLEETCOLLECT.nested_types = {}
pb.TSCENDFLEETCOLLECT.enum_types = {}
pb.TSCENDFLEETCOLLECT.fields = {pb.TSCENDFLEETCOLLECTNODEID_FIELD, pb.TSCENDFLEETCOLLECTFLEETID_FIELD, pb.TSCENDFLEETCOLLECTITEM_FIELD}
pb.TSCENDFLEETCOLLECT.is_extendable = false
pb.TSCENDFLEETCOLLECT.extensions = {}
pb.PLANETID_FIELD.name = "id"
pb.PLANETID_FIELD.full_name = ".com.nkm.common.proto.client.Planet.id"
pb.PLANETID_FIELD.number = 1
pb.PLANETID_FIELD.index = 0
pb.PLANETID_FIELD.label = 1
pb.PLANETID_FIELD.has_default_value = false
pb.PLANETID_FIELD.default_value = 0
pb.PLANETID_FIELD.type = 5
pb.PLANETID_FIELD.cpp_type = 1

pb.PLANETDEPTH_FIELD.name = "depth"
pb.PLANETDEPTH_FIELD.full_name = ".com.nkm.common.proto.client.Planet.depth"
pb.PLANETDEPTH_FIELD.number = 2
pb.PLANETDEPTH_FIELD.index = 1
pb.PLANETDEPTH_FIELD.label = 1
pb.PLANETDEPTH_FIELD.has_default_value = false
pb.PLANETDEPTH_FIELD.default_value = 0
pb.PLANETDEPTH_FIELD.type = 5
pb.PLANETDEPTH_FIELD.cpp_type = 1

pb.PLANET.name = "Planet"
pb.PLANET.full_name = ".com.nkm.common.proto.client.Planet"
pb.PLANET.nested_types = {}
pb.PLANET.enum_types = {}
pb.PLANET.fields = {pb.PLANETID_FIELD, pb.PLANETDEPTH_FIELD}
pb.PLANET.is_extendable = false
pb.PLANET.extensions = {}
pb.PLANETSPLANET_FIELD.name = "planet"
pb.PLANETSPLANET_FIELD.full_name = ".com.nkm.common.proto.client.Planets.planet"
pb.PLANETSPLANET_FIELD.number = 1
pb.PLANETSPLANET_FIELD.index = 0
pb.PLANETSPLANET_FIELD.label = 3
pb.PLANETSPLANET_FIELD.has_default_value = false
pb.PLANETSPLANET_FIELD.default_value = {}
pb.PLANETSPLANET_FIELD.message_type = pb.PLANET
pb.PLANETSPLANET_FIELD.type = 11
pb.PLANETSPLANET_FIELD.cpp_type = 10

pb.PLANETS.name = "Planets"
pb.PLANETS.full_name = ".com.nkm.common.proto.client.Planets"
pb.PLANETS.nested_types = {}
pb.PLANETS.enum_types = {}
pb.PLANETS.fields = {pb.PLANETSPLANET_FIELD}
pb.PLANETS.is_extendable = false
pb.PLANETS.extensions = {}
pb.NODEFLEETFLEETID_FIELD.name = "fleetId"
pb.NODEFLEETFLEETID_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.fleetId"
pb.NODEFLEETFLEETID_FIELD.number = 1
pb.NODEFLEETFLEETID_FIELD.index = 0
pb.NODEFLEETFLEETID_FIELD.label = 1
pb.NODEFLEETFLEETID_FIELD.has_default_value = false
pb.NODEFLEETFLEETID_FIELD.default_value = 0
pb.NODEFLEETFLEETID_FIELD.type = 3
pb.NODEFLEETFLEETID_FIELD.cpp_type = 2

pb.NODEFLEETUID_FIELD.name = "uid"
pb.NODEFLEETUID_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.uid"
pb.NODEFLEETUID_FIELD.number = 2
pb.NODEFLEETUID_FIELD.index = 1
pb.NODEFLEETUID_FIELD.label = 1
pb.NODEFLEETUID_FIELD.has_default_value = false
pb.NODEFLEETUID_FIELD.default_value = 0
pb.NODEFLEETUID_FIELD.type = 3
pb.NODEFLEETUID_FIELD.cpp_type = 2

pb.NODEFLEETNODEID_FIELD.name = "nodeId"
pb.NODEFLEETNODEID_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.nodeId"
pb.NODEFLEETNODEID_FIELD.number = 3
pb.NODEFLEETNODEID_FIELD.index = 2
pb.NODEFLEETNODEID_FIELD.label = 1
pb.NODEFLEETNODEID_FIELD.has_default_value = false
pb.NODEFLEETNODEID_FIELD.default_value = 0
pb.NODEFLEETNODEID_FIELD.type = 3
pb.NODEFLEETNODEID_FIELD.cpp_type = 2

pb.NODEFLEETUSERNAME_FIELD.name = "userName"
pb.NODEFLEETUSERNAME_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.userName"
pb.NODEFLEETUSERNAME_FIELD.number = 4
pb.NODEFLEETUSERNAME_FIELD.index = 3
pb.NODEFLEETUSERNAME_FIELD.label = 1
pb.NODEFLEETUSERNAME_FIELD.has_default_value = false
pb.NODEFLEETUSERNAME_FIELD.default_value = ""
pb.NODEFLEETUSERNAME_FIELD.type = 9
pb.NODEFLEETUSERNAME_FIELD.cpp_type = 9

pb.NODEFLEETCOLLECTSPEED_FIELD.name = "collectSpeed"
pb.NODEFLEETCOLLECTSPEED_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.collectSpeed"
pb.NODEFLEETCOLLECTSPEED_FIELD.number = 5
pb.NODEFLEETCOLLECTSPEED_FIELD.index = 4
pb.NODEFLEETCOLLECTSPEED_FIELD.label = 1
pb.NODEFLEETCOLLECTSPEED_FIELD.has_default_value = false
pb.NODEFLEETCOLLECTSPEED_FIELD.default_value = 0
pb.NODEFLEETCOLLECTSPEED_FIELD.type = 5
pb.NODEFLEETCOLLECTSPEED_FIELD.cpp_type = 1

pb.NODEFLEETRESOURCECAPACITY_FIELD.name = "resourceCapacity"
pb.NODEFLEETRESOURCECAPACITY_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.resourceCapacity"
pb.NODEFLEETRESOURCECAPACITY_FIELD.number = 6
pb.NODEFLEETRESOURCECAPACITY_FIELD.index = 5
pb.NODEFLEETRESOURCECAPACITY_FIELD.label = 1
pb.NODEFLEETRESOURCECAPACITY_FIELD.has_default_value = false
pb.NODEFLEETRESOURCECAPACITY_FIELD.default_value = 0
pb.NODEFLEETRESOURCECAPACITY_FIELD.type = 5
pb.NODEFLEETRESOURCECAPACITY_FIELD.cpp_type = 1

pb.NODEFLEETFLEETCAPACITY_FIELD.name = "fleetCapacity"
pb.NODEFLEETFLEETCAPACITY_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.fleetCapacity"
pb.NODEFLEETFLEETCAPACITY_FIELD.number = 7
pb.NODEFLEETFLEETCAPACITY_FIELD.index = 6
pb.NODEFLEETFLEETCAPACITY_FIELD.label = 1
pb.NODEFLEETFLEETCAPACITY_FIELD.has_default_value = false
pb.NODEFLEETFLEETCAPACITY_FIELD.default_value = 0
pb.NODEFLEETFLEETCAPACITY_FIELD.type = 5
pb.NODEFLEETFLEETCAPACITY_FIELD.cpp_type = 1

pb.NODEFLEETSTATUS_FIELD.name = "status"
pb.NODEFLEETSTATUS_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.status"
pb.NODEFLEETSTATUS_FIELD.number = 8
pb.NODEFLEETSTATUS_FIELD.index = 7
pb.NODEFLEETSTATUS_FIELD.label = 1
pb.NODEFLEETSTATUS_FIELD.has_default_value = false
pb.NODEFLEETSTATUS_FIELD.default_value = 0
pb.NODEFLEETSTATUS_FIELD.type = 5
pb.NODEFLEETSTATUS_FIELD.cpp_type = 1

pb.NODEFLEETTIME_FIELD.name = "time"
pb.NODEFLEETTIME_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.time"
pb.NODEFLEETTIME_FIELD.number = 9
pb.NODEFLEETTIME_FIELD.index = 8
pb.NODEFLEETTIME_FIELD.label = 1
pb.NODEFLEETTIME_FIELD.has_default_value = false
pb.NODEFLEETTIME_FIELD.default_value = 0
pb.NODEFLEETTIME_FIELD.type = 5
pb.NODEFLEETTIME_FIELD.cpp_type = 1

pb.NODEFLEETENDTIME_FIELD.name = "endTime"
pb.NODEFLEETENDTIME_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.endTime"
pb.NODEFLEETENDTIME_FIELD.number = 10
pb.NODEFLEETENDTIME_FIELD.index = 9
pb.NODEFLEETENDTIME_FIELD.label = 1
pb.NODEFLEETENDTIME_FIELD.has_default_value = false
pb.NODEFLEETENDTIME_FIELD.default_value = 0
pb.NODEFLEETENDTIME_FIELD.type = 3
pb.NODEFLEETENDTIME_FIELD.cpp_type = 2

pb.NODEFLEETUSERSHIPS_FIELD.name = "userShips"
pb.NODEFLEETUSERSHIPS_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.userShips"
pb.NODEFLEETUSERSHIPS_FIELD.number = 11
pb.NODEFLEETUSERSHIPS_FIELD.index = 10
pb.NODEFLEETUSERSHIPS_FIELD.label = 3
pb.NODEFLEETUSERSHIPS_FIELD.has_default_value = false
pb.NODEFLEETUSERSHIPS_FIELD.default_value = {}
pb.NODEFLEETUSERSHIPS_FIELD.message_type = db_pb.UserShip
pb.NODEFLEETUSERSHIPS_FIELD.type = 11
pb.NODEFLEETUSERSHIPS_FIELD.cpp_type = 10

pb.NODEFLEETFLEETNAME_FIELD.name = "fleetName"
pb.NODEFLEETFLEETNAME_FIELD.full_name = ".com.nkm.common.proto.client.NodeFleet.fleetName"
pb.NODEFLEETFLEETNAME_FIELD.number = 12
pb.NODEFLEETFLEETNAME_FIELD.index = 11
pb.NODEFLEETFLEETNAME_FIELD.label = 1
pb.NODEFLEETFLEETNAME_FIELD.has_default_value = false
pb.NODEFLEETFLEETNAME_FIELD.default_value = ""
pb.NODEFLEETFLEETNAME_FIELD.type = 9
pb.NODEFLEETFLEETNAME_FIELD.cpp_type = 9

pb.NODEFLEET.name = "NodeFleet"
pb.NODEFLEET.full_name = ".com.nkm.common.proto.client.NodeFleet"
pb.NODEFLEET.nested_types = {}
pb.NODEFLEET.enum_types = {}
pb.NODEFLEET.fields = {pb.NODEFLEETFLEETID_FIELD, pb.NODEFLEETUID_FIELD, pb.NODEFLEETNODEID_FIELD, pb.NODEFLEETUSERNAME_FIELD, pb.NODEFLEETCOLLECTSPEED_FIELD, pb.NODEFLEETRESOURCECAPACITY_FIELD, pb.NODEFLEETFLEETCAPACITY_FIELD, pb.NODEFLEETSTATUS_FIELD, pb.NODEFLEETTIME_FIELD, pb.NODEFLEETENDTIME_FIELD, pb.NODEFLEETUSERSHIPS_FIELD, pb.NODEFLEETFLEETNAME_FIELD}
pb.NODEFLEET.is_extendable = false
pb.NODEFLEET.extensions = {}
pb.NODEBUILDINGID_FIELD.name = "id"
pb.NODEBUILDINGID_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.id"
pb.NODEBUILDINGID_FIELD.number = 1
pb.NODEBUILDINGID_FIELD.index = 0
pb.NODEBUILDINGID_FIELD.label = 2
pb.NODEBUILDINGID_FIELD.has_default_value = false
pb.NODEBUILDINGID_FIELD.default_value = 0
pb.NODEBUILDINGID_FIELD.type = 3
pb.NODEBUILDINGID_FIELD.cpp_type = 2

pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.name = "buildingConfigId"
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.buildingConfigId"
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.number = 2
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.index = 1
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.label = 2
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.has_default_value = false
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.default_value = 0
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.type = 5
pb.NODEBUILDINGBUILDINGCONFIGID_FIELD.cpp_type = 1

pb.NODEBUILDINGPOS_FIELD.name = "pos"
pb.NODEBUILDINGPOS_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.pos"
pb.NODEBUILDINGPOS_FIELD.number = 3
pb.NODEBUILDINGPOS_FIELD.index = 2
pb.NODEBUILDINGPOS_FIELD.label = 1
pb.NODEBUILDINGPOS_FIELD.has_default_value = false
pb.NODEBUILDINGPOS_FIELD.default_value = 0
pb.NODEBUILDINGPOS_FIELD.type = 5
pb.NODEBUILDINGPOS_FIELD.cpp_type = 1

pb.NODEBUILDINGSTATUS_FIELD.name = "status"
pb.NODEBUILDINGSTATUS_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.status"
pb.NODEBUILDINGSTATUS_FIELD.number = 4
pb.NODEBUILDINGSTATUS_FIELD.index = 3
pb.NODEBUILDINGSTATUS_FIELD.label = 2
pb.NODEBUILDINGSTATUS_FIELD.has_default_value = false
pb.NODEBUILDINGSTATUS_FIELD.default_value = 0
pb.NODEBUILDINGSTATUS_FIELD.type = 5
pb.NODEBUILDINGSTATUS_FIELD.cpp_type = 1

pb.NODEBUILDINGSTARTTIME_FIELD.name = "startTime"
pb.NODEBUILDINGSTARTTIME_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.startTime"
pb.NODEBUILDINGSTARTTIME_FIELD.number = 5
pb.NODEBUILDINGSTARTTIME_FIELD.index = 4
pb.NODEBUILDINGSTARTTIME_FIELD.label = 1
pb.NODEBUILDINGSTARTTIME_FIELD.has_default_value = false
pb.NODEBUILDINGSTARTTIME_FIELD.default_value = 0
pb.NODEBUILDINGSTARTTIME_FIELD.type = 3
pb.NODEBUILDINGSTARTTIME_FIELD.cpp_type = 2

pb.NODEBUILDINGENDTIME_FIELD.name = "endTime"
pb.NODEBUILDINGENDTIME_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.endTime"
pb.NODEBUILDINGENDTIME_FIELD.number = 6
pb.NODEBUILDINGENDTIME_FIELD.index = 5
pb.NODEBUILDINGENDTIME_FIELD.label = 1
pb.NODEBUILDINGENDTIME_FIELD.has_default_value = false
pb.NODEBUILDINGENDTIME_FIELD.default_value = 0
pb.NODEBUILDINGENDTIME_FIELD.type = 3
pb.NODEBUILDINGENDTIME_FIELD.cpp_type = 2

pb.NODEBUILDINGGETITEMTIME_FIELD.name = "getItemTime"
pb.NODEBUILDINGGETITEMTIME_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.getItemTime"
pb.NODEBUILDINGGETITEMTIME_FIELD.number = 7
pb.NODEBUILDINGGETITEMTIME_FIELD.index = 6
pb.NODEBUILDINGGETITEMTIME_FIELD.label = 1
pb.NODEBUILDINGGETITEMTIME_FIELD.has_default_value = false
pb.NODEBUILDINGGETITEMTIME_FIELD.default_value = 0
pb.NODEBUILDINGGETITEMTIME_FIELD.type = 3
pb.NODEBUILDINGGETITEMTIME_FIELD.cpp_type = 2

pb.NODEBUILDINGFLEETS_FIELD.name = "fleets"
pb.NODEBUILDINGFLEETS_FIELD.full_name = ".com.nkm.common.proto.client.NodeBuilding.fleets"
pb.NODEBUILDINGFLEETS_FIELD.number = 8
pb.NODEBUILDINGFLEETS_FIELD.index = 7
pb.NODEBUILDINGFLEETS_FIELD.label = 3
pb.NODEBUILDINGFLEETS_FIELD.has_default_value = false
pb.NODEBUILDINGFLEETS_FIELD.default_value = {}
pb.NODEBUILDINGFLEETS_FIELD.message_type = pb.NODEFLEET
pb.NODEBUILDINGFLEETS_FIELD.type = 11
pb.NODEBUILDINGFLEETS_FIELD.cpp_type = 10

pb.NODEBUILDING.name = "NodeBuilding"
pb.NODEBUILDING.full_name = ".com.nkm.common.proto.client.NodeBuilding"
pb.NODEBUILDING.nested_types = {}
pb.NODEBUILDING.enum_types = {}
pb.NODEBUILDING.fields = {pb.NODEBUILDINGID_FIELD, pb.NODEBUILDINGBUILDINGCONFIGID_FIELD, pb.NODEBUILDINGPOS_FIELD, pb.NODEBUILDINGSTATUS_FIELD, pb.NODEBUILDINGSTARTTIME_FIELD, pb.NODEBUILDINGENDTIME_FIELD, pb.NODEBUILDINGGETITEMTIME_FIELD, pb.NODEBUILDINGFLEETS_FIELD}
pb.NODEBUILDING.is_extendable = false
pb.NODEBUILDING.extensions = {}

ElecMsg = protobuf.Message(pb.ELECMSG)
NodeBuilding = protobuf.Message(pb.NODEBUILDING)
NodeFleet = protobuf.Message(pb.NODEFLEET)
Planet = protobuf.Message(pb.PLANET)
Planets = protobuf.Message(pb.PLANETS)
TCSEndFleetCollect = protobuf.Message(pb.TCSENDFLEETCOLLECT)
TCSFleetCollect = protobuf.Message(pb.TCSFLEETCOLLECT)
TCSGetFleetInNode = protobuf.Message(pb.TCSGETFLEETINNODE)
TCSGetNodeData = protobuf.Message(pb.TCSGETNODEDATA)
TSCEndFleetCollect = protobuf.Message(pb.TSCENDFLEETCOLLECT)
TSCFleetCollect = protobuf.Message(pb.TSCFLEETCOLLECT)
TSCGetFleetInNode = protobuf.Message(pb.TSCGETFLEETINNODE)
TSCGetNodeData = protobuf.Message(pb.TSCGETNODEDATA)

