## Introduction

Flash Writer is a tool used to flash binaries to the on-board memory. This application 
note provides instructions on how to use flash writer tool for flashing. Flash 
writer script will use USB DFU to boot the board and then flash the binaries to 
on board memory. Tool also supports flashing multiple boards via DFU simultaneously.
It can be used for Sitara MPU devices such as AM64x, AM62x, AM62A.

## Requirements

* Board to be flashed
* Linux or Windows Development PC that can access serial console.
* Type C USB cable (depends on board)
* [Python][1] (3.10+)
* [DFU-Util][2] installed on host (0.11+)
* USB hub to connect multiple boards (Optional)
* UART to read the logs from the EVM (Optional)

## Flow of flashing

* Host PC is connected to boards via USB Type C (or other depending on board)
* After script is run, it will detect the devices connected to host. Script 
  will send the bootloader binaries ( tiboot3.bin, tispl.bin and u-boot.img ) 
  from host PC to boards for USB DFU boot.
* After the boards are booted, Script will now send uEnv.txt file from host PC 
  to boards.
* Environment variables on boards is set using uEnv.txt and boards is now ready 
  for flashing. Script can now flash files from host PC to boards.

## Directory Structure
```
.
├── bin
│   ├── am62axx-evm
│   │   ├── gp
│   │   ├── hs
│   │   └── hsfs
│   ├── am62xx-evm
│   │   ├── gp
│   │   ├── hs
│   │   └── hsfs
│   └── am64xx-evm
│       ├── gp
│       ├── hs
│       └── hsfs
├── logs
├── src
│   ├── constants.py
│   ├── flash.py
│   ├── logger.py
│   └── parse.py
├── .gitignore
├── dfu_flash.py
├── LICENSE
└── README.md
```

* bin - Contains boot binaries used to boot the board via USB DFU, also config 
  files for GP, HS and HS-SE.
* src - other required python modules for tool. 
* dfu_flash.py - main python script that is to be run.
* logs - Contains saved logs of flash script.

## Get DFU-Util on Host PC

### Linux

* Install dfu-util

```
sudo apt-get install dfu-util
```

### Windows

* Download the [dfu-util-0.9-win64.zip][3] file from the dfu-util release site 
  to get the executable files for dfu-util. Place them in a directory 
  ex. C:\Program Files\dfu-util and then "edit the environment variables" to add 
  this path.

* Download Zadig installer from the [Zadig website][4].

* Put the device in DFU mode. Then run the Zadig_2.2.exe file (or whatever version 
  you downloaded).

* In the item that's highlighted, select libusbK using the tiny arrows. Then click 
  the Install Driver button. For more information about libusbK, see their wiki.

## Steps to perform flashing

### Building Bootloader Binaries for USB DFU boot (custom board)

* For flashing and using the script, one need to override the bootcmd command to 
  receive the environment variable text file after DFU boot and flash the 
  binaries/images.

* DFU boot binaries for TI boards are already present in bin directory. 
  For flashing to custom board custom board(s), generate the boot binaries 
  and place them inside the /bin/<your board>/<type> folder.

* Following change needs to be done to a53 defconfig file in uboot. Ex. am62x_evm_a53_defconfig/
  am64x_evm_a53_defconfig/am62ax_evm_a53_defconfig file are located at path.

```
<U-boot source>/configs/
```

* Add or update the CONFIG_BOOTCOMMAND

```
CONFIG_BOOTCOMMAND="setenv dfu_alt_info_flashenv uEnv.txt ram 0x82000000 0x10000000; setenv dfu_alt_info ${dfu_alt_info_flashenv}; dfu 0 ram 0; env import -t ${loadaddr} $filesize; run user_commands;"
```

* It will enable script to send uEnv.txt file, import the environment variables 
  from the uEnv.txt file and run user_commands after DFU boot. The user_commands 
  variable is defined in the uEnv.txt file and the value assigned will be based 
  on the flashing memory.

* If you have saved environment variables in your board (or saved during earlier boot), 
  u-boot takes the environment variables which will override the bootcmd which 
  will cause the flashing to fail. To make u-boot not to take the saved environment 
  variables you can do following changes in same config file.

```
Add below line.
CONFIG_ENV_IS_NOWHERE=y
 
Remove below line if present
CONFIG_ENV_IS_IN_MMC=y
 
Also add below line to decrease boot delay to 0
CONFIG_BOOTDELAY=0
```

* Now build u-boot. You can also use top level Makefile in SDK by running 
  following commands on the terminal from the top-level of the SDK.

