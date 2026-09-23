;;; init.el --- Bootstrapper -*- lexical-binding: t; -*-

;; Pre-authorize the one `eval' dir-local form used in lisp/.dir-locals.el
;; (auto-tangle-on-save for every literate file under lisp/), so Emacs
;; doesn't prompt for confirmation every time a new file there is opened.
(add-to-list 'safe-local-eval-forms
             '(add-hook 'after-save-hook #'org-babel-tangle nil t))

(defvar my/config-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory holding the split literate config files.")

(defun my/load-literate-config (file)
  "Tangle FILE (an org file under `my/config-dir') if stale, then load it.
Each file tangles to its own same-named .el, independently of the
others -- no #+INCLUDE, no shared tangle target."
  (let* ((org-file (expand-file-name file my/config-dir))
         (el-file  (expand-file-name
                    (concat (file-name-base file) ".el")
                    my/config-dir)))
    (if (and (file-exists-p el-file)
             (file-newer-than-file-p el-file org-file))
        (load (file-name-sans-extension el-file))
      (org-babel-load-file org-file t))))

;; Order matters: bootstrap.org (Elpaca) must load first. Everything
;; after it can be reordered freely.
(dolist (file '("bootstrap.org"
                "completion.org"
                "editor.org"
                "ui.org"
                "org-config.org"
                "file-management.org"
                "programming.org"))
  (my/load-literate-config file))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("34d84ab5a582eb28e67c3017ab7af0916ed2b34c071ee5dd3b92e679d57413c3"
     "30b34b5d8b19449406cdbe70dd6aa2d5edb0504df027cd028cbe35faf8353649"
     "c1ec19bedfe30cc2cef61c72ff8cbd1593857dcbae89f6649a0c80c3d26213e8"
     "9ec9cb6b3fea5ecc1530eb9d24bce05b26f2e0398dd66a3b5628f560ba4e955c"
     default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
