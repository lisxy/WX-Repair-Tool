#!/system/bin/sh

# ============================================================
# ============================================================

readonly scriptName="interactiveImport.sh"
readonly repositoryHomePage="https://github.com/LRFP-Team/WX-Configuration-Backups"
readonly repositoryContentLink="https://raw.githubusercontent.com/LRFP-Team/WX-Configuration-Backups/main"
readonly wechatPackageName="com.tencent.mm"
readonly wechatUI=".ui.LauncherUI"
readonly wxPackageName="com.fkzhang.wechatxposed"
readonly xPackageName="cn.android.x"
readonly coreDataTag="%E6%A0%B8%E5%BF%83%E6%96%87%E4%BB%B6"
readonly fkzDataTag="FKZ_WX_DATA"

# 默认设置
CURRENT_USER_ID=0
SELECTED_MODULE="" 
DOWNLOAD_BASE="/sdcard/Download/.wxConfigurations"

# 颜色定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

# --- 欢迎与用户协议 (基于原版逻辑) ---
show_agreement() {
	clear
	printf "\n%b===== Welcome to %s =====%b\n" "$BLUE" "${scriptName}" "$NC"
	printf "%b===== 欢迎使用 %s =====%b\n\n" "$BLUE" "${scriptName}" "$NC"
	printf "%bPlease review the script before execution.%b\n" "$YELLOW" "$NC"
	printf "%b请在执行前仔细审计脚本内容。%b\n\n" "$YELLOW" "$NC"
	printf "%bSubmit core and FKZ_WX_DATA files to:%b\n  %s\n" "$GREEN" "$NC" "${repositoryHomePage}"
	printf "%b如有核心文件或 FKZ_WX_DATA，请提交 PR 至：%b\n  %s\n\n" "$GREEN" "$NC" "${repositoryHomePage}"
	printf "%bBy continuing, you agree to the terms of use and take responsibility for any risks.%b\n" "$CYAN" "$NC"
	printf "%b继续运行即表示您同意使用条款并承担相关风险。%b\n\n" "$CYAN" "$NC"
	printf "%bEnter 'y' to agree and continue, or any other key to exit. %b\n" "$YELLOW" "$NC"
	printf "%b输入 'y' 同意并继续，或输入其它按键退出。%b\n" "$YELLOW" "$NC"
	printf ">>> "
	read -r user_input
	if [[ "${user_input}" != "y" && "${user_input}" != "Y" ]]; then
		printf "\n%bAgreement not confirmed. Exiting script.%b\n" "$RED" "$NC"
		printf "%b未同意条款，脚本退出。%b\n" "$RED" "$NC"
		exit 4
	fi
	printf "\n%bAgreement confirmed. Proceeding with script execution.%b\n" "$GREEN" "$NC"
	printf "%b已确认同意，继续执行脚本。%b\n" "$GREEN" "$NC"
	sleep 1
}

# --- 核心工具函数 ---

msg() {
	local color="$1"
	local text="$2"
	printf "%b%s%b\n" "$color" "$text" "$NC"
}

pause() {
	printf "\n%b执行完成，请按回车键继续...%b" "$YELLOW" "$NC"
	read dummy
}

show_progress() {
	local label="$1"
	printf "%b%s: [%b" "$CYAN" "$label" "$NC"
	for i in 1 2 3 4 5 6 7 8 9 10; do
		printf "%b#%b" "$GREEN" "$NC"
		sleep 0.05
	done
	printf "%b] 100%% %b\n" "$CYAN" "$NC"
}

