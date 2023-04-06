#!/bin/bash

###################################################################################
# Description: 转换GBK/GB2312/GB18030编码格式的文件为utf-8
#	当前支持 *c, *.h, *.txt, *.s
# Cmd supported:
#	./code-conv.sh [path]  #path表示要处理的路径，为空则处理当前路径下所有文件
#	./code-conv.sh clean   #清除上次处理后的临时文件
#
#	./code-conv.sh git-reset   #重置git库(本地测试使用)
#	./code-conv.sh test	   #本地测试使用
#
# Author:	xuchuan
###################################################################################

###需要进行转换的代码路径, 可以根据具体的代码路径进行配置###
g_file_path="."

###g_file_path下的所有文件列表保存到 old_file_list 文件中###
g_file_list="old_file_list.txt"
g_file_list_new="new_file_list.txt" #成功转换后的文件列表
g_file_convert_result="conv_result.txt"
g_file_result_OK="OK"
g_file_result_FAILED="FAILED"
g_file_git_st="git_st.txt"

###循环处理g_file_list中的文件时，用于保存原文件名###
old_file_name=""

###循环处理g_file_list中的文件时，用于保存新文件名###
new_file_name=""

###循环处理g_file_list中的文件时，用于保存装换中是否存在失败的标记###
convert_flag=0


function show_help(){
	echo "

*****************************************************************************************
Description: 转换GBK/GB2312/GB18030编码格式的文件为utf-8, 当前支持 *c, *.h, *.txt, *.s

Cmd supported:
./code-conv.sh [path]  #path表示要处理的路径，为空则处理当前路径下所有文件
./code-conv.sh clean   #清除上次处理后的临时文件

./code-conv.sh git-reset #重置到代码原始状态HEAD(仅适用与使用git进行代码管理的环境使用)

Author:	  xuchuanb
*****************************************************************************************

"
}


# func: clean old tmp tiles
function clean_old_tmp_files(){
	echo "cleaning old tmp files..."
	#clean_test_code
	rm -f $g_file_list $g_file_list_new $g_file_convert_result $g_file_result_OK $g_file_result_FAILED $g_file_git_st
	find . -type f -name "*.new" | xargs rm -f		#获取convert过后，转换失败后残留的.new文件
	echo "old tmp files cleaned ok."
}


# func:解析命令参数信息
function analyze_param(){
	cmd_clean="clean"
	cmd_test="test"
	#如果包含1个命令参数
	if [ -n "$1" ]; then
		if [ $1 == $cmd_clean  ]; then
			if [ $2 == $test  ]; then #./code-conv.sh clean test
				echo "./xx test"
				clean_test_code
				exit
			else
				echo "./xx clean"
				clean_old_tmp_files		# ./code-conv.sh clean
				exit
			fi
		elif [ $1 == $test	]; then	   # ./code-conv.sh test
			echo "./xx test"
			clean_old_tmp_files
			pre_test_code
		else
			echo "./xx xxx/xxxx"
			g_file_path=$1			  # ./code-conv.sh xxx/xxx
		fi
	else
		echo "./xx"
	fi

	echo $g_file_path				# ./code-conv.sh
}



# func:找到指定路径下的所有文件，并存放到g_file_list文件中
function list_all_files(){
	find $g_file_path -type f -name "*.c" > $g_file_list
	find $g_file_path -type f -name "*.h" >> $g_file_list
	find $g_file_path -type f -name "*.txt" >> $g_file_list
	find $g_file_path -type f -name "*.s" >> $g_file_list

	#删除convert产生的临时文件
	g_file_list_tmp="./"$g_file_list
	sed -i '/'"$g_file_list"'/d' $g_file_list
}


