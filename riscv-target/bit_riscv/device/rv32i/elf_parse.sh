#!/bin/bash

riscv64-unknown-elf-objcopy -O binary -j .text.init $1 $1.bin.text
xxd -e -c 4 $1.bin.text | awk '{print $2}' > $1.mem.text

riscv64-unknown-elf-objcopy -O binary -j .data $1 $1.bin.data
xxd -e -c 4 $1.bin.data | awk '{print $2}' > $1.mem.data

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


