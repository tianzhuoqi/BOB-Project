-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
local db_pb = require("db_pb")
local common_pb = require("common_pb")
module('buildingTech_pb')


local pb = {}
pb.TCSGETTECH = protobuf.Descriptor();
pb.TSCGETTECH = protobuf.Descriptor();
pb.TSCGETTECHTECHNOLOGY_FIELD = protobuf.FieldDescriptor();
pb.TCSTECHLEVELUP = protobuf.Descriptor();
pb.TCSTECHLEVELUPTECHID_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHLEVELUP = protobuf.Descriptor();
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHLEVELUPTECHPOINT_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHLEVELUPSTARDUST_FIELD = protobuf.FieldDescriptor();
pb.TCSTECHSPEEDUP = protobuf.Descriptor();
pb.TCSTECHSPEEDUPTECHID_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHSPEEDUP = protobuf.Descriptor();
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHSPEEDUPITEMS_FIELD = protobuf.FieldDescriptor();
pb.TCSTECHFINISHED = protobuf.Descriptor();
pb.TCSTECHFINISHEDTECHID_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHFINISHED = protobuf.Descriptor();
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD = protobuf.FieldDescriptor();
pb.TCSTECHCANCEL = protobuf.Descriptor();
pb.TCSTECHCANCELTECHID_FIELD = protobuf.FieldDescriptor();
pb.TSCTECHCANCEL = protobuf.Descriptor();
pb.TSCTECHCANCELTECHNOLOGY_FIELD = protobuf.FieldDescriptor();

pb.TCSGETTECH.name = "TCSGetTech"
pb.TCSGETTECH.full_name = ".com.nkm.common.proto.client.TCSGetTech"
pb.TCSGETTECH.nested_types = {}
pb.TCSGETTECH.enum_types = {}
pb.TCSGETTECH.fields = {}
pb.TCSGETTECH.is_extendable = false
pb.TCSGETTECH.extensions = {}
pb.TSCGETTECHTECHNOLOGY_FIELD.name = "technology"
pb.TSCGETTECHTECHNOLOGY_FIELD.full_name = ".com.nkm.common.proto.client.TSCGetTech.technology"
pb.TSCGETTECHTECHNOLOGY_FIELD.number = 1
pb.TSCGETTECHTECHNOLOGY_FIELD.index = 0
pb.TSCGETTECHTECHNOLOGY_FIELD.label = 3
pb.TSCGETTECHTECHNOLOGY_FIELD.has_default_value = false
pb.TSCGETTECHTECHNOLOGY_FIELD.default_value = {}
pb.TSCGETTECHTECHNOLOGY_FIELD.message_type = db_pb.Technology
pb.TSCGETTECHTECHNOLOGY_FIELD.type = 11
pb.TSCGETTECHTECHNOLOGY_FIELD.cpp_type = 10

pb.TSCGETTECH.name = "TSCGetTech"
pb.TSCGETTECH.full_name = ".com.nkm.common.proto.client.TSCGetTech"
pb.TSCGETTECH.nested_types = {}
pb.TSCGETTECH.enum_types = {}
pb.TSCGETTECH.fields = {pb.TSCGETTECHTECHNOLOGY_FIELD}
pb.TSCGETTECH.is_extendable = false
pb.TSCGETTECH.extensions = {}
pb.TCSTECHLEVELUPTECHID_FIELD.name = "techId"
pb.TCSTECHLEVELUPTECHID_FIELD.full_name = ".com.nkm.common.proto.client.TCSTechLevelUp.techId"
pb.TCSTECHLEVELUPTECHID_FIELD.number = 1
pb.TCSTECHLEVELUPTECHID_FIELD.index = 0
pb.TCSTECHLEVELUPTECHID_FIELD.label = 1
pb.TCSTECHLEVELUPTECHID_FIELD.has_default_value = false
pb.TCSTECHLEVELUPTECHID_FIELD.default_value = 0
pb.TCSTECHLEVELUPTECHID_FIELD.type = 5
pb.TCSTECHLEVELUPTECHID_FIELD.cpp_type = 1

