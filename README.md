# SMBServ
Quick bash script to setup an smb-server via docker that serves certain files. This is especially useful when having code-execution on a windows-machine to transfer files to the target.

## Usage

The following section will explain the usage of the script, including examples for each parameter.

```bash
Usage: setupsmb.sh [arguments]

-h  ... Help:        Print this help message
-v  ... Verbose:     Print detailed status messages
-fl ... Files-list:  Specify a list of files (specified as a file) that should be served via SMB
-f  ... File:        Specify a single file to be served via SMB
-d  ... Directory:   Specify a single directory to be served via SMB
-sh ... Shell:       Launch a shell on the docker-container once it is setup
```

### Default behavior

Starting script without any arguments, will start the smb-server in a container and host all files of your current working-directory.

```bash
root@kali:~/test# ls
test1  test2  test3
root@kali:~/test# smbserv

#####################
# Simple SMB-Server #
#    By Chr0x6eOs   #
#####################

Github: https://github.com/chr0x6eos

About:
A simple SMB-server running in docker.
By default current directory will be served.

[+] Smb-server (ID: b303f982f672) started!
[+] DONE! :) Container (ID: b303f982f672) is now running and serving...
Your files are available at:
  \\192.168.0.1\share\
  \\127.0.0.1\share\
```

Connecting to the smb-share all three test-files are listed.

```bash
root@kali::~/test# smbclient //127.0.0.1/share/
smb: \> cd test
smb: \test\> dir
  .                                   D        0  Sat Nov  7 14:55:44 2020
  ..                                  D        0  Sat Nov  7 14:56:02 2020
  test3                               N        2  Sat Nov  7 14:55:44 2020
  test1                               N        2  Sat Nov  7 14:55:37 2020
  test2                               N        2  Sat Nov  7 14:55:40 2020

                197118500 blocks of size 1024. 149582596 blocks available
```
### Hosting a list of files [-fl]

Starting the script with the `-fl` flag, a txt-file can be used to specify all files to be hosted on the smb-server.

```bash
root@kali:~/test# ls
file1  file2  file3  files.txt
root@kali:~/test# cat files.txt
/root/test/file1
/root/test/file3
/usr/share/webshells/aspx/cmdasp.aspx
```
In this case the files `/root/test/file1`, `/root/test/file3` and `/usr/share/webshells/aspx/cmdasp.aspx` will be hosted via smb.
```bash
root@kali:~/test# smbserv -v -fl files.txt

#####################
# Simple SMB-Server #
#    By Chr0x6eOs   #
#####################

Github: https://github.com/chr0x6eos

About:
A simple SMB-server running in docker.
By default current directory will be served.

[*] Verbosity set!
[*] Loading files from config-file: files.txt...
[+] Loaded following files to serve:
/root/test/file1
/root/test/file3
/usr/share/webshells/aspx/cmdasp.aspx
[+] Smb-server (ID: d8eb4acf6ea3) started!
[*] Copying /root/test/file1 to d8eb4acf6ea3:/mnt/smb/ ...
[*] Copying /root/test/file3 to d8eb4acf6ea3:/mnt/smb/ ...
[*] Copying /usr/share/webshells/aspx/cmdasp.aspx to d8eb4acf6ea3:/mnt/smb/ ...
[+] DONE! :) Container (ID: d8eb4acf6ea3) is now running and serving...
Your files are available at:
  \\192.168.0.1\share\
  \\127.0.0.1\share\
```
Connecting to the smb-share all three files that were in the files.txt-file are listed.

```bash
root@kali:~/test# smbclient //127.0.0.1/share
smb: \> dir
  .                                   D        0  Sat Nov  7 15:07:43 2020
  ..                                  D        0  Sat Nov  7 15:07:42 2020
  cmdasp.aspx                         N     1400  Wed Jul 17 13:45:23 2019
  file1                               N        2  Sat Nov  7 15:01:35 2020
  file3                               N        2  Sat Nov  7 15:01:41 2020

                197118500 blocks of size 1024. 149545084 blocks available
```
### Hosting a file [-f]

Starting the script with the `-f` flag, a file can be specified to be hosted on the smb-server.

```bash
root@kali:~# smbserv -f /usr/share/windows-binaries/nc.exe

#####################
# Simple SMB-Server #
#    By Chr0x6eOs   #
#####################

Github: https://github.com/chr0x6eos

About:
A simple SMB-server running in docker.
By default current directory will be served.

[+] Smb-server (ID: d3f1a3141192) started!
[+] DONE! :) Container (ID: d3f1a3141192) is now running and serving...
Your files are available at:
  \\192.168.0.1\share\
  \\127.0.0.1\share\
```

Connecting to the smb-share the previously specified file is listed.

```bash
root@kali:~# smbclient //127.0.0.1/share
smb: \> dir
  .                                   D        0  Sat Nov  7 15:10:49 2020
  ..                                  D        0  Sat Nov  7 15:10:49 2020
  nc.exe                              N    59392  Wed Jul 17 11:31:43 2019

  197118500 blocks of size 1024. 149538156 blocks available
```

### Serving a directory [-d]

Starting the script with the `-d` flag, a directory can be specified to be hosted on the smb-server.

```bash
root@kali:~# smbserv -d /usr/share/windows-binaries/

#####################
# Simple SMB-Server #
#    By Chr0x6eOs   #
#####################

Github: https://github.com/chr0x6eos

About:
A simple SMB-server running in docker.
By default current directory will be served.

[+] The directory /usr/share/windows-binaries/ will be served via SMB!
[+] Smb-server (ID: 96cc556ff090) started!
[+] DONE! :) Container (ID: 96cc556ff090) is now running and serving...
Your files are available at:
  \\192.168.0.1\share\
  \\127.0.0.1\share\
```

Connecting to the smb-share the specified directory and it's content is listed.

```bash
root@kali:~# smbclient //127.0.0.1/share
smb: \> dir
  .                                   D        0  Sat Nov  7 15:30:53 2020
  ..                                  D        0  Sat Nov  7 15:30:53 2020
  windows-binaries                    D        0  Fri Nov  6 16:00:52 2020

                197118500 blocks of size 1024. 149533584 blocks available
smb: \windows-binaries\> dir
  .                                   D        0  Fri Nov  6 16:00:52 2020
  ..                                  D        0  Sat Nov  7 15:30:53 2020
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

                197118500 blocks of size 1024. 149533580 blocks available
```

### Launching a shell in the docker-container [-sh]

Starting the script with the `-sh` flag, a bash-shell will be launched once the docker-container is setup.

```bash
root@kali:~# smbserv -f /usr/share/windows-binaries/nc64.exe -sh

#####################
# Simple SMB-Server #
#    By Chr0x6eOs   #
#####################

Github: https://github.com/chr0x6eos

About:
A simple SMB-server running in docker.
By default current directory will be served.

[+] The file /usr/share/windows-binaries/nc64.exe will be served via SMB!
[+] Smb-server (ID: 9862f2c83edd) started!
[+] DONE! :) Container (ID: 9862f2c83edd) is now running and serving...
[+] Launching bash-shell in docker-container...

bash-5.0# whoami && hostname
root
f66c916b6dce
bash-5.0# ls /mnt/smb/
nc64.exe
```

## Requirements

The [dperson/samba docker image](https://github.com/dperson/samba) is required.
