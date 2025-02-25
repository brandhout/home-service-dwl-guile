(define-module (dwl-guile packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages freedesktop)
  #:use-module (dwl-guile patches)
  #:export (make-dwl-package))

;; Create a new package definition based on `dwl-package`.
;; This procedure also allows us to modify the package further,
;; e.g. by adding the guile configuration patch, and any other user patches.
(define (make-dwl-package dwl-package patches)
  (package
   (inherit dwl-package)
   (name "dwl-guile")
   (version "0.2.1")
   (inputs
    `(("guile-3.0" ,guile-3.0)
      ("wlroots" ,wlroots)
      ,@(assoc-remove! (package-inputs dwl-package) "wlroots")))
   (source
    (origin
     (inherit (package-source dwl-package))
     (uri (git-reference
           (url "https://github.com/djpohly/dwl")
           (commit (string-append "v" version))))
     (file-name (git-file-name (package-name dwl-package) version))
     (sha256
      (base32
       "0js8xjc2rx1ml6s58s90jrak5n7vh3kj5na2j4yy3qy0cb501xcm"))
     (patch-flags '("-p1" "-F3"))
     (patches
      (cons %patch-base patches))))
   (arguments
    (substitute-keyword-arguments
     (package-arguments dwl-package)
     ((#:phases phases)
      `(modify-phases
        ,phases
        ;; name the compiled executable "dwl-guile" so that
        ;; we can differentiate between regular dwl and dwl-guile.
        (replace
         'install
         (lambda*
             (#:key inputs outputs #:allow-other-keys)
           (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
             (install-file "dwl" bin)
             (rename-file (string-append bin "/dwl")
                          (string-append bin "/dwl-guile"))
             #t)))))))))
