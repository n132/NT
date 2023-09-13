# Details



# Prepare Tools
- Run following commands at `fs` diretory 
```bash
wget https://github.com/hugsy/gdb-static/raw/master/gdbserver-7.10.1-x64 -O gdbserver
```
- (Optional): You don't need socat, but if you got some error you can use it to debug
```
wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat -O socat
```

- Create `backdoor.sh` at `fs` diretory

```bash
# RHOST=10.0.2.2
# RPORT=7777
while true
do
/gdbserver :9999 --attach `pidof <target_program>`
# /socat tcp-connect:$RHOST:$RPORT exec:/bin/sh,pty,stderr,setsid,sigint,sane
sleep 1
done
``` 

# Modify Init in FileSys
- Insert following commands to `Init` 
```bash
# chmod +x /socat
chmod +x /gdbserver
chmod +x /backdoor.sh
/backdoor.sh 2>/dev/null&
```

# Repack the FileSys
You can use your packing script.
Mine:
```bash
#x.sh
cd ./fs &&\
find . | cpio -o --format=newc > ../rootfs.cpio &&\
cd .. &&\
mv ./rootfs.cpio ./initramfs.cpio &&\
rm -rf ./initramfs.cpio.gz &&\
gzip  ./initramfs.cpio &&\
echo "[+] Filesystem - Done" &&\
./run.sh
```

# Modify Docker Compose Configuration
- Expose port 9999 to enable host debugging
```
version: "3"
services:
  sina:
    build: .
    ports:
      - "30000:30000"
      - "9999:9999"
    expose:
      - "30000"
      - "9999"

```

