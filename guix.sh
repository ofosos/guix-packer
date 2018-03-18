# as root:

set -e

wget https://alpha.gnu.org/gnu/guix/guix-binary-0.14.0.x86_64-linux.tar.xz
tar --warning=no-timestamp -xf      guix-binary-0.14.0.x86_64-linux.tar.xz
mv var/guix /var/ && mv gnu /
ln -sf /var/guix/profiles/per-user/root/guix-profile          ~root/.guix-profile
groupadd --system guixbuild
for i in `seq -w 1 10`;   do     useradd -g guixbuild -G guixbuild                       -d /var/empty -s `which nologin`                -c "Guix build user $i" --system                guixbuilder$i;   done
cp ~root/.guix-profile/lib/systemd/system/guix-daemon.service         /etc/systemd/system/
systemctl start guix-daemon
mkdir -p /usr/local/bin
ln -s /var/guix/profiles/per-user/root/guix-profile/bin/guix /usr/local/bin/guix
guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub

sfdisk /dev/xvdf <<END
label: dos
label-id: 0xb991d10f
device: /dev/xvdf
unit: sectors

/dev/xvdf1 : start=        2048, size=    16775168, type=83, bootable
END

mkfs.ext4 -L my-root /dev/xvdf1
mount /dev/xvdf1 /mnt

bash /home/ubuntu/cow-store.sh

guix system init /home/ubuntu/config.scm /mnt

