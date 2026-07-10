[ ! -e /etc/fw_env.config ] && exit 0

. /lib/functions/system.sh

case "$(board_name)" in
bananapi,bpi-r2|\
bananapi,bpi-r64|\
unielec,u7623-02)
	[ -z "$(fw_printenv -n ethaddr 2>/dev/null)" ] &&
		fw_setenv ethaddr "$(cat /sys/class/net/eth0/address)"
	;;
bananapi,bpi-r3|\
bananapi,bpi-r3-mini|\
bananapi,bpi-r4-lite)
	[ -z "$(fw_printenv -n ethaddr 2>/dev/null)" ] &&
		fw_setenv ethaddr "$(cat /sys/class/net/eth0/address)"
	[ -z "$(fw_printenv -n eth1addr 2>/dev/null)" ] &&
		fw_setenv eth1addr "$(macaddr_add $(cat /sys/class/net/eth0/address) 1)"
	;;
bananapi,bpi-r4|\
bananapi,bpi-r4-2g5|\
bananapi,bpi-r4-poe)
	local need_reboot=0
	[ -z "$(fw_printenv -n ethaddr 2>/dev/null)" ] &&
		fw_setenv ethaddr "$(cat /sys/class/net/eth0/address)"
	if [ -z "$(fw_printenv -n eth1addr 2>/dev/null)" ]; then
		fw_setenv eth1addr "$(macaddr_add $(cat /sys/class/net/eth0/address) 1)"
		need_reboot=1
	fi
	if [ -z "$(fw_printenv -n eth2addr 2>/dev/null)" ]; then
		fw_setenv eth2addr "$(macaddr_add $(cat /sys/class/net/eth0/address) 5)"
		need_reboot=1
	fi
	[ "$need_reboot" -eq 1 ] && (sleep 3; reboot) &
	;;
esac

exit 0
