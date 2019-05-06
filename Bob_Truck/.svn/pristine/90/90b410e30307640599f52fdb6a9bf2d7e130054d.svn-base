# -*- coding: utf-8 -*-

require_relative "ncommon"
require 'json'
require 'cgi'

include Common

class NSubmitServer
	def initialize platform, client_mode
		@platform = Common.platform platform
		raise 'platform error' if @platform.nil?

		@client_mode = Common.client_mode client_mode
		raise 'client_mode' if @client_mode.nil?

		@project_path = File.file_dir(__FILE__) + "/../../"

		cmd = "cat #{@project_path}/Assets/Resources/info.txt"
		@version = Common.sys_call_with_result cmd

		check_file

		@download_file_name = "#{Time.new.to_i}_#{@version}_#{@file_name}"
		@note = @download_file_name
		# @note = "ruby测试"

		read_transport_config
	end

	# 检查客户端是否存在
	def check_file
		file_type = Common.get_file_type @platform

		@file_name = "game_#{@client_mode}.#{file_type}"
		@source_path = @project_path + "/Build/" + @file_name

		if Common.ios? @platform then
			@client_type = 1
		elsif Common.android? @platform then
			@client_type = 2
		end

		raise "file (#{@file_path}) no exist "if not File.exist? @source_path
	end

	def work
		transport_file
		update_server_info
	end

	def up_plist
		require_relative 'up_plist'
		up = UpPlist.new @download_file_name.split('.ipa').first
		up.work
	end

	def update_server_info
		# url中文需要转换一下
		url = "http://192.168.80.17:9999/add_version?version=#{@version}&client_type=#{@client_type}&file_name=#{@download_file_name}&note=#{CGI.escape @note}"
		cmd = "curl '#{url}'"
		puts cmd
		puts Common.sys_call_with_result cmd
	end

	def read_transport_config
		config = JSON.parse (File.read_all("./Config/transport_client.cfg"))
		@ip = config["ip"]
		@username = config["username"]
		@password = config["password"]
		@to_path = config["to_path"] + @download_file_name

		raise "read config error!" unless @ip and @username and @password and @to_path
	end

	def transport_file
		cmd = "./transport.exp #{@ip} #{@username} #{@password} #{@source_path} #{@to_path}"
		puts cmd
		raise "transport file #{source_path} error!" unless Common.sys_call(cmd)

		# 如果是ios，需要提交plist
		if Common.ios? @platform then
			up_plist
		end
	end

end

if __FILE__ == $0
	# client = NSubmitServer.new 'ios', 'publish'
	client = NSubmitServer.new ARGV.first, ARGV[1]
	client.work
end
