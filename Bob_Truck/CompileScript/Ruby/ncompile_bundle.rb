# coding: utf-8
require 'digest'
require 'json'
require_relative 'nunity_cmd'
require_relative 'ncommon'
require_relative 'ncompile_base'
require 'find'

include Common

class CompileBundle < CompileBase
	def initialize platform
		super platform, "release", "overseas"
		@log_path = @project_path + "/Build/build_#{@platform}_bundle.log"
		@unity_method = build_unity_method
		@resource_path = @project_path + "Assets/StreamingAssets/#{@platform}"
		#cmd = "svn info ../../ | grep 'Revision' | awk '{print $2}'"
		#@version = Common.sys_call_with_result cmd
	end
	
	def do
		clear_old_resource

		build

		zip_file

		transport_file
	end

	def read_transport_config
		config = JSON.parse(File.read_all("./Config/transport.cfg"))
		@ip = config["ip"]
		@username = config["username"]
		@password = config["password"]
		@source_file = "#{@resource_path}/#{@version}.zip"
		@to_path = "#{config["to_path"]}/#{@platform}"
		
		raise "read config error!" unless @ip and @username and @password and @source_file and @to_path
	end

	def transport_file
		read_transport_config
	
		cmd = "./transport.exp #{@ip} #{@username} #{@password} #{@source_file} #{@to_path}"
		raise "transport file #{@source_file} error!" unless Common.sys_call(cmd)
	end
	
	def clear_old_resource
		cmd = "rm -rf #{@resource_path}/*"
		raise "rm zip #{@resource_path}/*" unless Common.sys_call cmd
	end

	def zip_file
		file_name = "#{@resource_path}/#{@version}"
		
		pwd = Dir.pwd
		Dir.chdir(@resource_path)

		cmd = "zip -r #{file_name}.zip #{file_name}/"
		raise "zip file #{file_name} file error!" unless Common.sys_call cmd

		Dir.chdir(pwd)
		puts "zip #{file_name} files OK!"
	end

	def build
		unity_cmd = UnityCmd.new @project_path, @unity_method, @log_path
		result = unity_cmd.do
		if result
			puts "***Build Bundle #{@platform} Success !"
		end
	end

	def build_unity_method
		method = {
			iOS: 'BuildIOSAssetBundle',
			Android: 'BuildAndroidAssetBundle',
		}
		unity_method = method[@platform.to_sym]
		"AssetBundleBuild.#{unity_method}"
	end
end

if __FILE__ == $0
	build = CompileBundle.new ARGV.first
	build.do
end
