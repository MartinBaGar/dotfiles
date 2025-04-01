;; credentials
(setq user-full-name "Martin Bari Garnier"
      user-mail-address "martbari.g@gmail.com")

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

;; kill emacs without confiming
(setq confirm-kill-emacs nil)

;; remap <localleader> from SPC m to SPC l
;; (setq doom-localleader-key "SPC l"
;;      doom-localleader-alt-key "M-SPC l")

(setq doom-theme 'doom-gruvbox)
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 20))

(setq display-line-numbers-type 'relative) ;; TODO change to 'visual in org-mode
(add-hook! display-line-numbers-mode
  (custom-set-faces!
    '(line-number :slant normal)
    '(line-number-current-line :slant normal)))

(setq global-hl-line-modes nil)

(setq display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Run (package-vc-install '(ultra-scroll :vc-backend Git :url "https://github.com/jdtsmith/ultra-scroll")) in scratch buffer.
;; (use-package! ultra-scroll
;;   :init
;;   (setq scroll-conservatively 101 ; important!
;;         scroll-margin 0)
;;   :config
;;   (ultra-scroll-mode 1))

(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 40))

(after! org
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))))
(setq org-tag-alist '(("labo" . ?l) ("maison" . ?m) ("production" . ?p) ("analyse" . ?a) ("biblio" . ?b) ("divers" . ?d)))

;; Set default dictionary
(setq ispell-dictionary "fr_FR")

;; Create a function to select dictionary from a list
(defun select-dictionary ()
  "Select spelling dictionary."
  (interactive)
  (let* ((dicts '("en_US" "fr_FR"))
         (selection (completing-read "Select dictionary: " dicts nil t)))
    (ispell-change-dictionary selection)
    (message "Dictionary switched to %s" selection)))

;; Bind the selection function to a key
(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Select dictionary" "d" #'select-dictionary))

(setq org-display-inline-images t)
(setq org-display-remote-inline-images 'download)
