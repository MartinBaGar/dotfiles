;; credentials
(setq user-full-name "Martin Bari Garnier"
      user-mail-address "martbari.g@gmail.com")

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

(setq doom-modeline-project-name t)
(setq-default tab-width 4)
(define-key evil-insert-state-map (kbd "C-q") 'backward-delete-char)

(after! evil-escape
  (setq evil-escape-key-sequence "fd"))

(setq text-mode-ispell-word-completion nil)

(after! cape
  (setq cape-dict-file "/usr/share/dict/french"))

;; Org Mode: Enable cape-dict only outside src blocks
(add-hook! 'org-mode-hook
  (defun +corfu-cape-dict-maybe-org ()
    ;; Preserve existing completion-at-point-functions
    (let ((cape-func (lambda ()
                       (unless (org-in-src-block-p)
                         (cape-dict)))))
      ;; Add cape-dict preserving previous functions
      (add-hook 'completion-at-point-functions cape-func 100 t))))

;; Markdown Mode: Enable cape-dict only outside code blocks
(add-hook! 'markdown-mode-hook
  (defun +corfu-cape-dict-maybe ()
    (let ((cape-func (lambda ()
                       (unless (markdown-code-block-at-point-p)
                         (cape-dict)))))
      ;; Add cape-dict preserving previous functions
      (add-hook 'completion-at-point-functions cape-func 100 t))))

;; Markdown Mode: Enable cape-dict only outside code blocks
(add-hook! 'markdown-mode-hook
  (defun +corfu-cape-dict-maybe ()
    (add-hook 'completion-at-point-functions
              (lambda ()
                (unless (markdown-code-block-at-point-p)
                  (cape-dict)))
              100 t)))

(add-hook! 'LaTeX-mode-hook
  (outline-minor-mode)
  (defun +corfu-add-cape-tex-h ()
    ;; Preserve existing completion-at-point-functions
    (let ((cape-dict-func (lambda ()
                           (cape-dict)))
          (cape-tex-func  (lambda ()
                            (cape-tex))))
      ;; Add cape-dict and cape-tex preserving previous functions
      (add-hook 'completion-at-point-functions cape-dict-func 100 t)
      (add-hook 'completion-at-point-functions cape-tex-func -30 t))))

;; (add-hook! 'LaTeX-mode-hook
;;   (outline-minor-mode)
;;   (defun +corfu-add-cape-tex-h ()
;;     ;; Use cape-capf-super for better integration
;;     (add-to-list 'completion-at-point-functions #'cape-dict t)
;;     (add-to-list 'completion-at-point-functions #'cape-tex t)))

;; (add-hook! 'LaTeX-mode-hook
;;   (outline-minor-mode)
;;   (defun +corfu-add-cape-tex-h ()
;;     (setq-local completion-at-point-functions
;;                 (append (list (cape-capf-super #'cape-dict))
;;                         completion-at-point-functions
;;                         (list #'cape-tex)))))

;; https://github.com/joaotavora/yasnippet/issues/998
(defun my-yas-try-expanding-auto-snippets ()
(when (and (boundp 'yas-minor-mode) yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
    (yas-expand))))
(add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)

;; 1. Enable yasnippet and load LaTeX snippets when editing Org
(defun my-org-latex-yas ()
  "Enable YASnippet and activate LaTeX snippets in Org mode."
  (yas-minor-mode)
  (yas-activate-extra-mode 'latex-mode))  ; load LaTeX snippets

(add-hook 'org-mode-hook #'my-org-latex-yas)

(setq org-image-max-width 500)

;; ;; 2. Function to expand YAS only inside LaTeX fragments in Org
;; (defun my/org-inline-latex-snippet-expand ()
;;   "Expand LaTeX snippets when inside an Org inline LaTeX fragment."
;;   (interactive)
;;   (when (and (org-inside-LaTeX-fragment-p)
;;              (bound-and-true-p yas-minor-mode))
;;     (yas-expand)))

;; ;; 3. Bind it to a key in Org mode (e.g., C-c y or TAB)
;; (with-eval-after-load 'org
;;   (define-key org-mode-map (kbd "C-c y") #'my/org-inline-latex-snippet-expand))

;; ;; Optional: If you want TAB to auto-expand snippets inside inline LaTeX
;; (defun my/org-tab-handler ()
;;   "Custom TAB handler: expands YAS in LaTeX fragments or cycles otherwise."
;;   (interactive)
;;   (cond
;;    ((and (org-inside-LaTeX-fragment-p)
;;          (bound-and-true-p yas-minor-mode)
;;          (yas-expand)))
;;    (t (org-cycle))))  ; fallback behavior

;; (with-eval-after-load 'org
;;   (define-key org-mode-map (kbd "TAB") #'my/org-tab-handler))

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

;; (setq doom-theme 'doom-gruvbox)
;; (setq doom-theme 'doom-feather-dark)
(setq doom-theme 'doom-oksolar-light)

(setq doom-font (font-spec
                 :family "DejaVu Sans Mono"
                 :size 18))

(custom-set-faces
 '(bold ((t (:weight extra-bold :height 1.0))))
 '(italic ((t (:slant italic :weight normal :height 1.0)))))

(setq indicate-empty-lines nil)

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

(setq display-line-numbers nil)
(setq display-line-numbers-type nil) ;; TODO change to 'visual in org-mode

(setq global-hl-line-modes nil)

;; (setq display-fill-column-indicator-column 80)
;; (add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; (add-hook 'window-setup-hook #'toggle-frame-maximized)

(after! org
  ;; Display
  ;; (setq org-display-remote-inline-images 'download)
  (setq org-startup-with-inline-images nil)
  (setq org-image-align 'left)
  (add-hook! 'org-mode-hook #'org-modern-mode)
  (add-hook! 'org-mode-hook #'+org-pretty-mode)

  ;; Use a timer to ensure the file is fully loaded before previewing LaTeX
  (add-hook! 'org-mode-hook
    (run-with-timer 1 nil
                  (lambda ()
                    (when (and (buffer-live-p (current-buffer))
                              (display-graphic-p))
                      (org-latex-preview '(16))))))
  ;; TODOs
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (setq org-tag-alist
        '(("baal" . ?b) ("adastra" . ?a)))
  (setq org-log-done t)
  (setq-default org-display-custom-times t)
  (setq org-time-stamp-formats '("<%Y-%m-%d %a %H:%M>" . "<%Y-%m-%d %a %H:%M>"))
  (use-package! org-pandoc-import)


  ;; Folding persistence via savefold.el
  (setq org-startup-folded 'showeverything) ; default fold behavior

  (setq savefold-backends '(org))
  (setq savefold-directory (locate-user-emacs-file "savefold"))
  (savefold-mode 1)

  ;; Attach
  (setq org-attach-id-dir "~/org/.attach")
  (require 'org-download)
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

(defun my/org-copy-link-at-point ()
  "Copy the link at point"
  (interactive)
  (let ((link (replace-regexp-in-string "^[^:]+:" "" (org--link-at-point))))
    (kill-new link)
    (message "Copied: %s" link)))

;; (use-package! org-download
;;   :after org
;;   :defer nil
;;   :config

;; (setq org-download-screenshot-method "flameshot gui --raw > %s")

;; (defun my/org-download-clipboard-with-name ()
;;   "Prompt for a filename and save the clipboard image as <buffername>_<name>.png."
;;   (interactive)
;;   ;; (setq org-download-timestamp "")
;;   (let* ((buffer-name-base (file-name-base (or (buffer-file-name) (buffer-name))))
;;          (name (read-string "Image name (without extension): "))
;;          (filename (format "%s_%s.png" buffer-name-base name)))
;;     (org-download-clipboard filename)
;;     (message "Saved image as: %s" filename)))

;; (defun my/org-download-screenshot ()
;;   "Prompt for a filename and save the clipboard image as <buffername>_<name>.png."
;;   (interactive)
;;   ;; (setq org-download-timestamp "")
;;   (let* ((buffer-name-base (file-name-base (or (buffer-file-name) (buffer-name))))
;;          (name (read-string "Image name (without extension): "))
;;          (filename (format "%s_%s.png" buffer-name-base name)))
;;     (org-download-screenshot filename)
;;     (message "Saved image as: %s" filename))))
(after! org-download
  ;; Fix the underscore prefix issue
  (setq org-download-timestamp "%Y%m%d-%H%M%S")
  (setq org-download-screenshot-method "flameshot gui --raw > %s")
  ;; (setq org-download-timestamp "")

  ;; Add a custom function to prompt for a filename
  (defun my/org-download-screenshot ()
    "Take a screenshot and prompt for a custom filename."
    (interactive)
    (let* ((custom-name (read-string "Screenshot name: ")))
      (setq org-download-screenshot-file
            (concat (temporary-file-directory) "_" custom-name ".png"))
      (org-download-screenshot)))

  (defun my/org-download-clipboard ()
    "Download image from clipboard and prompt for a custom filename."
    (interactive)
    (let* ((custom-name (read-string "Image name: "))
           (temp-file (make-temp-file nil))
           (custom-fname (concat temporary-file-directory custom-name ".png"))
           (org-download-screenshot-file custom-fname)
           )
      ;; Temporarily use the custom name as timestamp
      (setq org-download-timestamp "")
      ;; Call clipboard function
      (call-interactively 'org-download-clipboard)
      ;; Restore original timestamp
      (setq org-download-timestamp "%Y%m%d_%H%M%S")
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

;; (setq shell-command-switch "-ic")

(after! latex
  (setq +latex-viewers '(pdf-tools))
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-view-program-list
        '(("PDF Tools" TeX-pdf-tools-sync-view)))
  ;; Correct way to set LaTeXmk as default in Doom Emacs
  (setq-hook! LaTeX-mode TeX-command-default "LaTeXMK"))

(after! cdlatex
  (setq cdlatex-math-modify-prefix ?²)
  ;; First, remove the old keybinding
  (define-key cdlatex-mode-map "'" nil)
  ;; Then, bind the new one manually
  (define-key cdlatex-mode-map (string cdlatex-math-modify-prefix) #'cdlatex-math-modify))

;; (defun my/update-prefix-key (map old-key new-key command)
;;   "In MAP, unbind OLD-KEY and bind NEW-KEY to COMMAND."
;;   (when (boundp map)
;;     (let ((map (symbol-value map)))
;;       (when map
;;         (define-key map (kbd old-key) nil)
;;         (define-key map (kbd new-key) command)))))

;; (after! cdlatex
;;   (setq cdlatex-math-modify-prefix ?/)
;;   (my/update-prefix-key 'cdlatex-mode-map "'" "/" #'cdlatex-math-modify))

; use cdlatex completion instead of yasnippet
;; (map! :map cdlatex-mode-map
;;       :i "TAB" #'cdlatex-tab)

;; (map! :after latex
;;       :map cdlatex-mode-map
;;       :localleader
;;       :desc "Insert math symbol"
;;       "i" #'cdlatex-math-symbol
;;       :desc "Begin environment"
;;       "e" #'cdlatex-environment)

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

(defun my/org-pandoc-import-md-recursive ()
  "Convert all Markdown files in current directory and subdirectories to Org format."
  (interactive)
  (let ((files (directory-files-recursively default-directory "\\.md$")))
    (dolist (file files)
      (message "Converting %s..." file)
      (org-pandoc-import-to-org nil file))))

(defun my/org-roam-convert-existing-notes ()
  "Convert all .org files under `org-roam-directory` into Org-roam nodes."
  (interactive)
  (require 'org-id)
  ;; (dolist (file (directory-files-recursively org-roam-directory "\\.org$"))
  (dolist (file (directory-files-recursively default-directory "\\.org$"))
    (with-current-buffer (find-file-noselect file)
      (goto-char (point-min))
      ;; Add title if missing
      (unless (re-search-forward "^\:ID\:" nil t)
        (goto-char (point-min))
        (org-id-get-create))
      (goto-char (point-min))
      (unless (re-search-forward "^#\\+title: " nil t)
        (re-search-forward "^:PROPERTIES:\n\\(?:.*\n\\)*?:END:" nil t)
        (forward-line 1)
        (insert (format "#+title: %s\n\n" (file-name-base file))))
      ;; Add ID if missing
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
  (setq! gptel-backend (gptel-get-backend "OpenRouter"))
  (setq! gptel-model 'deepseek/deepseek-chat-v3-0324:free))

(after! gptel
  ;; Add a new directive called ‘my-prompt’
  (setf (alist-get 'md-expert gptel-directives)
        "Act as an expert in molecular dynamics simulations. You have deep knowledge of theory, workflows, force fields, and major software.
Answer my questions with technical accuracy and clarity. Focus on concepts, practical advice, and common pitfalls. Keep explanations concise but complete.")
  (setf (alist-get 'LaTeX-assistant gptel-directives)
        "Act as an expert in LaTeX document writing and formatting. You know best practices for structure, typography, equations, figures, tables, and citations. Be decisive about when to use built-in solutions vs. recommended packages, and suggest packages when appropriate. Answer clearly with clean LaTeX code. Keep responses concise, practical, and focused on document quality."))

(setq org-cite-csl-styles-dir "/mnt/c/Users/martb/Documents/zotero-system/styles")
(setq! bibtex-completion-bibliography '("~/zotero-lib/referenciator.bib"))
(setq citar-bibliography '("~/zotero-lib/referenciator.bib"))
(setq! bibtex-completion-library-path '("~/zotero-lib/referenciator.bib"))
(setq! citar-library-paths '("~/zotero-lib/"))
;; (setq! citar-file-parser-functions '("/mnt/c/Users/martb/Documents/zotero-lib/"))

(setq-hook! 'python-mode-hook +format-with '(isort black))
   ;; (setq-hook! 'python-mode-hook +format-with 'black)

;; The proper Doom way
(setq-hook! 'markdown-mode-hook
  markdown-hide-markup t
  markdown-fontify-code-blocks-natively t
  markdown-hide-urls t
  markdown-italic-underscore t
  markdown-asymmetric-header t
  markdown-gfm-additional-languages '("sh" "json" "elisp"))

(custom-set-faces!
'(markdown-header-delimiter-face :foreground "#616161" :height 0.9)
'(markdown-header-face-1 :height 1.8 :foreground "#A3BE8C" :weight extra-bold :inherit markdown-header-face)
'(markdown-header-face-2 :height 1.4 :foreground "#EBCB8B" :weight extra-bold :inherit markdown-header-face)
'(markdown-header-face-3 :height 1.2 :foreground "#D08770" :weight extra-bold :inherit markdown-header-face)
'(markdown-header-face-4 :height 1.15 :foreground "#BF616A" :weight bold :inherit markdown-header-face)
'(markdown-header-face-5 :height 1.1 :foreground "#b48ead" :weight bold :inherit markdown-header-face)
'(markdown-header-face-6 :height 1.05 :foreground "#5e81ac" :weight semi-bold :inherit markdown-header-face))

(map! :leader
      (:prefix ("p" . "project.el") ; Use a different prefix like "P" instead of "p"
       :desc "Find file in project"           "f" #'project-find-file
       :desc "Find external file"             "F" #'project-or-external-find-file
       :desc "Switch to project buffer"       "b" #'project-switch-to-buffer
       :desc "Run shell in project"           "s" #'project-shell
       :desc "Find directory in project"      "d" #'project-find-dir
       :desc "Open project dired"             "D" #'project-dired
       :desc "Open project vc-dir"            "v" #'project-vc-dir
       :desc "Compile project"                "c" #'project-compile
       :desc "Run eshell in project"          "e" #'project-eshell
       :desc "Kill project buffers"           "k" #'project-kill-buffers
       :desc "Switch project"                 "p" #'project-switch-project
       :desc "Find regexp in project"         "g" #'project-find-regexp
       :desc "Find external regexp"           "G" #'project-or-external-find-regexp
       :desc "Replace regexp in project"      "r" #'project-query-replace-regexp
       :desc "Run command in project"         "x" #'project-execute-extended-command
       :desc "Run any project command"        "o" #'project-any-command
       :desc "List project buffers"           "l" #'project-list-buffers
       :desc "Save project buffers"           "S" #'project-save-some-buffers
       :desc "Run shell command in project"   "!" #'project-shell-command
       :desc "Async shell command in project" "&" #'project-async-shell-command))

;; (use-package! go-translate
;;   :init
;;   :config
;;     (setq gt-preset-translators
;;         `((en-fr . ,(gt-translator
;;                     :taker (gt-taker :langs '(en fr) :text 'word)
;;                     :engines (list (gt-bing-engine :if 'no-word) (gt-google-engine :if 'word))
;;                     ;; :engines (list (gt-bing-engine))
;;                     :render (list (gt-insert-render :type 'replace :if 'no-word) (gt-buffer-render))))
;;             (fr-en . ,(gt-translator
;;                     :taker (gt-taker :langs '(fr en) :text 'word)
;;                     :engines (list (gt-bing-engine :if 'no-word) (gt-google-engine :if 'word))
;;                     ;; :engines (list (gt-bing-engine))
;;                     :render (list (gt-insert-render :type 'replace :if 'no-word) (gt-buffer-render)))))))

;; (map! :leader
;;     (:prefix ("t t" . "translate")
;;     :desc "Translate" "t" #'gt-do-translate
;;     :desc "Switch translator" "s" #'gt-switch-translator))

  (use-package! go-translate
    :config
  (setq gt-default-translator
        (gt-translator
         :taker (gt-taker :langs '(en fr) :text 'sentence :prompt t)
         :engines (list
                   (gt-google-engine :if 'word)
                   (gt-deepl-engine :if 'not-word))
         :render (list (gt-buffer-render :if 'word) (gt-insert-render :type 'replace)))))

(map! :leader
    (:prefix ("t t" . "translate")
    :desc "Translate" "t" #'gt-do-translate))

;; Il s'agit d'un test.
;; This is a test.

(setq langtool-language-tool-jar "~/LanguageTool-6.6/languagetool-commandline.jar")
(require 'langtool)

(defun my/vscode-open-path-at-point ()
  "Open the file at point with VS Code."
  (interactive)
  (let ((path (thing-at-point 'filename t)))
    (if (and path (file-exists-p path))
        (start-process "vscode" nil "code" (expand-file-name path))
      (message "No valid file path at point."))))

(map! :leader
      :prefix "o"
      :desc "Open file at point in VS Code"
      "v" #'my/vscode-open-path-at-point)

(defun my/xdg-open-path-at-point ()
  "Open the file at point with xdg-open."
  (interactive)
  (let ((path (thing-at-point 'filename t)))
    (if (and path (file-exists-p path))
        (start-process "open" nil "xdg-open" (expand-file-name path))
      (message "No valid file path at point."))))

(map! :leader
      :prefix "o"
      :desc "Open file at point with default app"
      "x" #'my/xdg-open-path-at-point)

(defun copy-image-to-system-clipboard (&optional force-prompt)
  "Copy an image to the clipboard as image/png.
- On Linux: uses `xclip`.
- On WSL2 or Windows: uses `powershell.exe` to call .NET Clipboard APIs.
If FORCE-PROMPT is non-nil, always prompt for image file."
  (interactive "P")
  (let* ((image (get-text-property (point) 'display))
         (file
          (cond
           ;; Inline image at point (check for both :file and :data)
           ((and (not force-prompt) (eq (car-safe image) 'image))
            (let ((image-data (plist-get (cdr image) ':data))
                  (image-file (plist-get (cdr image) ':file)))
              (cond
               ;; Handle inline image data
               (image-data
                (cons 'data image-data))
               ;; Handle image file
               (image-file
                image-file)
               (t nil))))
           ;; Check if point is on a link to an image file
           ((and (not force-prompt)
                 (org-element-type-p (org-element-context) 'link))
            (let ((link-path (org-element-property :path (org-element-context)))
                  (attach-dir (org-attach-dir)))
              (when (and link-path attach-dir)
                (let ((full-path (expand-file-name link-path attach-dir)))
                  (when (and (file-exists-p full-path)
                            (image-type-from-file-name full-path))
                    full-path)))))
           ;; Prompted file from org-attach
           (t
            (let* ((attach-dir (or (org-attach-dir) (user-error "No attachment directory")))
                   (selection (completing-read "Select image: " (org-attach-file-list attach-dir) nil t)))
              (expand-file-name selection attach-dir)))))
         (truename (and (stringp file) (file-truename file))))

    ;; Handle inline image data case
    (when (and (consp file) (eq (car file) 'data))
      (cond
       ;; WSL2 or Windows - need to save data to temp file first
       ((or (eq system-type 'windows-nt)
            (and (eq system-type 'gnu/linux)
                 (string-match "Microsoft" (shell-command-to-string "uname -r"))))
        (let ((temp-file (make-temp-file "emacs-image-" nil ".png")))
          (with-temp-buffer
            (insert (cdr file))
            (write-region (point-min) (point-max) temp-file))
          (let ((win-path
                 (replace-regexp-in-string
                  "/" "\\\\"
                  (replace-regexp-in-string "^/mnt/\\([a-z]\\)/"
                                            (lambda (m) (concat (upcase (match-string 1 m)) ":\\\\"))
                                            (file-truename temp-file) t t))))
            (start-process "powershell-copy-image" nil "powershell.exe" "-Command"
                           (concat "[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null; "
                                   "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; "
                                   "[System.Windows.Forms.Clipboard]::SetImage([System.Drawing.Image]::FromFile('"
                                   win-path "'))"))
            (message "Copied inline image data to Windows clipboard"))))
       ;; Linux (X11) - can pipe data directly
       ((executable-find "xclip")
        (with-temp-buffer
          (insert (cdr file))
          (call-shell-region
           (point-min) (point-max)
           "xclip -i -selection clipboard -t image/png"))
        (message "Copied inline image data to X11 clipboard"))
       (t
        (user-error "No supported clipboard mechanism found on this platform")))
      (return))

    ;; Handle file-based images
    (unless (and truename (file-exists-p truename))
      (user-error "Image file not found: %s" (or truename file)))

    (cond
     ;; WSL2 or Windows
     ((or (eq system-type 'windows-nt)
          (and (eq system-type 'gnu/linux)
               (string-match "Microsoft" (shell-command-to-string "uname -r"))))
      (let ((win-path
             ;; Convert /mnt/c/... to C:\\... for PowerShell
             (replace-regexp-in-string
              "/" "\\\\"
              (replace-regexp-in-string "^/mnt/\\([a-z]\\)/"
                                        (lambda (m) (concat (upcase (match-string 1 m)) ":\\\\")) truename t t))))
        (start-process "powershell-copy-image" nil "powershell.exe" "-Command"
                       (concat "[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null; "
                               "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; "
                               "[System.Windows.Forms.Clipboard]::SetImage([System.Drawing.Image]::FromFile('"
                               win-path "'))"))
        (message "Copied image to Windows clipboard: %s" win-path)))
     ;; Linux (X11)
     ((executable-find "xclip")
      (start-process "xclip-proc" nil "xclip"
                     "-i" "-selection" "clipboard" "-t" "image/png" "-quiet" truename)
      (message "Copied image to X11 clipboard: %s" truename))
     (t
      (user-error "No supported clipboard mechanism found on this platform")))))

(use-package blender
  :defer t
  :commands (blender-mode blender-start blender-run-current-buffer)
  :init
  :custom
  (blender-executable "/mnt/c/Program Files/Blender Foundation/Blender 4.4/blender.exe")
  (blender-addon-directory "C:/Users/martb/Documents/Blender/my_addons")
  )
