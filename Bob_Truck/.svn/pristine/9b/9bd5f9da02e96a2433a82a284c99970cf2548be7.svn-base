# -*- coding: utf-8 -*-
require 'pathname'
require 'digest'

module Common
	Platform = {
		Android: ['a', 'android', '-a', '-android'],
		iOS: ['ios', '-ios', 'i', '-i'],
	}

	ClientMode = {
		#发布稳定版本
		Release: ['release','r', '-r', '-release'],
		#测试版本
		Debug: ['debug','d', '-d', '-debug'],
	}

	Channel = {
		#海外版本
		Overseas: ['overseas','o','-o','-overseas'],
		#Developer版本，ios使用企业证书签名，提供给所有设备安装
		Developer: ['developer','d','-d','-developer'],
	}

	IOS = 'iOS'
	Android = 'Android'

	def macosx?
		host_os = RbConfig::CONFIG['host_os']
		if host_os =~ /darwin|mac os/ then
			return true
		else
			return false
		end
	end

	def get_file_type platform
		file_type = ''
		if ios? platform then
			file_type = 'ipa'
		elsif android? platform then
			file_type = 'apk'
		end

		return file_type
	end

	def platform param
		ret = nil
		Platform.each do |key, value|
			ret = key.to_s if value.include? param
		end
		ret
	end

	def client_mode param
		ret = nil
		ClientMode.each do |key, value|
			ret = key.to_s if value.include? param
		end
		ret
	end

	def channel param
		ret = nil
		Channel.each do |key, value|
			ret = key.to_s if value.include? param
		end
		ret
	end

	def ios? param
		IOS == param
	end

	def android? param
		Android == param
	end

	def sys_call cmd
		#result = `#{cmd}`
		system(cmd)
		puts "call #{cmd} error" unless $?.success?
		true if $?.success?
	end

	def sys_call_with_result cmd
		result = `#{cmd}`.chomp
		puts 'sys call with result error' unless $?.success?
		result if $?.success?
	end
end


class File
	def self.file_dir file_name
		Pathname.new(File.dirname(file_name)).realpath.to_s
	end

	def self.file_same? path1, path2
		true if File.exist? path1 and File.exist? path2 and Digest::MD5.hexdigest(File.read(path1)) == Digest::MD5.hexdigest(File.read(path2))
	end

	def self.read_all file_name
		all_lines = ""

		file = File.open(file_name)
		file.each do |line|
			all_lines << line
		end

		all_lines
	end
end
