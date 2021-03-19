#!/usr/bin/env bash
set -e # Stop on errors
cd "$(dirname "${0}")" # Make sure we are in good dir
red() {
	echo -e "\e[91m${@}\e[m"
}
if [[ -z "${1}" ]]
then
	red "Please specify OpenWRT sources dir!"
	exit 1
fi
WRT_DIR="${1}"
if [[ ! -d "${WRT_DIR}" ]]
then
	red "${WRT_DIR} not found!"
	exit 1
fi

if [[ ! -f "${WRT_DIR}/feeds.conf.default" ]]
then
	red "${WRT_DIR} is not a valid OpenWRT source!"
fi

KPATCHES=(configs/patches/9991-ipq40xx-improve_cpu_and_nand_clock.patch)
for PATCH in "${KPATCHES[*]}"
do
	if [[ -f "${PATCH}" ]]
	then
		cp "${PATCH}" "${WRT_DIR}/target/linux/ipq40xx/patches-5.4/"
	fi
done