pb.TCSTECHLEVELUP.name = "TCSTechLevelUp"
pb.TCSTECHLEVELUP.full_name = ".com.nkm.common.proto.client.TCSTechLevelUp"
pb.TCSTECHLEVELUP.nested_types = {}
pb.TCSTECHLEVELUP.enum_types = {}
pb.TCSTECHLEVELUP.fields = {pb.TCSTECHLEVELUPTECHID_FIELD}
pb.TCSTECHLEVELUP.is_extendable = false
pb.TCSTECHLEVELUP.extensions = {}
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.name = "technology"
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechLevelUp.technology"
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.number = 1
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.index = 0
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.label = 1
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.has_default_value = false
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.default_value = nil
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.message_type = db_pb.Technology
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.type = 11
pb.TSCTECHLEVELUPTECHNOLOGY_FIELD.cpp_type = 10

pb.TSCTECHLEVELUPTECHPOINT_FIELD.name = "techPoint"
pb.TSCTECHLEVELUPTECHPOINT_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechLevelUp.techPoint"
pb.TSCTECHLEVELUPTECHPOINT_FIELD.number = 2
pb.TSCTECHLEVELUPTECHPOINT_FIELD.index = 1
pb.TSCTECHLEVELUPTECHPOINT_FIELD.label = 1
pb.TSCTECHLEVELUPTECHPOINT_FIELD.has_default_value = false
pb.TSCTECHLEVELUPTECHPOINT_FIELD.default_value = 0
pb.TSCTECHLEVELUPTECHPOINT_FIELD.type = 5
pb.TSCTECHLEVELUPTECHPOINT_FIELD.cpp_type = 1

pb.TSCTECHLEVELUPSTARDUST_FIELD.name = "starDust"
pb.TSCTECHLEVELUPSTARDUST_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechLevelUp.starDust"
pb.TSCTECHLEVELUPSTARDUST_FIELD.number = 3
pb.TSCTECHLEVELUPSTARDUST_FIELD.index = 2
pb.TSCTECHLEVELUPSTARDUST_FIELD.label = 1
pb.TSCTECHLEVELUPSTARDUST_FIELD.has_default_value = false
pb.TSCTECHLEVELUPSTARDUST_FIELD.default_value = 0
pb.TSCTECHLEVELUPSTARDUST_FIELD.type = 5
pb.TSCTECHLEVELUPSTARDUST_FIELD.cpp_type = 1

pb.TSCTECHLEVELUP.name = "TSCTechLevelUp"
pb.TSCTECHLEVELUP.full_name = ".com.nkm.common.proto.client.TSCTechLevelUp"
pb.TSCTECHLEVELUP.nested_types = {}
pb.TSCTECHLEVELUP.enum_types = {}
pb.TSCTECHLEVELUP.fields = {pb.TSCTECHLEVELUPTECHNOLOGY_FIELD, pb.TSCTECHLEVELUPTECHPOINT_FIELD, pb.TSCTECHLEVELUPSTARDUST_FIELD}
pb.TSCTECHLEVELUP.is_extendable = false
pb.TSCTECHLEVELUP.extensions = {}
pb.TCSTECHSPEEDUPTECHID_FIELD.name = "techId"
pb.TCSTECHSPEEDUPTECHID_FIELD.full_name = ".com.nkm.common.proto.client.TCSTechSpeedUp.techId"
pb.TCSTECHSPEEDUPTECHID_FIELD.number = 1
pb.TCSTECHSPEEDUPTECHID_FIELD.index = 0
pb.TCSTECHSPEEDUPTECHID_FIELD.label = 1
pb.TCSTECHSPEEDUPTECHID_FIELD.has_default_value = false
pb.TCSTECHSPEEDUPTECHID_FIELD.default_value = 0
pb.TCSTECHSPEEDUPTECHID_FIELD.type = 5
pb.TCSTECHSPEEDUPTECHID_FIELD.cpp_type = 1