fetch_info() {
	WECHAT_VER_NAME=$(dumpsys package ${wechatPackageName} | grep "versionName" | head -n1 | cut -d'=' -f2 | cut -d' ' -f1)
	WECHAT_VER_CODE=$(dumpsys package ${wechatPackageName} | grep "versionCode" | head -n1 | cut -d'=' -f2 | cut -d' ' -f1)
	
	if [ -n "$WECHAT_VER_CODE" ] && [ $((WECHAT_VER_CODE % 20)) -ne 0 ]; then
		WECHAT_DISPLAY_NAME="Play $WECHAT_VER_NAME"
	else
		WECHAT_DISPLAY_NAME="$WECHAT_VER_NAME"
	fi

	local check_path="/data/user/${CURRENT_USER_ID}/${wechatPackageName}/files"
	if [ -d "$check_path" ]; then
		WECHAT_UID=$(ls -ld "$check_path" | awk '{print $3}' | grep -oE '[0-9]+$' | while read num; do expr 10000 + "$num"; done)
	else
		WECHAT_UID="未找到 (请检查分身)"
	fi

	WX_VER=$(dumpsys package ${wxPackageName} | grep "versionName" | head -n1 | cut -d'=' -f2)
	X_VER=$(dumpsys package ${xPackageName} | grep "versionName" | head -n1 | cut -d'=' -f2)

	if [ -z "$SELECTED_MODULE" ]; then
		if [ -n "$WX_VER" ]; then SELECTED_MODULE="WechatXposed";
		elif [ -n "$X_VER" ]; then SELECTED_MODULE="X"; fi
	fi
}

do_download() {
	local type=$1 
	mkdir -p "$DOWNLOAD_BASE"
	
	local ver_data=$(echo "${WECHAT_DISPLAY_NAME} (${WECHAT_VER_CODE})" | sed 's/ /%20/g')
	local file_tag=""
	local folder_tag=""

	if [ "$SELECTED_MODULE" = "WechatXposed" ]; then
		if [ "$type" = "core" ]; then folder_tag="${coreDataTag}"; file_tag="wx6_${WX_VER}";
		else folder_tag="${fkzDataTag}"; file_tag="wx6_v${WX_VER}"; fi
	else
		if [ "$type" = "core" ]; then folder_tag="${coreDataTag}"; file_tag="x7_3.0";
		else folder_tag="${fkzDataTag}"; file_tag="x7_v3.0"; fi
	fi

	local url="${repositoryContentLink}/${folder_tag}/${ver_data}/${file_tag}.zip"
	local save_path="${DOWNLOAD_BASE}/${file_tag}.zip"

	msg "$CYAN" "正在下载: $url"
	if wget --version >/dev/null 2>&1; then
		wget -c "$url" -O "$save_path"
	else
		curl -L "$url" -o "$save_path"
	fi

	if [ $? -eq 0 ] && [ -f "$save_path" ]; then
		msg "$GREEN" "下载成功: $save_path"
		return 0
	else
		msg "$RED" "下载失败，请检查网络或版本适配。"
		return 1
	fi
}

do_import_core() {
	if [ $(id -u) -ne 0 ]; then msg "$RED" "需要 Root 权限！"; return; fi
	
	local file_tag=""
	[ "$SELECTED_MODULE" = "WechatXposed" ] && file_tag="wx6_${WX_VER}" || file_tag="x7_3.0"
	local zip_file="${DOWNLOAD_BASE}/${file_tag}.zip"
	local extract_dir="${DOWNLOAD_BASE}/${file_tag}"
	local target_dir="/data/user/${CURRENT_USER_ID}/${wechatPackageName}/files/${file_tag}"

	if [ ! -f "$zip_file" ]; then msg "$RED" "错误：请先执行下载！"; return; fi

	show_progress "解压数据"
	rm -rf "$extract_dir" && unzip -o "$zip_file" -d "$extract_dir" > /dev/null

	show_progress "同步至系统"
	rm -rf "$target_dir" && cp -r "$extract_dir" "$target_dir"
	
	show_progress "修复权限"
	find "$target_dir" -type d -exec chmod 755 {} \;
	find "$target_dir" -type f -exec chmod 644 {} \;
	chown -R ${WECHAT_UID}:${WECHAT_UID} "$target_dir"

	msg "$GREEN" "核心文件导入完成！"
	
	printf "%b是否立即重启微信？(y/n): %b" "$YELLOW" "$NC"
	read choice
	if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
		am force-stop ${wechatPackageName}
		sleep 2
		am start -n ${wechatPackageName}/${wechatUI}
		msg "$GREEN" "微信已尝试重启"
	fi
}

