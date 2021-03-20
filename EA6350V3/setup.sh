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

#KPATCHES=(configs/patches/9991-ipq40xx-improve_cpu_and_nand_clock.patch)
#for PATCH in "${KPATCHES[*]}"
#do
#	if [[ -f "${PATCH}" ]]
#	then
#		cp "${PATCH}" "${WRT_DIR}/target/linux/ipq40xx/patches-5.4/"
#	fi
#done
FILES=(configs/feeds.conf.default)
for FILE in "${FILES[*]}"
do
	if [[ -f "${FILE}" ]]
	then
		cp "${FILE}" "${WRT_DIR}"
	fi
done
CONFIGS=(configs/unbound)
for CFG in "${CONFIGS[*]}"
do
	if [[ ! -d "${WRT_DIR}/files/etc/config" ]]
	then
		mkdir -p "${WRT_DIR}/files/etc/config"
	fi
	if [[ -f "${CFG}" ]]
	then
		cp "${CFG}" "${WRT_DIR}/files/etc/config/"
	fi
done
cd "${WRT_DIR}"
"${WRT_DIR}/scripts/feeds" update -a
"${WRT_DIR}/scripts/feeds" install -a
echo "Done!"
