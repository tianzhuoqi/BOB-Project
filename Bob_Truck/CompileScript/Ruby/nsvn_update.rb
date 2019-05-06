class Update
	def initialize
	end

	def work
		update
		print
	end
	
	def sys_call cmd
		system(cmd)
		puts "call #{cmd} error" unless $?.success?
		true if $?.success?
	end
	
	def update
		Dir.chdir("../../")
		cmd = "svn st | grep '?' | awk '{print $2}' | grep ^Assets/ | grep -v StreamingAssets | xargs -I x rm -rf x"
		raise 'remove ? error!' unless sys_call(cmd)

		cmd = "svn up --accept 'theirs-full'"
		raise "svn up error!" unless sys_call(cmd)    
	end

	def print
		#写入临时文件，防止首次编译报错
		path = "./CompileScript/Ruby/Config/build_unity_temp.cfg"
		if not File::exist?( path) then
			tempFile = File.new(path,"w+")
			tempFile.close
		end

		cmd = "svn st | grep -v StreamingAssets | grep -v Build"
		puts "******** svn list *********"
		raise "svn st error!" unless sys_call(cmd)
	end
end

if __FILE__ == $0
	update = Update.new
	update.work
end  
