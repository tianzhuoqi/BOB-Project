# -*- coding: utf-8 -*-
require_relative 'ncommon'

include Common

class XCodeBuild
	def initialize project_name, signInfo
		@project_path = File.file_dir(__FILE__) + '/../../Build'
		@project_name = @project_path + '/game_xcode/' + project_name

		@root_path = File.file_dir(__FILE__) + '/../../'

		@xcarchive_path = @project_path + '/game_xcode.xcarchive'

		@ipa_path = @project_path + '/game.ipa'

		@code_sign_identify = 'iPhone Distribution: Jiu Wanli network technology (Shanghai) Co., Ltd.'
		@export_plist_path = @root_path + "/CompileScript/Ruby/IOS_Export/export_enterprise.plist"

		unless signInfo.nil? then
			@code_sign_identify = signInfo["codeSignIdentify"]
			@export_plist_path = @root_path + "/CompileScript/Ruby/IOS_Export/" + signInfo["exportPlist"]
		end
	end

	#这里有几个特殊情况
	#1.若是一个干净的Unity-iPhone.xcodeproj, 则可以直接编译
	#2.若是一个通过anySDK处理过的Unity-iPhone.xcodeproj，则需要手动移除scheme
	#!!!.这个脚本只处理由unity导出的xcode项目
	def get_xcode_version
		cmd = "xcodebuild -version | grep 'Xcode' | awk '{print $2}'"
		version = Common.sys_call_with_result cmd
	end

	def xcode9?
		version = get_xcode_version
		return version.start_with? '9.'
	end

	def export_ipa
		cmd = "xcodebuild -exportArchive -archivePath #{@xcarchive_path} -exportPath #{@project_path} -exportOptionsPlist #{@export_plist_path}"
		raise "xcodebuild export error!" unless Common.sys_call(cmd)  

		if @export_plist_path.include?("export_appstore.plist") then
			cmd = "mv #{@project_path}/Unity-iPhone.ipa #{@ipa_path}"
			raise "mv ipa error!" unless Common.sys_call(cmd)
		else
			cmd = "mv #{@project_path}/Apps/Unity-iPhone.ipa #{@ipa_path}"
			raise "mv ipa error!" unless Common.sys_call(cmd)
		end
	end

	def build_by_xcodebuild
		#remove old xcarchive file and ipa file
		cmd = "rm -rf #{@xcarchive_path}"
		Common.sys_call(cmd)

		cmd = "rm -rf #{@ipa_path}"
		Common.sys_call(cmd)

		#archive
		#这里考虑到一些png图片会出错导致archive failed.但是又不影响二进制的内容，
		#所以这里忽略这种特殊情况，只要判断archive file生成则认为是archive success
		cmd = "xcodebuild -project #{@project_name} -scheme 'Unity-iPhone' archive -archivePath #{@xcarchive_path} CODE_SIGN_IDENTITY='#{@code_sign_identify}'"
		no_error = Common.sys_call(cmd) 
		if no_error or File.exist? @xcarchive_path then
			puts "------ archive ok!"
		else
			raise "archive failed!"
		end
	end

	def build
		build_by_xcodebuild

		export_ipa
	end
end

if __FILE__ == $0
	xcode = XCodeBuild.new 'Unity-iPhone.xcodeproj'
	xcode.build
end
