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
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 18))

(setq global-display-line-numbers-mode nil)
;; (setq display-line-numbers-type 'relative) ;; TODO change to 'visual in org-mode

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

(add-hook 'window-setup-hook #'toggle-frame-maximized)

(after! org
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (setq org-tag-alist '(("labo" . ?l) ("maison" . ?m) ("production" . ?p) ("analyse" . ?a) ("biblio" . ?b) ("divers" . ?d)))
  (setq org-display-remote-inline-images 'download)
  (setq org-startup-with-inline-images t)
  (setq org-image-align 'center)
  (setq org-log-done t))

;; Set default dictionary
;; (setq ispell-dictionary "fr_FR")

;; Create a function to select dictionary from a list
(defun select-dictionary ()
  "Select spelling dictionary."
  (interactive)
  (let* ((dicts '("en_US" "fr_FR"))
         (selection (completing-read "Select dictionary: " dicts nil t)))
    (ispell-change-dictionary selection)
    (message "Dictionary switched to %s" selection)))

(map! :leader
      (:prefix-map ("t" . "toggle")
       (:prefix-map ("s" . "spell")
        :desc "French Dictionary" "f" (lambda () (interactive) (ispell-change-dictionary "fr_FR"))
        :desc "English Dictionary" "e" (lambda () (interactive) (ispell-change-dictionary "en_US"))
        :desc "Toggle spell check" "s" #'flyspell-mode
        ;; :desc "Select dictionary" "d" #'select-dictionary
        )))

(define-key evil-insert-state-map (kbd "C-q") 'backward-delete-char)

(after! vterm
  (set-popup-rule! "*doom:vterm-popup-vertical:*" :size 0.25 :vslot -4 :select t :quit nil :ttl 0 :side 'right))

;; Create vertical toggle command
(defun +vterm/toggle-vertical (arg)
  "Toggles a terminal popup window at project root.

If prefix ARG is non-nil, recreate vterm buffer in the current project's root.

Returns the vterm buffer."
  (interactive "P")
  (+vterm--configure-project-root-and-display
   arg
   (lambda ()
     (let ((buffer-name
            (format "*doom:vterm-popup-vertical:%s*"
                    (if (bound-and-true-p persp-mode)
                        (safe-persp-name (get-current-persp))
                      "main")))
           confirm-kill-processes
           current-prefix-arg)
       (when arg
         (let ((buffer (get-buffer buffer-name))
               (window (get-buffer-window buffer-name)))
           (when (buffer-live-p buffer)
             (kill-buffer buffer))
           (when (window-live-p window)
             (delete-window window))))
       (if-let* ((win (get-buffer-window buffer-name)))
           (delete-window win)
         (let ((buffer (or (cl-loop for buf in (doom-buffers-in-mode 'vterm-mode)
                                    if (equal (buffer-local-value '+vterm--id buf)
                                              buffer-name)
                                    return buf)
                           (get-buffer-create buffer-name))))
           (with-current-buffer buffer
             (setq-local +vterm--id buffer-name)
             (unless (eq major-mode 'vterm-mode)
               (vterm-mode)))
           (pop-to-buffer buffer)))
       (get-buffer buffer-name)))))

(map! :leader
      (:prefix-map ("o" . "open")
       (:prefix-map ("t" . "terminal")
        :desc "Toggle vterm horizontally" "h" #'+vterm/toggle
        :desc "Toggle vterm vertically" "v" #'+vterm/toggle-vertical)))
