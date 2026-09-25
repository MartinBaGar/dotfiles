;;; init.el --- Bootstrapper -*- lexical-binding: t; -*-

(setq load-prefer-newer t)

;; --- Elpaca bootstrap -----------------------------------------------
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                       :ref nil :depth 1 :inherit ignore
                       :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                       :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; use-package support
(elpaca elpaca-use-package
        (elpaca-use-package-mode))

(use-package compat :ensure (:wait t))
;; --- End Elpaca bootstrap ---------------------------------------------

;; Pre-authorize the one `eval' dir-local form used in lisp/.dir-locals.el
(add-to-list 'safe-local-eval-forms
             '(add-hook 'after-save-hook #'org-babel-tangle nil t))

;; Redirect the Emacs auto-generated Custom block to a hidden file
;; This prevents Emacs from constantly injecting garbage at the bottom of this init.el
(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

(defvar my/config-dir (expand-file-name "lisp" user-emacs-directory))

;; Load literate config directly.
;; org-babel-load-file automatically tangles .org -> .el only if the .org is newer.
;; Notice the missing 't' at the end -- this permanently stops .elc generation!
(dolist (file '("bootstrap.org"
                "completion.org"
                "editor.org"
                "ui.org"
                "org-config.org"
                "file-management.org"
                "programming.org"))
  (org-babel-load-file (expand-file-name file my/config-dir)))

;;; init.el ends here
