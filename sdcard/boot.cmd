cat << 'EOF' > boot.cmd
# AM625 NFS Boot Script

setenv serverip 10.42.0.1
setenv ipaddr 10.42.0.10
setenv gatewayip 10.42.0.1
setenv netmask 255.255.255.0
setenv hostname am625-sk
setenv device eth0
setenv autoconf off

setenv root_dir /home/aessam/repos/ti-processor-sdk-linux-rt-am62xx-evm-10.00.07.04/targetNFS
setenv bootfile boot/Image
setenv fdtfile boot/dtb/ti/k3-am625-sk.dtb

setenv loadaddr 0x82000000
setenv fdtaddr 0x88000000

setenv nfs_bootfile 'nfs ${loadaddr} ${serverip}:${root_dir}/${bootfile}'
setenv nfs_fdtfile 'nfs ${fdtaddr} ${serverip}:${root_dir}/${fdtfile}'
setenv netargs 'setenv bootargs root=/dev/nfs rw nfsroot=${serverip}:${root_dir},nfsvers=3,tcp ip=${ipaddr}:${serverip}:${gatewayip}:${netmask}:${hostname}:${device}:${autoconf} console=ttyS2,115200n8'

setenv bootcmd 'run nfs_bootfile; run nfs_fdtfile; run netargs; booti ${loadaddr} - ${fdtaddr}'

run bootcmd
EOF