#  func:循环遍历 g_file_list 中所有文件进行转换##
function convert_to_utf8(){
	for line in `cat $g_file_list`
	do
		old_file_name=`echo $line`
		new_file_name=$old_file_name".new"

		file $old_file_name

		# 执行编码转换
		iconv -f cp936 -t utf-8 $old_file_name -o $new_file_name		
		if [ $? -eq 0 ]
		then
			rm -f $old_file_name					#删除原原文件
			mv -f $new_file_name $old_file_name		#使用转换后的文件替换原文件
			printf "%s\n" $old_file_name >> $g_file_list_new
		else
			printf "Code Convert %s to %s failed.\n\n" $old_file_name $new_file_name
			shitf_flag=1;
			diff $old_file_name $new_file_name | sed -n '1,5p' >> $g_file_result_FAILED
		fi

		#dos风格的转为unix风格
		dos2unix -q $old_file_name
	done
}


# func:比较转换前后的文件有无差异
function diff_old_new() {
	cnt_old=`cat $g_file_list | wc -l`
	cnt_new=`cat $g_file_list_new | wc -l`
	cnt_failed=`expr $cnt_old - $cnt_new`
	diff $g_file_list $g_file_list_new > $g_file_convert_result		#对比old/new的文件列表，如果不同，说明没有全部转换成功,将差异项记录到结果中

	if [ $cnt_failed -gt 0	]; then
		printf "\n\n------------------------------------------\n"
		echo "Convert coding to utf-8 Failed!"
		echo "------------------------------------------"

		#打印转换结果和详细信息
		printf "Files bellowed are failed:(%d of %d)\n" $cnt_failed $cnt_old
		cat $g_file_convert_result
		succ_percent=$(printf "%.5f" `echo "scale=5; $cnt_new/$cnt_old" | bc`)
		succ_percent=$(echo "$succ_percent * 100" | bc -l)
		printf "\n------------------Success rate: %.2f%%---------------------------\n\n" $succ_percent

		#将结果保存到文件 FAILED 中
		printf "\n\n----------------Failed Summary Info---------------\n" >> $g_file_result_FAILED
		failed_percent=$(printf "%.5f" `echo "scale=5; $cnt_failed/$cnt_old" | bc`)
		failed_percent=$(echo "$failed_percent * 100" | bc -l)
		printf "Files bellowed are failed:(%d of %d) %.2f%% \n" $cnt_failed $cnt_old $failed_percent >> $g_file_result_FAILED
		cat $g_file_convert_result >>  $g_file_result_FAILED
	else
		mv $g_file_convert_result $g_file_result_OK -f
		printf "\n\n------------------------------------------\n"
		echo "Convert coding to utf-8 Succeed!"
		echo "------------------------------------------"
	fi
}

function main(){
	## 0. 解析命令参数
	cmd_clean="clean"
	cmd_git_reset="git-reset"
	cmd_help="help"

	if [ -n "$1" ]; then
		if [ $1 == $cmd_clean  ]; then		# ./code-conv clean
			clean_old_tmp_files
			exit
		elif [ $1 == $cmd_git_reset	 ]; then	# ./code-conv.sh git-reset
			echo "git reseting to HEAD and removing the old tmp *.new files..."
			clean_old_tmp_files
			git reset --hard HEAD							#代码恢复到HEAD版本
			git st
			exit
		elif [ $1 == $cmd_help ]; then	  # ./code-conv.sh help
			show_help
			exit
		else									# ./code-conv.sh xxx/xxx
			if [ ! -d $1  ]; then
				echo "Directory not exist or CMD not support, please check!"
				show_help
				exit
			else
				g_file_path=$1
				printf "Converting files of \"%s\" to utf-8...\n\n" $g_file_path
			fi
		fi
	else							# ./code-conv.sh <CR>
		printf "Converting files of \"%s\" to utf-8...\n\n" $g_file_path
	fi


	## 1. 删除残留的临时文件
	clean_old_tmp_files

	## 2. 找到需要转换的代码路径下所有文件所在的路径，并保存到 old_file_list.txt 文件中 ##
	list_all_files

	## 3. 转换 old_file_list.txt 文件中所列出的所有文件格式
	convert_to_utf8

	## 4. 检查转换结果
	diff_old_new
}

#entry
main $1 $2 $3
