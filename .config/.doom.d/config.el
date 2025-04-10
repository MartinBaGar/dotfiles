

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
(setq doom-font (font-spec
                 :family "DejaVu Sans Mono"
                 :size 18))

(custom-set-faces
 '(bold ((t (:weight extra-bold :height 1.0))))
 '(italic ((t (:slant italic :weight normal :height 1.0)))))

;; (custom-set-faces!
;;   '(org-block :background "#232335")
;;   '(org-block-begin-line :background "#1c1c25" :foreground "#5B6268")
;;   '(org-block-end-line :background "#1c1c25" :foreground "#5B6268"))

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
  ;; Org config
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (setq org-tag-alist
        '(("labo" . ?l) ("maison" . ?m) ("production" . ?p)
          ("analyse" . ?a) ("biblio" . ?b) ("divers" . ?d)))
  (setq org-display-remote-inline-images 'download)
  (setq org-startup-with-inline-images t)
  (setq org-image-align 'center)
  (setq org-log-done t)
  (setq-default org-display-custom-times t)
  (setq org-time-stamp-formats '("<%Y-%m-%d %a %H:%M>" . "<%Y-%m-%d %a %H:%M>"))
  (use-package! org-pandoc-import)
  (add-hook! 'org-mode-hook #'org-modern-mode)
  (add-hook! 'org-mode-hook #'+org-pretty-mode)
  ;; Folding persistence via savefold.el
  (setq org-startup-folded 'showeverything) ; default fold behavior

  (setq savefold-backends '(org))
  (setq savefold-directory (locate-user-emacs-file "savefold"))
  (savefold-mode 1)
)

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
  (set-popup-rule! "*doom:vterm-popup-vertical:*" :size 0.25 :vslot -4 :select t :quit nil :ttl 0 :side 'right)
  (setq vterm-shell "/usr/bin/zsh")

  (define-key vterm-mode-map (kbd "M-h") 'windmove-left)
  (define-key vterm-mode-map (kbd "M-j") 'windmove-down)
  (define-key vterm-mode-map (kbd "M-k") 'windmove-up)
  (define-key vterm-mode-map (kbd "M-l") 'windmove-right)
  )

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

(defun vterm-dired-other-window ()
  "Open dired in the current working directory of vterm in another window."
  (interactive)
  (when (derived-mode-p 'vterm-mode)
    (let* ((proc (get-buffer-process (current-buffer)))
           (pid (and proc (process-id proc)))
           (cwd (and pid
                     (file-symlink-p (format "/proc/%d/cwd" pid)))))
      (dired-other-window (or cwd default-directory)))))

(map! :leader
      (:prefix-map ("d" . "dired")
        :desc "Dired vterm-cwd in new win" "v" #'vterm-dired-other-window))

(after! latex
  (setq +latex-viewers '(pdf-tools))
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-view-program-list
        '(("PDF Tools" TeX-pdf-tools-sync-view)))
  (setq TeX-command-default "LaTeXMk")
)
(setq-hook! 'LaTeX-mode-hook +spellcheck-immediately nil)

; use cdlatex completion instead of yasnippet
(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)

(map! :after latex
      :map cdlatex-mode-map
      :localleader
      :desc "Insert math symbol"
      "i" #'cdlatex-math-symbol
      :desc "Begin environment"
      "e" #'cdlatex-environment)

(defvar-local toggle-maximize--saved-config nil
  "Holds the window configuration before maximizing.")

(defun toggle-maximize-window ()
  "Toggle maximization of the current window."
  (interactive)
  (if toggle-maximize--saved-config
      (progn
        (set-window-configuration toggle-maximize--saved-config)
        (setq toggle-maximize--saved-config nil)
        (message "Window layout restored"))
    (setq toggle-maximize--saved-config (current-window-configuration))
    (delete-other-windows)
    (message "Window maximized")))

(defun toggle-maximize--reset-on-change (&rest _)
  "Reset toggle state if the window layout changes outside the toggle function."
  (when toggle-maximize--saved-config
    (setq toggle-maximize--saved-config nil)))

(advice-add 'split-window :after #'toggle-maximize--reset-on-change)
(advice-add 'delete-window :after #'toggle-maximize--reset-on-change)
(advice-add 'other-window :after #'toggle-maximize--reset-on-change)

(map! :leader
        "z" #'toggle-maximize-window)

(defvar window-layout-stack '()
  "A stack of saved window configurations with user-defined names.")

(defvar max-window-layouts 10
  "The maximum number of window layouts to store in the stack.")

(defun save-window-layout ()
  "Save the current window configuration to the layout stack with a user-defined name."
  (interactive)
  (let ((name (read-string "Enter layout name: ")))  ; Prompt for a name
    (if (>= (length window-layout-stack) max-window-layouts)
        (setq window-layout-stack (butlast window-layout-stack 1)))  ; Remove oldest if over limit
    (push (cons name (current-window-configuration)) window-layout-stack)
    (message "Window layout saved: %s" name)))

(defun restore-window-layout ()
  "Choose and restore a saved window configuration from the stack."
  (interactive)
  (if window-layout-stack
      (let* ((choices (mapcar #'car window-layout-stack))
             (selected (completing-read "Restore layout: " choices nil t)))
        (when selected
          (let ((config (cdr (assoc selected window-layout-stack))))
            (when config
              (set-window-configuration config)
              (message "Restored layout: %s" selected)))))
    (message "No saved layouts.")))

(map! :leader
      (:prefix-map ("l" . "layout")
        "s" #'save-window-layout
        "r" #'restore-window-layout))

(defun my/org-pandoc-import-multiple (files)
  "Convert multiple FILES (Markdown) to Org using `org-pandoc-import-to-org`."
  (interactive
   (list (file-expand-wildcards (read-file-name "Glob pattern (e.g., *.md): " nil "*.md" t))))
  (dolist (file files)
    (message "Converting %s..." file)
    (org-pandoc-import-to-org nil file)))

(defun my/org-roam-convert-existing-notes ()
  "Convert all .org files under `org-roam-directory` into Org-roam nodes."
  (interactive)
  (require 'org-id)
  (dolist (file (directory-files-recursively org-roam-directory "\\.org$"))
    (with-current-buffer (find-file-noselect file)
      (goto-char (point-min))
      ;; Add title if missing
      (unless (re-search-forward "^#\\+title: " nil t)
        (goto-char (point-min))
        (insert (format "#+title: %s\n\n" (file-name-base file))))
      ;; Add ID if missing
      (org-id-get-create)
      (save-buffer)
      (kill-buffer))))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; Bind the function to a key
(map! :leader
      (:prefix-map ("l" . "layout")
        :desc "Toggle window split" "t" #'toggle-window-split))
