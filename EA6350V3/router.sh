#!/bin/sh
set -e
PACKAGES="ca-bundle luci-lib-ipkg luci-compat relayd luci-proto-relay luci-app-unbound luci-app-wol luci-app-advanced-reboot libustream-openssl"
install_packages() {
	echo -e "\e[96mInstalling packages...\e[m"
	opkg update
	for PACK in ${PACKAGES}
	do
		opkg install "${PACK}"
	done
}
install_themes() {
	echo -e "\e[96mSetting up themes...\e[m"
	URLS="https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.2.5/luci-theme-argon_2.2.5-20200914_all.ipk https://github.com/jerrykuku/luci-app-argon-config/releases/download/v0.8-beta/luci-app-argon-config_0.8-beta_all.ipk"
	for URL in ${URLS}
	do
		if [[ -f "temp.ipk" ]]
		then
			rm -rf "temp.ipk"
		fi
		wget --no-check-certificate "${URL}" -O temp.ipk
		opkg install temp.ipk
	done
}

install_packages
install_themes
