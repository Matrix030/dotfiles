

As mentioned by u\teohhanhui, check out the partitioning cheatsheet for a general (but detailed enough) guide: https://github.com/AsahiLinux/docs/wiki/Partitioning-cheatsheet

That said, considering you've provided the output I need, I'll oblige.

First, run diskutil list again and verify that your disk identifiers are exactly the same. Then, take a look at disk0, your Mac's internal drive:

    The Apple_APFS_ISC and Apple_APFS_Recovery partitions are special containers that should be treated as critical firmware. Every Apple Silicon Mac has them on the internal drive as the first and last partitions respectively. Leave them alone.

    The APFS container on disk0s2 (expanded as disk4) is your main macOS container. We can resize it after deleting Asahi Linux since it's located before (not after) the Asahi partitions.

    These partitions belong to Asahi Linux and should be deleted:

        The stub APFS container on disk0s3 (expanded as disk2). This hosts the fake macOS installation that makes the system recognize Asahi Linux. You can tell it's a stub (not real) because the container is way too small to host a real macOS installation, and the Asahi installer always hardcodes the stub container to be 2.5 GB large. It looks like you deleted the volume group inside there but didn't address the remaining things yet.

        The EFI partition on disk0s4. Unlike Intel-based Macs, Apple Silicon Macs don't use EFI. Asahi uses it to help make Apple Silicon look more like a regular ARM64 computer to Linux as it starts up.

        The Linux boot partition on disk0s5. Its small size and the fact it's using a Linux filesystem (probably ext4) gives it away.

        The Linux root partition on disk0s6. This is where the bulk of the Asahi Linux installation resides.

Now, to actually delete Asahi Linux: run diskutil list again and verify that your disk identifiers are exactly the same, then complete these steps:

    Delete the APFS stub container: diskutil apfs deletecontainer disk0s3

    Delete the EFI partition: diskutil erasevolume free free disk0s4

    Delete the Linux boot partition: diskutil erasevolume free free disk0s5

    Delete the Linux root partition: diskutil erasevolume free free disk0s6

    If you aren't booted from macOS (which I think you are), make sure your Data volume is unlocked if you have FileVault enabled: diskutil apfs unlock "Macintosh HD - Data"

    Resize your macOS container to full size: diskutil apfs resizeContainer disk0s2 0


