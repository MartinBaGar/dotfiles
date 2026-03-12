;; credentials
(setq user-full-name "Martin Bari Garnier"
      user-mail-address "martbari.g@gmail.com")

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

(setq doom-modeline-project-name t)
(setq-default tab-width 4)
(define-key evil-insert-state-map (kbd "C-q") 'backward-delete-char)

(with-eval-after-load 'evil-escape
  (setq evil-escape-key-sequence "fd"))

;; https://github.com/joaotavora/yasnippet/issues/998
;; (defun my-yas-try-expanding-auto-snippets ()
;;   (when (and (boundp 'yas-minor-mode) yas-minor-mode)
;;     (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
;;       (yas-expand))))
;; (add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)

(with-eval-after-load 'emacs
  ;; Enable indentation+completion using the TAB key
  (setq tab-always-indent 'complete)

  ;; Emacs 30+: Disable Ispell completion function
  (setq text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which don't apply to the current mode
  (setq read-extended-command-predicate #'command-completion-default-include-p))

(defun +my-setup-cape-dict-h ()
  (when (derived-mode-p 'text-mode)
    (add-hook 'completion-at-point-functions #'cape-dict 'append 'local)
    
    ;; Use the clean list we just generated
    (when (and (bound-and-true-p jinx-languages)
               (string-match-p "fr" jinx-languages)
               (not (string-match-p "dict-fr" cape-dict-file)))
      (setq-local cape-dict-file "~/.config/aspell/dict-fr.txt"))))

(add-hook! 'doom-switch-buffer-hook #'+my-setup-cape-dict-h)

(use-package tempel
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :init
  
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions)))

  (add-hook! '(conf-mode-hook prog-mode-hook text-mode-hook)
             #'tempel-setup-capf))

(defun tempel-case-match (elt fields)
  (pcase elt
    (`(c ,text)
     (let ((at-start (save-excursion
                       (skip-chars-backward " \t")
                       (or (bobp)
                           (bolp)
                           (memq (char-before) '(?. ?? ?!))
                           (looking-back "^\\s-*[*\\-]+" (line-beginning-position))))))
       (if (and at-start (> (length text) 0))
           (concat (upcase (substring text 0 1)) (substring text 1))
         text)))))

(use-package tempel-collection)

(add-to-list 'tempel-user-elements #'tempel-case-match)

(+global-word-wrap-mode +1)
(add-hook 'writeroom-mode-hook #'+word-wrap-mode)

(add-to-list 'auto-mode-alist '("\\.pdb\\'" . fundamental-mode))
(add-to-list 'auto-mode-alist '("\\.pml\\'" . python-mode))

;; (setq doom-theme 'doom-gruvbox)
;; (setq doom-theme 'doom-feather-dark)
(setq doom-theme 'doom-myfeather-dark)
;; (setq doom-theme 'doom-myoksolar-light)

(setq doom-font (font-spec
                 :family "DejaVu Sans Mono"
                 :size 18))

(add-to-list 'default-frame-alist '(undecorated . t))
;; (add-to-list 'default-frame-alist '(alpha-background . 96))

(setq display-line-numbers nil)
(setq display-line-numbers-type nil)

(with-eval-after-load 'dirvish
  (setq dirvish-hide-details 't)
  )

;; Defined in ~/.config/emacs/lisp/doom.el
(setopt dotfiles-dir
  (let* ((homedir (getenv-internal "HOME"))
         (dotdir (concat homedir "/dotfiles/")))
    (expand-file-name dotdir)
    ))

(defun my/find-file-in-home ()
  "Find a file under $HOME, starting in minibuffer."
  (interactive)
  (let ((default-directory (getenv-internal "HOME/")))
    (call-interactively #'find-file)))

(defun my/find-file-in-dotfiles ()
  "Find a file under `dotfiles-dir', recursively."
  (interactive) (doom-project-find-file dotfiles-dir))

(map! :leader
      (:prefix "f"
      :desc "dotfiles" "." #'my/find-file-in-dotfiles
      :desc "HOME" "H" #'my/find-file-in-home))

(setq org-image-max-width 500)
(setq +zen-text-scale 0.5)

(with-eval-after-load 'org
  (add-hook! 'org-mode-hook #'org-modern-mode)
  (add-hook! 'org-mode-hook #'+org-pretty-mode)
  (add-hook! 'org-mode-hook #'+zen/toggle)

  ;; TODOs
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (setq org-tag-alist
        '(("baal" . ?b) ("adastra" . ?a) ("question" . ?q)))
  (setq org-log-done t)

  (setq-default org-display-custom-times t)
  (setq org-time-stamp-formats '("<%Y-%m-%d %a %H:%M>" . "<%Y-%m-%d %a %H:%M>"))

  ;; Folding persistence via savefold.el
  (setq org-startup-folded 'showeverything) ; default fold behavior
  (setq savefold-backends '(org))
  (setq savefold-directory (locate-user-emacs-file "savefold"))
  (savefold-mode 1)

  ;; Attach
  (setq org-attach-id-dir "~/org/.attach")
  (setq org-agenda-files (list "~/org"))

  (org-link-set-parameters "zotero"
                           :follow (lambda (path) 
                                     (browse-url (concat "zotero:" path))))
  
  (add-to-list 'org-capture-templates
               '("a" "Appointment" entry (file+headline "~/org/agenda.org" "Inbox")
                 "* %?\n  SCHEDULED: %^T\n  %a" :prepend t))
  )

;; Teach Org's export engine about our custom :adtoc property
;; 1. Teach Org about the new option
(add-to-list 'org-export-options-alist
             '(:adtoc "ADTOC" "adtoc" nil t)) ;; 't' allows it to be read as a boolean/value

(defun my-dynamic-export-exclude-tags (info backend)
  "Dynamically tell Org which tags to ignore based on the backend."
  (cond
   ((eq backend 'typst)
    (plist-put info :exclude-tags (cons "html_only" org-export-exclude-tags)))
   ((eq backend 'html)
    (plist-put info :exclude-tags (cons "pdf_only" org-export-exclude-tags))
    ))
  info)

;; 2. Your streamlined hook
(defun my-org-export-conditional-toc (info backend)
  "Dynamically enable/disable TOC based on backend and ADTOC property."
  
  (let ((my-custom-adtoc-value (plist-get info :adtoc)))
    
    (if my-custom-adtoc-value
        (cond
         ((eq backend 'html)
          (plist-put info :with-toc nil))
         ((eq backend 'typst)
          (plist-put info :with-toc t)))
      ))
  info)

(add-hook 'org-export-filter-options-functions #'my-org-export-conditional-toc)

(defun my-org-export-ignore-headlines (data backend info)
  "Remove headlines tagged 'ignore', retain contents, and promote children.
Operates directly on the Org AST."
  (org-element-map data 'headline
    (lambda (object)
      (when (member "ignore" (org-element-property :tags object))
        (let ((level-top (org-element-property :level object))
              level-diff)
          (mapc (lambda (el)
                  ;; Recursively promote all nested child headlines
                  (org-element-map el 'headline
                    (lambda (el)
                      (when (equal 'headline (org-element-type el))
                        (unless level-diff
                          (setq level-diff (- (org-element-property :level el)
                                              level-top)))
                        (org-element-put-property el
                                                  :level (- (org-element-property :level el)
                                                            level-diff)))))
                  ;; Insert the contents back into the parse tree
                  (org-element-insert-before el object))
                (org-element-contents object)))
        ;; Remove the original headline node
        (org-element-extract-element object)))
    info nil)
  data)

;; Add it to the AST parsing hook
(add-hook 'org-export-filter-parse-tree-functions #'my-org-export-ignore-headlines)

(with-eval-after-load 'org-modern
  (setq org-modern-fold-stars '(("▸" . "▾"))))

(use-package org-transclusion
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

(with-eval-after-load 'org-download
  ;; Fix the underscore prefix issue
  (setq org-download-timestamp "%Y%m%d-%H%M%S")
  (setq org-download-screenshot-method "flameshot gui --raw > %s")

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

; (use-package org-img
;   :after org
;   :config
;   (setq org-inkscape-base-directory "~/org/inkscape/"
;         org-inkscape-image-type 'svg)  ; or 'png if you prefer
;   (add-hook 'org-mode-hook #'org-inkscape-mode))

;; Ensure it's attached to the export hook
;; (add-hook 'org-export-before-parsing-hook #'my-org-export-inkscape-as-file)

(setopt org-img-dir "~/org/img/")
(add-hook 'org-mode-hook #'org-img-mode)
; (use-package org-img
;   :after org
;   :config
;   (setq org-img-dir "~/org/img/"
;   (add-hook 'org-mode-hook #'org-img-mode)))

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
      (:prefix-map ("t" . "toggle")
       :desc "Toggle window split" "W" #'toggle-window-split))

(use-package gptel
  :config
  (gptel-make-openai "Mistral"
  :host "api.mistral.ai"
  :endpoint "/v1/chat/completions"
  :models '("mistral-small-latest" "mistral-large-latest" "codestral-latest" "ministral-8b-latest")
  :key #'gptel-api-key-from-auth-source)

   ;; OpenRouter offers an OpenAI compatible API
  (gptel-make-openai "OpenRouter"
  :host "openrouter.ai"
  :endpoint "/api/v1/chat/completions"
  :stream t
  :key #'gptel-api-key-from-auth-source
  :models '(openai/gpt-oss-120b:free
            tngtech/deepseek-r1t2-chimera:free))

  ;; Default model + backend
  (setopt gptel-backend (gptel-get-backend "Mistral"))
  (setopt gptel-model 'mistral-large-latest)
  (setopt gptel-prompt-prefix-alist '((markdown-mode . "*User:*\n") (org-mode . "*User:*\n") (text-mode . "*User:*\n")))
  (setopt gptel-response-prefix-alist '((markdown-mode . "/Assistant:/\n") (org-mode . "/Assistant:/\n") (text-mode . "/Assistant:/\n")))
  (setopt gptel-default-mode 'org-mode))

(use-package gptel-prompts
  :after (gptel)
  :demand t
  :config
  (setq gptel-prompts-directory "~/org/gptel_prompts")
  (gptel-prompts-update)
  ;; Ensure prompts are updated if prompt files change
  (gptel-prompts-add-update-watchers)
  )

(use-package gptel-commit
  :ensure t
  :after (gptel magit)
  :custom
  (gptel-commit-stream t))

(setq org-cite-csl-styles-dir "/mnt/c/Users/martb/Documents/zotero-system/styles")
(setopt bibtex-completion-bibliography '("~/zotero-lib/referenciator.bib"))
(setopt bibtex-completion-library-path '("~/zotero-lib/referenciator.bib"))

(with-eval-after-load 'citar
  (setopt citar-bibliography '("~/zotero-lib/referenciator.bib"))
  (setopt citar-file-open-functions (list (cons "html" #'citar-file-open-external)
                                          (cons "pdf" #'citar-file-open-external)
                                          (cons t #'find-file)))

  (setopt citar-library-paths '("~/zotero-lib/"))

  (defun my-citar-open-in-zotero ()
    "Open current entry in Zotero instead of opening files."
    (interactive)
    (let ((citekey (citar-select-ref)))
      (citar-open-entry-in-zotero citekey))))

(defun markdown-to-org-links ()
  "Convert markdown links [text](url) to org links [[url][text]]
Works on selected region if active, otherwise on whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (save-restriction
          (narrow-to-region (region-beginning) (region-end))
          (goto-char (point-min))
          (while (re-search-forward "\\[\\([^]]+\\)\\](\\([^)]+\\))" nil t)
            (replace-match "[[\\2][\\1]]")))
      (progn
        (goto-char (point-min))
        (while (re-search-forward "\\[\\([^]]+\\)\\](\\([^)]+\\))" nil t)
          (replace-match "[[\\2][\\1]]"))))))

(defun my/insert-zotero-notes ()
  "Select a citation via Citar, fetch its notes via Python, and insert at point."
  (interactive)
  (let* ((selection (citar-select-ref))
         (citation-key (if (listp selection) (car selection) selection)))
    
    (if (or (not citation-key) (string-empty-p citation-key))
        (message "No reference selected.")
      
      (let* ((script-path (expand-file-name "/home/bari-garnier/scripts/python/zotero_content.py"))
             (python-cmd "/home/bari-garnier/.venv/bin/python")
             (cmd (format "%s \"%s\" \"%s\"" python-cmd script-path citation-key)))
        
        (message "Fetching notes for %s..." citation-key)
        
        (let ((output (shell-command-to-string cmd)))
          (if (string-empty-p output)
              (message "Script ran but returned no output.")
            (insert output)
            (message "Done.")))))))

(with-eval-after-load 'markdown-mode
  (setq-hook! 'markdown-mode-hook
    markdown-hide-markup t
    markdown-hide-urls t
    markdown-italic-underscore t
    markdown-fontify-code-blocks-natively t
    markdown-gfm-additional-languages '("sh" "json" "elisp")
    markdown-asymmetric-header t)
  (add-hook! 'markdown-mode-hook #'writeroom-mode))

(custom-set-faces!
  '(markdown-header-face-1 :inherit outline-1)
  '(markdown-header-face-2 :inherit outline-2)
  '(markdown-header-face-3 :inherit outline-3)
  '(markdown-header-face-4 :inherit outline-4)
  '(markdown-header-face-5 :inherit outline-5)
  '(markdown-header-face-3 :inherit outline-6))

(with-eval-after-load 'projectile
  (setopt magit-repository-directories
         (mapcar (lambda (dir) (cons dir 0))
                 projectile-known-projects)))

(defun my/update-magit-repos ()
  "Update magit-repository-directories from projectile-known-projects."
  (interactive)
  (setq magit-repository-directories
        (mapcar (lambda (dir) (cons dir 0))
                projectile-known-projects)))

(setopt magit-repolist-columns
      '(("Name"    25 magit-repolist-column-ident                  ())
        ("Flags"    5 magit-repolist-column-flags                  ())
        ("Branch"  15 magit-repolist-column-branch                 ())
        ("↓"        3 magit-repolist-column-unpulled-from-upstream ((:right-align t) (:sort <)))
        ("↑"        3 magit-repolist-column-unpushed-to-upstream   ((:right-align t) (:sort <)))
        ("Path"    99 magit-repolist-column-path                   ())))


(map! :leader
      (:prefix "g l"
      :desc "update" "u" #'my/update-magit-repos))

(use-package gt
  :config
  (setq gt-default-translator
        (gt-translator
         :taker (gt-taker :langs '(en fr) :text 'sentence :prompt t)
         :engines (list
                   (gt-bing-engine :if 'word)
                   (gt-deepl-engine :if 'not-word))
         :render (gt-insert-render :type 'replace)))
  
  (setq gt-preset-translators
      `((replacer . ,(gt-translator
         :taker (gt-taker :langs '(en fr) :text 'sentence :prompt t)
         :engines (list
                   (gt-bing-engine :if 'word)
                   (gt-deepl-engine :if 'not-word))
         :render (gt-insert-render :type 'replace)))
        (translator . ,(gt-translator
                  :taker (gt-taker :langs '(en fr) :text 'sentence :prompt t)
                  :engines (list
                          (gt-google-engine :if 'word)
                          (gt-deepl-engine :if 'not-word))
                  :render (list
                            (gt-overlay-render :type 'replace :if 'not-word)
                            (gt-buffer-render :if 'word)
                           ))))))

(map! :leader
    (:prefix ("t t" . "translate")
    :desc "Switch translator" "s" #'gt-switch-translator
    :desc "Dismiss overlays" "d" #'gt-delete-render-overlays
    :desc "Translate" "t" #'gt-translate))

;; (setq langtool-language-tool-jar "~/LanguageTool-6.6/languagetool-commandline.jar")
;; (require 'langtool)

(use-package jinx
  ;; :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(with-eval-after-load 'jinx
  ;; Limitations:
  ;; 1. since raw block highlighting let the local parser highlights the area,
  ;; some area doesn't contain face (like `bash-ts-mode'), and those areas will
  ;; be checked by jinx
  (add-to-list
   'jinx-exclude-faces
   '(typst-ts-mode
     ;; not included font lock faces
     ;; `font-lock-comment-face', `font-lock-string-face', `font-lock-doc-face'
     ;; `font-lock-doc-markup-face'
     font-lock-warning-face font-lock-function-name-face font-lock-function-call-face
     font-lock-variable-name-face font-lock-variable-use-face font-lock-keyword-face
     font-lock-comment-delimiter-face font-lock-type-face font-lock-constant-face
     font-lock-builtin-face font-lock-preprocessor-face
     font-lock-negation-char-face font-lock-escape-face font-lock-number-face
     font-lock-operator-face font-lock-property-use-face font-lock-punctuation-face
     font-lock-bracket-face font-lock-delimiter-face font-lock-misc-punctuation-face
     ;; typst-ts-mode created faces
     typst-ts-markup-item-indicator-face typst-ts-markup-term-indicator-face
     typst-ts-markup-rawspan-indicator-face typst-ts-markup-rawspan-blob-face
     typst-ts-markup-rawblock-indicator-face typst-ts-markup-rawblock-lang-face
     typst-ts-markup-rawblock-blob-face
     typst-ts-error-face typst-ts-shorthand-face typst-ts-markup-linebreak-face
     typst-ts-markup-quote-face typst-ts-markup-url-face typst-ts-math-indicator-face)))

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

(use-package blender
  :defer t
  :commands (blender-mode blender-start blender-run-current-buffer)
  :init
  :custom
  (blender-executable "blender")
  (blender-addon-directory "")
  (blender-external-python "/data/bari-garnier/blender/blender_env/bin/activate")
  )

(use-package typst-preview
  :custom
  (typst-preview-browser "default")
  (typst-preview-open-browser-automatically t)
  (typst-preview-executable "~/.config/emacs/.local/cache/.cache/lsp/tinymist/tinymist")
  (typst-preview-autostart t)
  (typst-preview-invert-colors "never"))

(use-package typst-ts-mode
  :custom
  (typst-ts-watch-options "--open")
  (typst-ts-mode-grammar-location (expand-file-name "tree-sitter/libtree-sitter-typst.so" user-emacs-directory))
  (typst-ts-mode-enable-raw-blocks-highlight t)
  :config
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu))

;; (use-package org-typst
;;   :after org)

(with-eval-after-load 'eglot
  (with-eval-after-load 'typst-ts-mode
    (add-to-list 'eglot-server-programs
                 `((typst-ts-mode) .
                   ,(eglot-alternatives `(,typst-ts-lsp-download-path
                                          "tinymist"
                                          "typst-lsp"))))))

(with-eval-after-load 'cc-mode
  (set-eglot-client! 'cc-mode '("clangd" "-j=3" "--clang-tidy")))

(with-eval-after-load 'python
  (set-eglot-client! '(python-mode python-ts-mode) '("ty" "server"))
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))

(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe
                                      :noquery t))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
      (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

;; For niri to toggle a notepad
(defun toggle-named-frame (frame-name &rest frame-params)
  "Toggle a frame with FRAME-NAME. Create if doesn't exist, delete if exists.
When created, opens a persistent Doom scratch buffer in writeroom-mode.
FRAME-PARAMS are additional frame parameters passed as keyword-value pairs."
  (let ((target-frame (seq-find 
                       (lambda (f) 
                         (string= (frame-parameter f 'name) frame-name))
                       (frame-list))))
    (if target-frame
        (delete-frame target-frame)
      (let ((frame (make-frame (append `((name . ,frame-name)) frame-params))))
        (with-selected-frame frame
          (let ((scratch-buf (doom-scratch-buffer nil nil default-directory frame-name)))
            (switch-to-buffer scratch-buf)
            (org-mode)
            (writeroom-mode 1)))
        frame))))
