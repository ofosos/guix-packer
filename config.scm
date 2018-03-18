;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.

(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules screen ssh)

(operating-system
  (host-name "cdr")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  ;; Assuming /dev/sdX is the target hard disk, and "my-root" is
  ;; the label of the target root file system.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/xvdf")))
  (file-systems (cons (file-system
                        (device "my-root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons (user-account
                (name "alyssa")
                (comment "Alyssa P. Hacker")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/alyssa"))
               %base-user-accounts))

  (sudoers-file (local-file "/home/ubuntu/sudoers"))

  ;; Globally-installed packages.
  (packages (cons* screen openssh %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (dhcp-client-service)
                   (service openssh-service-type
                            (openssh-configuration
			     (port-number 22)
			     (authorized-keys
			      `(("alyssa" ,(local-file "/home/ubuntu/authorized_keys"))))))
                   %base-services)))
