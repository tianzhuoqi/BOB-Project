# coding: utf-8
require_relative 'ncommon'

class UnityCmd
	def initialize project_path, unity_method, log_path
		@project_path = project_path
		@unity_method = unity_method
		@log_path = log_path
	end

	def do
		cmd = "/Applications/Unity/Unity.app/Contents/MacOS/Unity -batchmode -executeMethod #{@unity_method} -quit -logFile -projectPath #{@project_path} | tee #{@log_path}"
		result = Common.sys_call cmd
		true unless result.nil?
	end
end

if __FILE__ == $0
	unityCmd = UnityCmd.new ARGV.first, ARGV[1], ARGV[2]
	unityCmd.do
end
