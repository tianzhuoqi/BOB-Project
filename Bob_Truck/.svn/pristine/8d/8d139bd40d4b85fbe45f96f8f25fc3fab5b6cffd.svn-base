# coding: utf-8
require 'json'
require 'fileutils'
require 'find'
require_relative 'ncommon'
require_relative 'ncompile_base'
require_relative 'nunity_cmd'
require_relative 'nxcode_build'

include Common

class CompileUnity < CompileBase
	def initialize platform, client_mode, channel
		super platform, client_mode, channel

		@log_path = @project_path + "/Build/compile_build.log"
		@unity_method = build_unity_method
	end

	def do
		compile_android if Common.android? @platform
		compile_ios if Common.ios? @platform
	end

	protected
	# 读取渠道配置信息
	def read_channel_data
		config = JSON.parse (File.read_all("./Config/channel_data.cfg"))
		raise "channel_data.cfg 渠道配置文件不存在" if config.nil?

		platformData = config[@platform]
		raise "channel_data.cfg中#{@platform}渠道配置信息不存在" if platformData.nil?

		channelData = platformData[@channel]
		raise "该渠道配置不存在或渠道code错误!#{@platform}渠道配置信息:#{platformData.to_json}" if channelData.nil?

		channel_name = channelData["fullname"]
		channel_code = channelData["channel"]

		puts "****   平台类型：#{@platform}     渠道名称：#{channelData["fullname"]}      渠道编码：#{channel_code}   ****"

		unless channelData["bundleId"].nil? then
			@bundleId = channelData["bundleId"]
			puts "****   游戏包名：#{@bundleId}   ****"
		end

		unless channelData["productName"].nil? then
			@productName = channelData["productName"]
			puts "****   游戏名称：#{@productName}   ****"
		end
		
		unless channelData["teamId"].nil? then
			@teamID = channelData["teamId"]
			puts "****   TeamID：#{@teamID}   ****"
		end
		
		unless channelData["profileId"].nil? then
			@profileId = channelData["profileId"]
			puts "****   ProfileID：#{@profileId}   ****"
		end

		unless channelData["pushConfig"].nil? then
			@pushConfig = channelData["pushConfig"]
		end

		unless channelData["signInfo"].nil? then
			@signInfo = channelData["signInfo"]
			puts "****   签名信息：#{@signInfo.to_json}   ****"
		end
	end

	# 设置unity编译参数
	def set_unity_cfg 
		config = JSON.parse (File.read_all("./Config/build_unity.cfg"))
		raise "build_unity.cfg Unity配置文件不存在" if config.nil?

		config["BuildMode"] = @client_mode

		config["DefineSymbols"] = config["ClientModeMacro"][@client_mode] + ";" + config["ChannelMacro"][@channel]

		config["BundleId"] = @bundleId
		config["ProductName"] = @productName
		config["TeamID"] = @teamID
		config["ProfileID"] = @profileId

		puts "****   参数信息：#{config.to_json}   ****"

		tempFile = File.new("./Config/build_unity_temp.cfg","w+")
		tempFile.puts config.to_json
		tempFile.close
	end

	#更新Plugins/Android文件资源
	def update_plugins_android
		rootDirectory = @project_path + "/CompileScript/Plugins/#{@platform}"
		commonDirectory = "#{rootDirectory}/Common"
		channelDirectory = "#{rootDirectory}/#{@channel}"
		toDirectory = @project_path + "/Assets/Plugins"

		cmd = "cp -a #{commonDirectory}/* #{toDirectory}"
		raise "更新common文件资源 error!" unless Common.sys_call cmd

		cmd = "cp -a #{channelDirectory}/* #{toDirectory}/Android"
		raise "更新渠道#{@channel}文件资源 error!" unless Common.sys_call cmd

		puts '更新Assets/Plugins/Android文件资源 success!'
	end

	#设置ios JPush参数
	def set_ios_pushConfig 
		pushConfig =<<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>APS_FOR_PRODUCTION</key>
	<string>1</string>
	<key>APP_KEY</key>
	<string>#{@pushConfig["APP_KEY"]}</string>
	<key>CHANNEL</key>
	<string>#{@pushConfig["CHANNEL"]}</string>
