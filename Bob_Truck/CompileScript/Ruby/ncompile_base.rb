# coding: utf-8
require_relative 'ncommon'

include Common

class CompileBase
	def initialize platform, client_mode, channel
		@platform = Common.platform platform
		raise 'platform error!' if @platform.nil?

		@client_mode = Common.client_mode client_mode
		raise 'client_mode error!' if @client_mode.nil?

		@channel = Common.channel channel
		raise 'channel error!' if @channel.nil?

		project_root = File.file_dir(__FILE__) + '/../../'
		@project_path = project_root
		
		write_info
	end

	def write_info
		version = '1.0.0'

		#cmd = "svn info ../../ | grep 'Last Changed Rev:' | awk '{print $4}' | xargs -I x printf '#{version}.%s' x"
		
		cmd = "svn info ../../ | grep 'Revision' | awk '{print $2}'"

		#@version = Common.sys_call_with_result cmd
		@version = version

		path = @project_path + '/Assets/Resources/info.txt'

		File.write(path, @version)
	end

end
    