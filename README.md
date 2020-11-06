# SMBServ
Quick bash script to setup an smb-server via docker

## Usage
Starting script without any args will start a docker-instance running a smb-server and will host all files in /usr/share/windows-binaries by default.
```bash
bash setupsmb.sh
bash-5.0# ls /mnt/smb/
enumplus       fgdump         klogger.exe    nbtenum        nc64.exe       radmin.exe     wget.exe
exe2bat.exe    fport          mbenum         nc.exe         plink.exe      vncviewer.exe  whoami.exe
```

```bash
smbclient //127.0.0.1/share
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> dir
  .                                   D        0  Fri Nov  6 16:56:38 2020
  ..                                  D        0  Fri Nov  6 16:56:36 2020
  vncviewer.exe                       N   364544  Wed Jul 17 11:31:43 2019
  plink.exe                           N   311296  Wed Jul 17 11:31:43 2019
  klogger.exe                         N    23552  Wed Jul 17 11:31:43 2019
  radmin.exe                          N   704512  Wed Jul 17 11:31:43 2019
  enumplus                            D        0  Fri May 15 15:06:00 2020
  mbenum                              D        0  Fri May 15 15:06:00 2020
  fgdump                              D        0  Fri May 15 15:06:00 2020
  wget.exe                            N   308736  Wed Jul 17 11:31:43 2019
  nbtenum                             D        0  Fri May 15 15:06:00 2020
  fport                               D        0  Fri May 15 15:06:00 2020
  whoami.exe                          N    66560  Wed Jul 17 11:31:43 2019
  nc.exe                              N    59392  Wed Jul 17 11:31:43 2019
  nc64.exe                            N    45272  Fri Oct  2 20:53:08 2020
  exe2bat.exe                         N    53248  Wed Jul 17 11:31:43 2019

                197118500 blocks of size 1024. 151458064 blocks available
smb: \>
```

Starting the script with arguments, a txt-file can be used to specify all files that should be hosted on the smb-server.
```bash
cat files.txt 
/tmp/file1
/tmp/file2
/usr/share/webshells/aspx/cmdasp.aspx
```
This file can now simply be supplies as an argument:
```bash
bash setupsmb.sh files.txt
bash-5.0# ls /mnt/smb/
cmdasp.aspx    fgdump         fport          nbtenum        plink.exe      wget.exe
enumplus       file1          klogger.exe    nc.exe         radmin.exe     whoami.exe
exe2bat.exe    file2          mbenum         nc64.exe       vncviewer.exe
```
The files in `/usr/share/windows-binaries` are shared by default.

```bash
smbclient //127.0.0.1/share/
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> dir
  .                                   D        0  Fri Nov  6 17:00:42 2020
  ..                                  D        0  Fri Nov  6 17:00:39 2020
  cmdasp.aspx                         N     1400  Wed Jul 17 13:45:23 2019
  vncviewer.exe                       N   364544  Wed Jul 17 11:31:43 2019
  plink.exe                           N   311296  Wed Jul 17 11:31:43 2019
  klogger.exe                         N    23552  Wed Jul 17 11:31:43 2019
  radmin.exe                          N   704512  Wed Jul 17 11:31:43 2019
  enumplus                            D        0  Fri May 15 15:06:00 2020
  mbenum                              D        0  Fri May 15 15:06:00 2020
  file1                               N       10  Fri Nov  6 16:59:14 2020
  file2                               N        5  Fri Nov  6 16:59:03 2020
  fgdump                              D        0  Fri May 15 15:06:00 2020
  wget.exe                            N   308736  Wed Jul 17 11:31:43 2019
  nbtenum                             D        0  Fri May 15 15:06:00 2020
  fport                               D        0  Fri May 15 15:06:00 2020
  whoami.exe                          N    66560  Wed Jul 17 11:31:43 2019
  nc.exe                              N    59392  Wed Jul 17 11:31:43 2019
  nc64.exe                            N    45272  Fri Oct  2 20:53:08 2020
  exe2bat.exe                         N    53248  Wed Jul 17 11:31:43 2019

                197118500 blocks of size 1024. 151427612 blocks available
smb: \>
```
## Requirements
The [dperson/samba docker image](https://github.com/dperson/samba) is required.