pb.TCSTECHSPEEDUP.name = "TCSTechSpeedUp"
pb.TCSTECHSPEEDUP.full_name = ".com.nkm.common.proto.client.TCSTechSpeedUp"
pb.TCSTECHSPEEDUP.nested_types = {}
pb.TCSTECHSPEEDUP.enum_types = {}
pb.TCSTECHSPEEDUP.fields = {pb.TCSTECHSPEEDUPTECHID_FIELD}
pb.TCSTECHSPEEDUP.is_extendable = false
pb.TCSTECHSPEEDUP.extensions = {}
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.name = "technology"
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechSpeedUp.technology"
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.number = 1
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.index = 0
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.label = 1
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.has_default_value = false
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.default_value = nil
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.message_type = db_pb.Technology
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.type = 11
pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD.cpp_type = 10

pb.TSCTECHSPEEDUPITEMS_FIELD.name = "items"
pb.TSCTECHSPEEDUPITEMS_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechSpeedUp.items"
pb.TSCTECHSPEEDUPITEMS_FIELD.number = 2
pb.TSCTECHSPEEDUPITEMS_FIELD.index = 1
pb.TSCTECHSPEEDUPITEMS_FIELD.label = 3
pb.TSCTECHSPEEDUPITEMS_FIELD.has_default_value = false
pb.TSCTECHSPEEDUPITEMS_FIELD.default_value = {}
pb.TSCTECHSPEEDUPITEMS_FIELD.message_type = db_pb.Item
pb.TSCTECHSPEEDUPITEMS_FIELD.type = 11
pb.TSCTECHSPEEDUPITEMS_FIELD.cpp_type = 10

pb.TSCTECHSPEEDUP.name = "TSCTechSpeedUp"
pb.TSCTECHSPEEDUP.full_name = ".com.nkm.common.proto.client.TSCTechSpeedUp"
pb.TSCTECHSPEEDUP.nested_types = {}
pb.TSCTECHSPEEDUP.enum_types = {}
pb.TSCTECHSPEEDUP.fields = {pb.TSCTECHSPEEDUPTECHNOLOGY_FIELD, pb.TSCTECHSPEEDUPITEMS_FIELD}
pb.TSCTECHSPEEDUP.is_extendable = false
pb.TSCTECHSPEEDUP.extensions = {}
pb.TCSTECHFINISHEDTECHID_FIELD.name = "techId"
pb.TCSTECHFINISHEDTECHID_FIELD.full_name = ".com.nkm.common.proto.client.TCSTechFinished.techId"
pb.TCSTECHFINISHEDTECHID_FIELD.number = 1
pb.TCSTECHFINISHEDTECHID_FIELD.index = 0
pb.TCSTECHFINISHEDTECHID_FIELD.label = 1
pb.TCSTECHFINISHEDTECHID_FIELD.has_default_value = false
pb.TCSTECHFINISHEDTECHID_FIELD.default_value = 0
pb.TCSTECHFINISHEDTECHID_FIELD.type = 5
pb.TCSTECHFINISHEDTECHID_FIELD.cpp_type = 1

pb.TCSTECHFINISHED.name = "TCSTechFinished"
pb.TCSTECHFINISHED.full_name = ".com.nkm.common.proto.client.TCSTechFinished"
pb.TCSTECHFINISHED.nested_types = {}
pb.TCSTECHFINISHED.enum_types = {}
pb.TCSTECHFINISHED.fields = {pb.TCSTECHFINISHEDTECHID_FIELD}
pb.TCSTECHFINISHED.is_extendable = false
pb.TCSTECHFINISHED.extensions = {}
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.name = "technology"
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechFinished.technology"
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.number = 1
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.index = 0
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.label = 1
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.has_default_value = false
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.default_value = nil
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.message_type = db_pb.Technology
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.type = 11
pb.TSCTECHFINISHEDTECHNOLOGY_FIELD.cpp_type = 10