```
$ make u-boot_clean
$ make u-boot
```
* DFU boot binaries are required for flashing. These DFU binaries once booted on 
  the board listens for the images to be flashed over USB DFU. Go to the 
  respective directory `bin/${device}/${type}` and copy paste the DFU boot 
  binaries (`tiboot3.bin`, `tispl.bin`, `u-boot.img`).

_Note: The prebuilt DFU boot binaries are provided for each device and type. 
 These can be used for TI boards as it is. For custom boards, one may need to 
 generate custom binaries. Create a custom device folder in the bin directory 
 and use that as the argument for --device._

### Connections

* Power off the EVM and set up the boot mode switches to boot from DFU.

Ex.
```
AM64X EVM SW2[1:8] = 11001010 and SW3[1:8] = 00000000
AM62X EVM SW1[1:8] = 11001010 and SW2[1:8] = 00000000
```

* Connect board to PC via USB Type C (depend on board).

* Power on the board.

* Optionally you can also connect host pc to board via UART to read the console logs.

### Preparing the Flash Configuration file 
- Go to the directory `bin/${device}/${type}` according to the device and the type.
- Edit the configuration file `flash-files.cfg` to list the commands for each of the files to be flashed.
- For each config line, prepare the following three arguments separated by space:
    - Edit the path using `--file=${path}`
    - Edit the operation using `--operation=${flash-nor|flash-emmc|flash-nand}`. 
	- The operations `flash-nor` is used to flash the SPI NOR.
    - The operations `flash-nand` is used to flash the SPI NAND.
    - The operations `flash-emmc` is used to flash the eMMC. 
    - Edit the offset using `--offset=${hex_address}`.

_Note: A default configuration file for Processor SDK images is provided for each device and type._

### Running the Python script
* Change the working directory in terminal to this project directory.
* Run the command
    ```bash
    ${PYTHON} dfu_flash.py [ -d device ] [ -t type ] [ -c cfg ] [ -r reset] 
    ```
    where ${PYTHON} evalutes to specific python command according to the OS. 
    In most cases, this should be `python` for Windows while `python3` for Linux.

* Options
	- -d | --device : Argument to identify the device (Mandatory).
	- -t | --type   : Argument to identify the type of the device gp,hs,hsfs (Mandatory).
	- -c | --cfg    : Argument to get the path of the custom configuration file.
	- -r | --reset  : Argument to reset the board after flashing.

### Flashing to eMMC

* eMMC needs to be partitioned (2 partitions) before running the script.  
  A reset is required for the partition table to be visible. Otherwise, you 
  will get an error during flashing.
* The eMMC device typically ships without any partition table. Make use of the 
  GPT support in U-Boot to write a GPT partition table to eMMC. In this case we 
  need to use the uuidgen program on the host to create the UUIDs used for the 
  disk and each partition.Enter below commands in Linux host to generate uuid

```
$ uuidgen
  first_uuid
$ uuidgen
  second_uuid
```

* Flash default wic image to SD Card. Boot the board using the SD Card. Press any 
  key to enter the U-Boot prompt. Enter following commands in U-Boot prompt.

```
# setenv uuid_gpt_disk first_uuid
# setenv uuid_gpt_rootfs second_uuid
# gpt write <device num> ${partitions} (device num can be found using mmclist)
```

* After the eMMC is partitioned, you can now flash to eMMC without errors. 
  (After doing all the pre-steps as mentioned in previous sections)

* In your config file put operation as --operation=flash-emmc. Run the script 
  in Linux or Windows host.

_Note:For flashing filesystem use an ext4 file and name it as rootfs.ext4 and 
 specify the path in cfg file._

### Flash to SPI NOR

* In your config file put operation as --operation=flash-nor.
* Do follow all the pre-steps as mentioned in previous sections for flashing.
* Run the script in Linux or Windows host.

### Flash to SPI NAND

* In your config file put operation as --operation=flash-nand.
* Do follow all the pre-steps as mentioned in previous sections for flashing.
* Run the script in Linux or Windows host. 

_Note: Flash to QSPI NAND on AM62x is tested only on GP. User needs to change 
 the boot binaries which supports QSPI NAND flashing on am62x. This is tested 
 on AM62x GP and binaries for same can be found in <bin/am62xx-evm/gp/qspi_nand_binaries>._

[1]: https://www.python.org/downloads/
[2]: https://dfu-util.sourceforge.net/releases/
[3]: dfu-util.sourceforge.net/releases/dfu-util-0.9-win64.zip
[4]: https://zadig.akeo.ie/
