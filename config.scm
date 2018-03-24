;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.

(use-modules
 (gnu)
 (guix gexp)
 (gnu services shepherd)
 (guix packages)
 ;; (guix licenses)
 (guix build-system trivial)
 (gnu packages guile))

(use-service-modules networking ssh)
(use-package-modules screen ssh python-web)

(define-public fetch-ssh-key-aws
  (let ((script-name "aws-fetch-ssh-key"))
    (package
      (name script-name)
      (version "0.1")
      (source (local-file (string-append (dirname (current-filename))
					 "/" script-name)))
      (build-system trivial-build-system)
      (arguments
       `(#:modules ((guix build utils))
	 #:builder
	 (begin
	   (use-modules (guix build utils))
	   (let* ((bin-dir  (string-append %output "/bin"))
		  (bin-file (string-append bin-dir "/" ,script-name))
		  (guile-bin (string-append (assoc-ref %build-inputs "guile")
					    "/bin")))
	     (mkdir-p bin-dir)
	     (copy-file (assoc-ref %build-inputs "source") bin-file)
	     (patch-shebang bin-file (list guile-bin))
	     (chmod bin-file #o555)))))
      (inputs `(("guile" ,guile-2.2)))
      (home-page #f)
      (synopsis "A simple AWS EC2 ssh key fetcher")
      (description "fetch-ssh-key.scm is a simple tool that fetches the
ssh public key from instance metadata, assuming you're running on
AWS EC2.")
      (license #f))))

;; this should really be an extension of the openssh service
(define aws-pubkey-service-type
  (shepherd-service-type
   'aws-pubkey
   (lambda (config)
     (shepherd-service
      (documentation "Initialize alyssas public key.")
      (requirement '(networking))
      (provision '(aws-pubkey))
      (start
	 #~(lambda _
	     (system* "aws-fetch-ssh-key")))
      (respawn? #f)))))

(define (aws-pubkey-service)
  "Return a service that sets Alyssa public ssh key to the one
provided in AWS meta-data."
  (service aws-pubkey-service-type '()))

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
  (packages (cons* screen openssh awscli fetch-ssh-key-aws %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (dhcp-client-service)
		   (aws-pubkey-service)
                   (service openssh-service-type
                            (openssh-configuration
			     (port-number 22)))
                   %base-services)))