pb.TSCTECHFINISHED.name = "TSCTechFinished"
pb.TSCTECHFINISHED.full_name = ".com.nkm.common.proto.client.TSCTechFinished"
pb.TSCTECHFINISHED.nested_types = {}
pb.TSCTECHFINISHED.enum_types = {}
pb.TSCTECHFINISHED.fields = {pb.TSCTECHFINISHEDTECHNOLOGY_FIELD}
pb.TSCTECHFINISHED.is_extendable = false
pb.TSCTECHFINISHED.extensions = {}
pb.TCSTECHCANCELTECHID_FIELD.name = "techId"
pb.TCSTECHCANCELTECHID_FIELD.full_name = ".com.nkm.common.proto.client.TCSTechCancel.techId"
pb.TCSTECHCANCELTECHID_FIELD.number = 1
pb.TCSTECHCANCELTECHID_FIELD.index = 0
pb.TCSTECHCANCELTECHID_FIELD.label = 1
pb.TCSTECHCANCELTECHID_FIELD.has_default_value = false
pb.TCSTECHCANCELTECHID_FIELD.default_value = 0
pb.TCSTECHCANCELTECHID_FIELD.type = 5
pb.TCSTECHCANCELTECHID_FIELD.cpp_type = 1

pb.TCSTECHCANCEL.name = "TCSTechCancel"
pb.TCSTECHCANCEL.full_name = ".com.nkm.common.proto.client.TCSTechCancel"
pb.TCSTECHCANCEL.nested_types = {}
pb.TCSTECHCANCEL.enum_types = {}
pb.TCSTECHCANCEL.fields = {pb.TCSTECHCANCELTECHID_FIELD}
pb.TCSTECHCANCEL.is_extendable = false
pb.TCSTECHCANCEL.extensions = {}
pb.TSCTECHCANCELTECHNOLOGY_FIELD.name = "technology"
pb.TSCTECHCANCELTECHNOLOGY_FIELD.full_name = ".com.nkm.common.proto.client.TSCTechCancel.technology"
pb.TSCTECHCANCELTECHNOLOGY_FIELD.number = 1
pb.TSCTECHCANCELTECHNOLOGY_FIELD.index = 0
pb.TSCTECHCANCELTECHNOLOGY_FIELD.label = 1
pb.TSCTECHCANCELTECHNOLOGY_FIELD.has_default_value = false
pb.TSCTECHCANCELTECHNOLOGY_FIELD.default_value = nil
pb.TSCTECHCANCELTECHNOLOGY_FIELD.message_type = db_pb.Technology
pb.TSCTECHCANCELTECHNOLOGY_FIELD.type = 11
pb.TSCTECHCANCELTECHNOLOGY_FIELD.cpp_type = 10

pb.TSCTECHCANCEL.name = "TSCTechCancel"
pb.TSCTECHCANCEL.full_name = ".com.nkm.common.proto.client.TSCTechCancel"
pb.TSCTECHCANCEL.nested_types = {}
pb.TSCTECHCANCEL.enum_types = {}
pb.TSCTECHCANCEL.fields = {pb.TSCTECHCANCELTECHNOLOGY_FIELD}
pb.TSCTECHCANCEL.is_extendable = false
pb.TSCTECHCANCEL.extensions = {}

TCSGetTech = protobuf.Message(pb.TCSGETTECH)
TCSTechCancel = protobuf.Message(pb.TCSTECHCANCEL)
TCSTechFinished = protobuf.Message(pb.TCSTECHFINISHED)
TCSTechLevelUp = protobuf.Message(pb.TCSTECHLEVELUP)
TCSTechSpeedUp = protobuf.Message(pb.TCSTECHSPEEDUP)
TSCGetTech = protobuf.Message(pb.TSCGETTECH)
TSCTechCancel = protobuf.Message(pb.TSCTECHCANCEL)
TSCTechFinished = protobuf.Message(pb.TSCTECHFINISHED)
TSCTechLevelUp = protobuf.Message(pb.TSCTECHLEVELUP)
TSCTechSpeedUp = protobuf.Message(pb.TSCTECHSPEEDUP)
