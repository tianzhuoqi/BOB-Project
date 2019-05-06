#!/bin/sh

function show() {
	time=`date "+%Y-%m-%d %H:%M:%S"`
	echo "\033[32m $1 \033[0m  \033[31m $time \033[0m"
}

#通过项目路径判断打包平台以及渠道
path=`pwd`
if [[ $path =~ "ios" ]]; then
	platform="ios"
elif [[ $path =~ "android" ]]; then
	platform="android"
fi

if [[ $path =~ "southeast" ]]; then
	channel="southeast"
fi

if [[ $platform = "" ]]; then
	echo "\033[31m 请输入平台：? (android/ios) \033[0m"
	read platform
fi

if [[ $channel = "" ]]; then
	echo "\033[31m 请输入渠道：? (southeast/tiyan/amazon/samsung) \033[0m"
	read channel
fi

show "开始更新svn"
ruby nsvn_update.rb

info_kp=`cat ../../Assets/Resources/info.txt`
info_kp=`echo ${info_kp:6}`
info_other=`svn info ../../Assets/Resources_Other | grep 'Last Changed Rev:' | awk '{print $4}'`
show "比较版本号, 判断是否需要编辑, Kp: $info_kp, Resources_Other: $info_other"
if [[ "$info_other" -gt "$info_kp" ]]; then
	show "开始编译streaming_assets"
	ruby ncompile_streaming_assets.rb $platform
fi

show "开始编译lua"
ruby ncompile_lua.rb $platform

show "开始编辑unity, 平台: $platform, 版本：release, 渠道: $channel"
ruby ncompile_unity.rb $platform release $channel

if [[ $platform = "android" ]]; then

	show "开始处理apk"
	cd ../../Build
	rm -rf kp
	unzip kp_stable.apk -d kp
	rm -rf ../../HyperHeroes/app/src/main/assets
	cp -a kp/assets ../../HyperHeroes/app/src/main/assets
	info=`cat ../Assets/Resources/info.txt`
	info=`echo ${info:6}`

	#清空
	rm -rf ../../outputs/*

	if [[ $channel = "southeast" ]]; then
		cp -a kp.main.obb main.$info.com.nkm.kp.hh.obb
		#拷贝obb到输出目录
		cp -a main.$info.com.nkm.kp.hh.obb ../../outputs/
	fi

	show "开始编译android studio"
	cd ../../HyperHeroes/
	gradle build -x assembleDebug -PVERSION_CODE=$info

	#拷贝apk到输出目录
	ls app/build/outputs/apk/ | grep $info | tail -n 1 | xargs -I {} cp -a  app/build/outputs/apk/{} ../outputs/

	cd ../outputs/
	show "zipalign优化"
	ls | grep "_pro_sign.apk" | xargs -I {} zipalign -f -v 4 {} {}_zipalign.apk

	show "编译的包"
	ls | xargs -n1 -I {} echo `pwd`/{}

else

	show "开始上传ipa包到App Store"
	altool --upload-app -f ../../Build/kp_stable.ipa -u lifeng@90kmile.com -p Hyperjoy2017

fi