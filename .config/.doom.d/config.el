;; Désactiver la complétion ispell qui peut interférer avec cape-dict
(setq text-mode-ispell-word-completion nil)

;; Configuration de Cape pour les dictionnaires
(after! cape
  ;; Configurer le dictionnaire français
  (setq cape-dict-file
        (or (and (file-exists-p "/usr/share/dict/french")
                 "/usr/share/dict/french")
            (and (file-exists-p "/usr/share/dict/wfrench")
                 "/usr/share/dict/wfrench")
            "/usr/share/dict/american-english"))

  ;; Ajouter cape-dict aux sources de complétion pour les modes texte et LaTeX
  (add-hook! '(text-mode-hook LaTeX-mode-hook)
    ;; Retirer ispell-completion-at-point s'il est présent
    (remove-hook 'completion-at-point-functions #'ispell-completion-at-point 'local)
    ;; Ajouter cape-dict en priorité
    ;; (push #'cape-dict completion-at-point-functions)
    ;; (push #'cape-dabbrev completion-at-point-functions))
  ))

;; Fonction pour basculer entre les dictionnaires français et anglais
(defun toggle-completion-language ()
  "Toggle between French and English completion."
  (interactive)
  (if (string-match-p "french" (or cape-dict-file ""))
      (progn
        (setq cape-dict-file "/usr/share/dict/american-english")
        (message "Switched to English completion"))
    (progn
      (setq cape-dict-file
            (or (and (file-exists-p "/usr/share/dict/french")
                     "/usr/share/dict/french")
                (and (file-exists-p "/usr/share/dict/wfrench")
                     "/usr/share/dict/wfrench")))
      (message "Switched to French completion"))))

;; Lier à une touche
;; (map! :leader
;;       (:prefix-map ("t" . "toggle")
;;        :desc "Toggle completion language" "l" #'toggle-completion-language))

;; credentials
(setq user-full-name "Martin Bari Garnier"
      user-mail-address "martbari.g@gmail.com")

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

(setq doom-theme 'doom-gruvbox)
(setq doom-font (font-spec
                 :family "DejaVu Sans Mono"
                 :size 18))

(custom-set-faces
 '(bold ((t (:weight extra-bold :height 1.0))))
 '(italic ((t (:slant italic :weight normal :height 1.0)))))

(defvar current-monitor-name nil)

(defun my/check-monitor-change (&rest _)
  "Check if monitor has changed and adjust font if needed."
  (let* ((monitor-attrs (frame-monitor-attributes))
         (monitor-name (cdr (assoc 'name monitor-attrs))))
    (when (and monitor-name (not (string= monitor-name current-monitor-name)))
      (let ((font-size (cond
                       ((string= monitor-name "XWAYLAND0") 17)  ;; smaller font
                       ((string= monitor-name "XWAYLAND1") 20)  ;; normal font
                       (t 18))))  ;; fallback font size
        (message "Monitor changed: %s → Font size: %.1f" monitor-name font-size)
        (setq doom-font (font-spec :family "DejaVu Sans Mono" :size font-size))
        (setq current-monitor-name monitor-name)
        (doom/reload-font)))))

;; Alternative approach: advise doom-modeline function
(advice-add 'doom-modeline-window-size-change-function
            :after #'my/check-monitor-change)

;; Run once initially at startup
(my/check-monitor-change)

(setq global-display-line-numbers-mode nil)
;; (setq display-line-numbers-type 'relative) ;; TODO change to 'visual in org-mode

(setq global-hl-line-modes nil)

(setq display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Run (package-vc-install '(ultra-scroll :vc-backend Git :url "https://github.com/jdtsmith/ultra-scroll")) in scratch buffer.
;; (use-package! ultra-scroll
;;   :init
;;   (setq scroll-conservatively 101 ; important! ;;         scroll-margin 0)
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
(use-package! org-transclusion
              :after org
              :init
              (map!
               :map global-map "<f12>" #'org-transclusion-add
               :leader
               :prefix "n"
               :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

(defun my/org-copy-heading-link ()
  "Copy file: link to current Org heading using heading name, not ID."
  (interactive)
  (let ((link (format "[[file:%s::*%s]]"
                      (buffer-file-name)
                      (org-get-heading t t t t))))
    (kill-new link)
    (message "Copied: %s" link)))

;; Set default dictionary
(setq ispell-dictionary "fr_FR")

;; Define function to update cape-dict-file when dictionary changes
(defun update-cape-dict-file (dict-name)
  "Update cape-dict-file based on selected dictionary."
  (setq-default cape-dict-file
        (cond
         ((string= dict-name "fr_FR") "/usr/share/dict/french")
         ((string= dict-name "en_US") "/usr/share/dict/american-english")
         (t "/usr/share/dict/american-english")))
  (message "Cape dictionary set to %s" cape-dict-file))

;; Modify your dictionary selection functions to also update cape-dict-file
(defun select-dictionary ()
  "Select spelling dictionary."
  (interactive)
  (let* ((dicts '("en_US" "fr_FR"))
         (selection (completing-read "Select dictionary: " dicts nil t)))
    (ispell-change-dictionary selection)
    (update-cape-dict-file selection)
    (message "Dictionary switched to %s" selection)))

;; Advise ispell-change-dictionary to update cape-dict-file
(advice-add 'ispell-change-dictionary :after
            (lambda (dict)
              (when (member dict '("fr_FR" "en_US"))
                (update-cape-dict-file dict))))

;; Your existing keybindings with modified functions
(map! :leader
      (:prefix-map ("t" . "toggle")
       (:prefix-map ("s" . "spell")
        :desc "French Dictionary" "f" (lambda ()
                                        (interactive)
                                        (ispell-change-dictionary "fr_FR")
                                        (update-cape-dict-file "fr_FR"))
        :desc "English Dictionary" "e" (lambda ()
                                         (interactive)
                                         (ispell-change-dictionary "en_US")
                                         (update-cape-dict-file "en_US"))
        :desc "Toggle spell check" "s" #'flyspell-mode
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
  ;; Correct way to set LaTeXmk as default in Doom Emacs
  (setq-hook! LaTeX-mode TeX-command-default "LaTeXMK")
)

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

(use-package! gptel
  :config
  ;; Use authinfo (nil falls back to auth-source)
  ;; (setq! gptel-api-key nil)

  ;; Register OpenAI backend
  (gptel-make-openai "OpenAI"
    :host "api.openai.com"
    :endpoint "/v1/chat/completions"
    :models '("gpt-4" "gpt-3.5-turbo")
    :key #'gptel-api-key-from-auth-source)

  ;; Register Mistral backend
  (gptel-make-openai "Mistral"
    :host "api.mistral.ai"
    :endpoint "/v1/chat/completions"
    :models '("mistral-small" "mistral-medium")
    :key #'gptel-api-key-from-auth-source)

  ;; Register DeepSeek backend
  ;; (gptel-make-deepseek "DeepSeek"
  ;;   :stream t
  ;;   ;; :models '("deepseek-chat" "deepseek-coder" "deepseek-reasoner")
  ;;   :key #'gptel-api-key-from-auth-source)
  ;; Groq offers an OpenAI compatible API

    (gptel-make-openai "Groq"               ;Any name you want
    :host "api.groq.com"
    :endpoint "/openai/v1/chat/completions"
    :stream nil
    :key #'gptel-api-key-from-auth-source
    :models '(llama-3.1-70b-versatile
                llama-3.1-8b-instant
                llama3-70b-8192
                llama3-8b-8192
                mixtral-8x7b-32768
                gemma-7b-it))

   ;; OpenRouter offers an OpenAI compatible API
  (gptel-make-openai "OpenRouter"               ;Any name you want
  :host "openrouter.ai"
  :endpoint "/api/v1/chat/completions"
  :stream t
  :key #'gptel-api-key-from-auth-source
  :models '(deepseek/deepseek-r1:free
            deepseek/deepseek-chat-v3-0324:free
            google/gemini-2.5-pro-exp-03-25:free
            google/gemma-3-27b-it:free))

  ;; Default model + backend
  (setq! gptel-backend (gptel-get-backend "Mistral"))
  (setq! gptel-model 'mistral-medium))