do_import_fkz() {
	if [ $(id -u) -ne 0 ]; then msg "$RED" "需要 Root 权限！"; return; fi

	local file_tag=""
	[ "$SELECTED_MODULE" = "WechatXposed" ] && file_tag="wx6_v${WX_VER}" || file_tag="x7_v3.0"
	local zip_file="${DOWNLOAD_BASE}/${file_tag}.zip"
	local extract_dir="${DOWNLOAD_BASE}/${file_tag}"
	local target_db_dir="/data/user/${CURRENT_USER_ID}/${wechatPackageName}/databases"

	if [ ! -f "$zip_file" ]; then msg "$RED" "错误：请先执行下载！"; return; fi

	show_progress "解压数据库"
	rm -rf "$extract_dir" && unzip -o "$zip_file" -d "$extract_dir" > /dev/null

	mkdir -p "$target_db_dir"
	
	show_progress "导入 FKZ 文件"
	for f in $(find "$extract_dir" -type f -name "FKZ_WX_*"); do
		local fname=$(basename "$f")
		cp "$f" "${target_db_dir}/${fname}"
		chmod 660 "${target_db_dir}/${fname}"
		chown ${WECHAT_UID}:${WECHAT_UID} "${target_db_dir}/${fname}"
	done

	msg "$GREEN" "FKZ_WX_DATA 导入完成！"
}

# --- 脚本逻辑开始 ---

show_agreement

while true; do
	fetch_info
	clear
	printf "%b==========================================%b\n" "$BLUE" "$NC"
	printf "%b       WX 配置自动导入交互版 (LRFP)       %b\n" "$BLUE" "$NC"
	printf "%b==========================================%b\n" "$BLUE" "$NC"
	msg "$CYAN" "当前状态："
	printf "  [用户ID]  %b%s%b (主用户0/双开999)\n" "$YELLOW" "$CURRENT_USER_ID" "$NC"
	printf "  [微  信]  %b%s (%s)%b\n" "$YELLOW" "$WECHAT_DISPLAY_NAME" "$WECHAT_VER_CODE" "$NC"
	printf "  [U I D ]  %b%s%b\n" "$YELLOW" "$WECHAT_UID" "$NC"
	printf "  [模  块]  %b%s%b (微X:%s X:%s)\n" "$GREEN" "${SELECTED_MODULE:-"未检测"}" "$NC" "${WX_VER:-"无"}" "${X_VER:-"无"}"
	printf "%b------------------------------------------%b\n" "$BLUE" "$NC"
	printf "功能菜单：\n"
	printf "  %b1. 刷新信息%b\n" "$CYAN" "$NC"
	printf "  %b2. 切换用户 (0 <-> 999)%b\n" "$CYAN" "$NC"
	[ -n "$WX_VER" ] && [ -n "$X_VER" ] && printf "  %b3. 切换选定模块%b\n" "$CYAN" "$NC"
	
	if [ -n "$WECHAT_VER_NAME" ] && [ -n "$SELECTED_MODULE" ]; then
		printf "  %b4. 下载核心文件%b\n" "$GREEN" "$NC"
		printf "  %b5. 下载 FKZ_WX_DATA%b\n" "$GREEN" "$NC"
		if [ $(id -u) -eq 0 ]; then
			printf "  %b6. 导入核心文件 (需Root)%b\n" "$YELLOW" "$NC"
			printf "  %b7. 导入 FKZ_WX_DATA (需Root)%b\n" "$YELLOW" "$NC"
		fi
	fi
	printf "  %b0. 退出%b\n" "$RED" "$NC"
	printf "%b------------------------------------------%b\n" "$BLUE" "$NC"
	printf "请选择操作: "
	read opt

	case $opt in
		1) continue ;;
		2) [ "$CURRENT_USER_ID" -eq 0 ] && CURRENT_USER_ID=999 || CURRENT_USER_ID=0 ;;
		3) [ "$SELECTED_MODULE" = "WechatXposed" ] && SELECTED_MODULE="X" || SELECTED_MODULE="WechatXposed" ;;
		4) do_download "core"; pause ;;
		5) do_download "fkz"; pause ;;
		6) do_import_core; pause ;;
		7) do_import_fkz; pause ;;
		0) msg "$GREEN" "感谢使用 LRFP 脚本，再见！"; exit 0 ;;
		*) msg "$RED" "无效输入"; sleep 1 ;;
	esac
done