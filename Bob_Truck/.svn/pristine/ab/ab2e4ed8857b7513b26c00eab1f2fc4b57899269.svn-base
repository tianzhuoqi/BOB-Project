# -*- coding: utf-8 -*-
require 'fileutils'
require 'find'

require_relative 'ncommon'

include Common

class Array
	def anotherMap
		self.map {|e| yield e}
	end
end

class BuildLua
	def initialize platform
		@project_path = File.file_dir(__FILE__) + "/../../"
		@src_lua = @project_path + "Assets/uLua/Lua/"
		@desc_lua = @project_path + "Assets/Resources/Lua/"

		@platform = Common.platform platform
		raise 'platform error!' if @platform.nil?

		@luajit_path = "./LuaJIT/"
		@luac_path = "./Luac/"
	end

	def work
		copy_files

		compile

		#clear old lua file
		clear_files ".lua"

		puts "compile lua suceess!"
	end

	def compile
		# Dir::chdir(@lua_path)
		Dir::chdir(@luajit_path) if Common.android? @platform

		Dir::chdir(@luac_path) if Common.ios? @platform

		if Common.macosx? then
			cmd = "chmod a+x ./luajit"
			cmd = "chmod a+x ./luac5.1" if Common.ios? @platform
			raise "chmod luac/luajit error!" unless Common.sys_call cmd
		end
			
		files = []
		Find.find @desc_lua do |file|
			if File.file? (file) and file.end_with?('.lua') then
				compile_lua file
			end        
		end
	end

	def compile_lua lua_file
		# puts "compile_lua #{lua_file}"
		src_file = lua_file
		desc_file = lua_file.gsub('.lua', '.bytes')

		encode_lua_file src_file, desc_file
	end
  
	# 采用新的加密方式 
	def encode_lua_file file_path, file_to_path
		bytes = []
		File.open(file_path, "rb") do |file|
			bytes = file.read.unpack("C*")
		end

		key = "90km.com.cn".unpack("C*")
		bytes.each_with_index do |item, index|
			bytes[index] = (item ^ key[index % key.length])
		end

		File.open(file_to_path, "wb") do |file|
			file.write bytes.pack("C*")
		end
	end

	def copy_files
		#rm old files
		FileUtils.rm_r @desc_lua

		#cp Assets/uLua/Lua -> Assets/Resources/Lua
		FileUtils.cp_r @src_lua, @desc_lua

		#clear meta file
		clear_files ".meta"
	end

	def clear_files file_stuffix
		Find.find @desc_lua do |item|
			if File.file?(item) and item.end_with?(file_stuffix)
				File.delete item
			end
		end
	end
end

if __FILE__ == $0
	build = BuildLua.new ARGV.first
	build.work
end