</dict>
</plist>
PLIST
		pushConfig_path = @project_path + "CompileScript/ruby/Plugins/iOS/common/kp/PushConfig.plist";

		File.write(pushConfig_path, pushConfig)
	end

	#更新Editor/XCodeAPI/Frameworks文件资源
	def update_plugins_ios
		#set_ios_pushConfig

		rootDirectory = @project_path + "/CompileScript/Plugins/#{@platform}"
		commonDirectory = "#{rootDirectory}/Common"
		channelDirectory = "#{rootDirectory}/#{@channel}"
		toDirectory = @project_path + "/Assets/Editor/XCodeAPI/Frameworks"

		cmd = "cp -a #{commonDirectory}/* #{toDirectory}"
		raise "更新common文件资源 error!" unless Common.sys_call cmd

		cmd = "cp -a #{channelDirectory} #{toDirectory}"
		raise "更新渠道#{@channel}文件资源 error!" unless Common.sys_call cmd

		puts '更新Assets/NKM/Editor/iOS文件资源 success!'
	end

	def build_unity_method
		method = {
			iOS: 'BuildIOSImpl',
			Android: 'BuildAndroidImpl',
		}
		"CommandBuild.#{method[@platform.to_sym]}"
	end

	def compile_unity
		cmd = "rm -rf #{@project_path}/Assets/StreamingAssets/#{@platform}/*"
		raise "删除资源文件 error" unless Common.sys_call cmd
	
		read_channel_data
		set_unity_cfg
		update_plugins_android if Common.android? @platform
		update_plugins_ios if Common.ios? @platform

		puts "Start Compile #{@platform} Project ..."
		cmd = UnityCmd.new @project_path, @unity_method, @log_path

		raise "***Compile #{@platform} failed!" unless cmd.do
		raise "***Scan Compile #{@platform} log error!" if scan_error?
	end

	def compile_ios
		compile_unity
		xcode_build
		rename_client
		compile_over
	end

	def xcode_build
		puts '---' * 10 + "Xcode Build" + '---' * 10

		xcode = XCodeBuild.new 'Unity-iPhone.xcodeproj', @signInfo
		xcode.build
	end

	def compile_android
		compile_unity
		rename_client
		#transport_file
		compile_over
	end

	def compile_over
		#logs
		puts "**** Compile Success! ****"
		cmd = "grep '\\*\\*\\*' #{@log_path}"
		Common.sys_call cmd
	end

	def rename_client
		#rename
		file_type = nil
		@file_type = '.apk' if Common.android? @platform
		@file_type = '.ipa' if Common.ios? @platform

		cmd = "mv #{@project_path}/Build/game#{@file_type} #{@project_path}/Build/game_#{@client_mode.downcase}#{@file_type}"
		Common.sys_call cmd
	end
	
	def read_transport_config
		config = JSON.parse(File.read_all("./Config/transport_client.cfg"))
		@ip = config["ip"]
		@username = config["username"]
		@password = config["password"]
		@source_file = "#{@project_path}/Build/game_#{@client_mode.downcase}#{@file_type}"
		@to_path = "#{config["to_path"]}"
		
		raise "read config error!" unless @ip and @username and @password and @source_file and @to_path
	end
	
	def transport_file
		read_transport_config
	
		cmd = "./transport.exp #{@ip} #{@username} #{@password} #{@source_file} #{@to_path}"
		raise "transport file #{@source_file} error!" unless Common.sys_call(cmd)
	end

	def scan_error?
		cmd = "grep -Hn '\\*\\*\\* Completed' #{@log_path} | wc | awk '{print $1}'"
		result = Common.sys_call_with_result(cmd)
		result == '0' or result.nil?
	end
end

if __FILE__ == $0
	compile = CompileUnity.new ARGV.first, ARGV[1], ARGV[2]
	compile.do
end
