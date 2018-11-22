#!/bin/bash

riscv64-unknown-elf-objcopy -O binary $1 $1.bin
xxd -e -c 4 $1.bin | awk '{print $2}' > $1.hex
# Print out mem file in little-endian
xxd -b -c 4 $1.bin | awk '{print $5$4$3$2}' > $1.mem

readelf -S $1 > $1.sections

grep ".text.init" $1.sections | awk '{print "0x"$5}' > $1.text.start

grep ".data" $1.sections | awk '{print "0x"$5}' > $1.data.start

grep ".data" $1.sections | awk '{print "0x"$7}' > $1.data.size

grep "<begin_signature>:" $1.objdump | awk '{print "0x"$1}' > $1.signature.start

declare -i data_start=$(cat $1.data.start)
declare -i data_size=$(cat $1.data.size)
declare -i signature_start=$(cat $1.signature.start)

echo $data_start
echo $data_size
echo $signature_start

signature_size=$(($data_size-$(($signature_start - $data_start))))
echo $signature_size > $1.signature.size
