# Flash via Ethernet

Ethernet is used for peripheral boot and then to flash the files to on-board memory 
using DHCP server and TFTP.

## Important files

Environment variable text files are located at

```
/Ethernet_flash/bin/<machine>
```

## Requirements on host PC

Set up Ethernet boot. For details of Ethernet boot refer SDK docs section

```
Foundational_Components/U-Boot/UG-Network-K3.
```

## Building bootloader binaries for flashing and Ethernet Boot

First override the bootcmd command to send the environment variable text file.
It needs to be done in a53_defconfig file located at following path in U-boot source.

```
/configs/
```

```
CONFIG_BOOTCOMMAND="dhcp <name of your uEnv.txt file>; env import -t ${loadaddr} $filesize; run user_commands;"
```

Additionallly, these changes can also be done:

```
To make sure board doesnt use saved environment variables after boot.       
                                                                           
Add below line.
CONFIG_ENV_IS_NOWHERE=y

Remove below line.                                                      
CONFIG_ENV_IS_IN_MMC=y

To decrease boot delay to 0
CONFIG_BOOTDELAY=0
```

Generate the bootloader images for Ethernet boot using top-level makefile in SDK 
or using make in U-boot source.

## Getting ready to flash

* Make sure that the bootloader binaries for flashing and Ethernet boot is built 
for the EVM and place them in the TFTP directory.

* Place the files to be flashed to TFTP directory.

* Make sure to set up Ethernet boot.

## Environment variable text file for flashing

* It will be used to set environment variables in U-Boot for flashing. Create a 
new uEnv.txt file by using existing uEnv files as reference.

* It assigns U-Boot commands to run the list of commands specified by user to 
variable *user_commands*. Ex. for transfer to eMMC following commands are assigned 
to variable user_commands.

* To add new U-Boot commands, assign them to a variable in text file. For example

```
user_commands=echo Flashing_on_emmc; run command_list; 
```

* Now add the variables to *command_list* to run them. By this way you can add 
or remove commands as per your choice.

```
command_list=run example_command1; run example_command2;
```

* Also make sure to replace file names in text files with the actual names of 
files to be flashed. Ex. to transfer tiboot3.bin over TFTP to EVM

```
#Enter your filename in place of tiboot3.bin
cmd_3=dhcp tiboot3.bin
```

## Flashing

### Flash to eMMC

Use uEnv_ethernet_emmc_*.txt file as reference. Also update the commands for 
flashing as needed by referring SDK docs.

### Flash to SPI NOR

Use uEnv_ethernet_ospi-nor_*.txt file as reference. Also update the commands for 
flashing as needed by referring SDK docs.

### Flash to SPI NAND

Use uEnv_ethernet_ospi-nand_*.txt file as reference. Also update the commands for 
flashing as needed by referring SDK docs.

### Flash to GPMC NAND

Use uEnv_ethernet_gpmc-nand_*.txt file as reference. Also update the commands 
for flashing as needed by referring SDK docs.
