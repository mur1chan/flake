{ config, pkgs, ... }:

{
  boot.initrd.luks.devices."luks-a07517ba-7b5b-420d-95d7-747bc1c67ec2".device = "/dev/nvme0n1p3";
}

