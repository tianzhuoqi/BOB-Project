# -*- coding: utf-8 -*-
require 'fileutils'
require 'find'

require_relative 'ncommon'

include Common

class NLuaSyntaxCheck
  def initialize
    @project_path = File.file_dir(__FILE__) + "/../../"
    @luajit_path = "./LuaJIT/"
    @lua_path = @project_path + "Assets/ResourcesAssets/Lua/"
  end

  def work
    # 路径
    Dir::chdir(@luajit_path)
    
    Find.find @lua_path do |file|
      if File.file? (file) and file.end_with?('.lua') then
        check_lua file
      end
    end
  end
  
  def check_lua lua_file
    cmd = "luajit.exe -b #{lua_file} -l"
    Common.sys_call_with_result cmd
  end
end

if __FILE__ == $0
  check = NLuaSyntaxCheck.new
  check.work
end
