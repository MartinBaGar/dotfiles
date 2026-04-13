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

;; =============================================================================
;; EVIL MACRO MODE (THE TRUE FIX)
;; =============================================================================

;; 1. Variable to remember which register we are editing
(defvar my/edit-macro-register nil
  "Remembers which Evil register is currently being edited.")

;; 2. Edit Macro Function
(defun my/edit-evil-macro (register)
  "Edit the macro stored in an Evil REGISTER."
  (interactive "cEdit macro in register: ")
  (let ((macro (evil-get-register register t)))
    (cond
     ((null macro)
      (user-error "Register '%c' is empty" register))
     ((or (stringp macro) (vectorp macro))
      (setq my/edit-macro-register register)
      (setq last-kbd-macro macro)
      (kmacro-edit-macro)
      (message "Editing register '%c'. Press C-c C-c to save changes." register))
     (t
      (user-error "Register '%c' doesn't contain a macro" register)))))

;; 3. The Save Hook (Advise the CORRECT function: edmacro-finish-edit)
(defun my/save-evil-macro-advice (&rest _)
  "Save the compiled macro back to the Evil register."
  (when my/edit-macro-register
    ;; edmacro-finish-edit has just successfully compiled your changes 
    ;; and placed them into last-kbd-macro. We scoop it up and save it!
    (evil-set-register my/edit-macro-register last-kbd-macro)
    (message "SUCCESS: Macro saved back to register '%c'. Use @%c to execute." 
             my/edit-macro-register my/edit-macro-register)
    (setq my/edit-macro-register nil)))

;; Attach the advice to run IMMEDIATELY AFTER Emacs closes the editor
(advice-add 'edmacro-finish-edit :after #'my/save-evil-macro-advice)

;; 4. Assign Emacs kmacro to Evil
(defun my/kmacro-to-evil-register (register)
  "Assign the last keyboard macro to an Evil REGISTER."
  (interactive "cAssign last kmacro to register: ")
  (if last-kbd-macro
      (progn
        (evil-set-register register last-kbd-macro)
        (message "Macro assigned to register '%c'. Use @%c to execute." register register))
    (user-error "No keyboard macro defined")))

;; 5. Show Macros
(defun my/show-evil-macros ()
  "Display a-z registers containing text or keyboard macros."
  (interactive)
  (with-output-to-temp-buffer "*Evil Macros*"
    (princ "Evil Macro Registers (a-z):\n")
    (princ "---------------------------\n")
    (let ((found-any nil))
      (dolist (reg register-alist)
        (let ((key (car reg))
              (val (cdr reg)))
          (when (and (>= key ?a) (<= key ?z))
            (when (or (vectorp val) (stringp val))
              (setq found-any t)
              (princ (format "Register [%c]: %s\n" key (format-kbd-macro val)))))))
      (unless found-any
        (princ "No macros found in a-z registers.\n")))))

;; 6. Export Macro Code
(defun my/save-evil-macro-to-kill-ring (register)
  "Copy the macro in REGISTER to kill ring as elisp code."
  (interactive "cCopy macro from register: ")
  (let ((content (evil-get-register register t)))
    (if (and content (or (vectorp content) (stringp content)))
        (let ((code (format "(evil-set-register ?%c %S)" register content)))
          (kill-new code)
          (message "Copied to kill ring: %s" code))
      (user-error "Register '%c' doesn't contain a macro" register))))

;; =============================================================================
;; KEYBINDINGS
;; =============================================================================
(map! :leader
      (:prefix ("k" . "macros")
       :desc "Edit Evil macro"           "e" #'my/edit-evil-macro
       :desc "Show Evil macros"          "s" #'my/show-evil-macros
       :desc "Assign kmacro to register" "a" #'my/kmacro-to-evil-register
       :desc "Copy macro code"           "c" #'my/save-evil-macro-to-kill-ring))

(use-package tempel
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :init
  
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions)))

  (add-hook! '(conf-mode-hook prog-mode-hook text-mode-hook)
             #'tempel-setup-capf)
  (setopt tempel-path (concat (expand-file-name "templates" user-emacs-directory) "/*"))
  )

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

(defun my/open-tempel-templates ()
  (interactive)
    (find-file (f-dirname tempel-path)))

(use-package tempel-collection)

(add-to-list 'tempel-user-elements #'tempel-case-match)

(+global-word-wrap-mode +1)
(add-hook 'writeroom-mode-hook #'+word-wrap-mode)

;; (setq org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
(setq org-re-reveal-revealjs-version nil)
(setq org-re-reveal-transition "none")
(setq org-re-reveal-theme "white")
(setq org-re-reveal-extra-options "none")
(setq org-re-reveal-extra-options "display: 'flex'")
(setq org-re-reveal-slide-container "<div class=\"slide-body\">%s</div>")
(setq org-re-reveal-width 1280)
(setq org-re-reveal-height 720)
(setq org-re-reveal-margin "0.04")
(setq org-re-reveal-center nil)
(setq org-re-reveal-title-slide "<h1>%t</h1><h2>%a</h2>")

(add-to-list 'auto-mode-alist '("\\.pdb\\'" . fundamental-mode))

;; Load ox-typst after org is loaded
(use-package! ox-typst
  :after org)

;; Load ox-hugo after the ox exporter framework is loaded
(use-package! ox-hugo
  :after ox)

;; (setq doom-theme 'doom-myfeather-dark)
;; (setq doom-theme 'doom-myoksolar-light)
(setq doom-theme 'modus-operandi-tinted)

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
  (setq org-timestamp-formats '("%Y-%m-%d %a" . "%Y-%m-%d %a %H:%M"))
  
  (org-link-set-parameters "zotero"
                           :follow (lambda (path) 
                                     (browse-url (concat "zotero:" path))))
  
  (add-to-list 'org-capture-templates
               '("a" "Appointment" entry (file+headline "~/org/agenda.org" "Inbox")
                 "* %?\n  SCHEDULED: %^T\n  %a" :prepend t))
  )

;; 1. Register ADTOC
(with-eval-after-load 'ox
  (add-to-list 'org-export-options-alist
               '(:adtoc "ADTOC" "adtoc" nil t)))

;; 2. Exclude Tags Function
(defun my-dynamic-export-exclude-tags (info backend)
  "Dynamically tell Org which tags to ignore based on the backend."
  (cond
   ((eq backend 'typst)
    (plist-put info :exclude-tags (cons "html_only" org-export-exclude-tags)))
   ((eq backend 'html)
    (plist-put info :exclude-tags (cons "pdf_only" org-export-exclude-tags))))
  info)

;; IMPORTANT: Attach to filter-options-functions (which provides 2 arguments)
(add-hook 'org-export-filter-options-functions #'my-dynamic-export-exclude-tags)

;; 3. Conditional TOC Function
(defun my-org-export-conditional-toc (info backend)
  "Dynamically enable/disable TOC based on backend and ADTOC property."
  (message "export conditional toc has been called")
  (let ((my-custom-adtoc-value (plist-get info :adtoc)))
    (if my-custom-adtoc-value
        (cond
         ((eq backend 'html)
          (plist-put info :with-toc nil))
         ((eq backend 'typst)
          (plist-put info :with-toc t)))))
  info)

;; Attach to filter-options-functions
(add-hook 'org-export-filter-options-functions #'my-org-export-conditional-toc)

;; 4. Ignore Headlines Function (AST)
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

(defun my/message-org-link-at-point ()
  "Copy the org link at point to the kill ring."
  (interactive)
  (let ((link (org-element-property :path (org-element-context))))
    (if link
        (progn (kill-new link)
               (message "Copied: %s" link))
      (user-error "No link at point"))))

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

;; TODO: solidify the link handling. Didn't work on tranclusion links
(defun my/xdg-open-path-at-point ()
  "Open the file at point with xdg-open."
  (interactive)
  (let ((path (or (org-element-property :path (org-element-context))
                  (thing-at-point 'filename t))))
    (cond
     ((and path (file-exists-p path))
      (start-process "xdg-open" nil "xdg-open" (expand-file-name path)))
     (t
      (message "No valid file path at point.")))))

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

(defun elabftw--get-id-by-title (title)
  "Get the eLabFTW experiment ID matching TITLE."
  ;; We use `jq --arg t` to safely pass the title without breaking bash quotes
  (let* ((cmd (format "elapi get experiments --format json | jq -r --arg t %s '.[] | select(.title==$t) | .id'"
                      (shell-quote-argument title)))
         (res (string-trim (shell-command-to-string cmd))))
    (if (string= res "") nil res)))

(defun elabftw--get-upload-id (exp-id file-name)
  "Get the upload ID for a file named FILE-NAME in experiment EXP-ID."
  (let* ((cmd (format "elapi get experiments --id %s --format json | jq -r --arg f %s '.uploads[] | select(.real_name==$f) | .id'"
                      exp-id
                      (shell-quote-argument file-name)))
         (res (string-trim (shell-command-to-string cmd))))
    (if (string= res "") nil res)))

;; ==========================================
;; MAIN INTERACTIVE FUNCTIONS
;; ==========================================

(defun my/get-match-exp ()
  "Check if an experiment matching the current buffer's title exists."
  (interactive)
  (let* ((title (org-get-title (current-buffer)))
         (exp-id (elabftw--get-id-by-title title)))
    (if exp-id
        (message "Found experiment '%s' with ID: %s" title exp-id)
      (message "No experiment found matching title: '%s'" title))))

(defun my/update-elabftw-exp-body ()
  "Update the body of the eLabFTW experiment matching the current buffer's title."
  (interactive)
  (let* ((title (org-get-title (current-buffer)))
         (exp-id (elabftw--get-id-by-title title)))
    (if (not exp-id)
        (message "Error: No experiment found with title '%s'" title)
      
      (let* ((body (org-export-as 'html nil nil t))
             ;; Create a temp file and encode the HTML payload directly into JSON
             (temp-file (make-temp-file "elabftw-body-" nil ".json"))
             (json-data (json-encode `((body . ,body)))))
        
        ;; Write JSON to file to bypass bash quoting hell
        (with-temp-file temp-file
          (insert json-data))
        
        (message "Updating experiment '%s' (ID: %s)..." title exp-id)
        
        ;; Pass the JSON file directly to elapi using the -d flag
        (shell-command (format "elapi patch experiments --id %s -d %s" 
                               exp-id 
                               (shell-quote-argument temp-file)))
        
        ;; Cleanup
        (delete-file temp-file)
        (message "Body updated successfully!")))))

(defun my/update-elabftw-exp-pdf ()
  "Exports the current Org buffer to PDF and smart-syncs it to eLabFTW."
  (interactive)
  (let* ((title (org-get-title (current-buffer)))
         (exp-id (elabftw--get-id-by-title title)))
    (if (not exp-id)
        (message "Error: No experiment found with title '%s'" title)
      
      (message "Exporting to PDF...")
      (let* ((pdf-file (org-typst-export-to-pdf))
             (pdf-name (file-name-nondirectory pdf-file))
             (upload-id (elabftw--get-upload-id exp-id pdf-name)))
        
        ;; Smart PDF Sync logic: If PDF already exists, delete it first to keep the archive clean
        (when upload-id
          (message "Deleting old PDF (Upload ID: %s)..." upload-id)
          (shell-command (format "elapi delete experiments -i %s --sub uploads --sub-id %s" exp-id upload-id)))
        
        (message "Uploading new PDF...")
        (shell-command (format "elapi experiments upload-attachment --id %s --path %s --comment %s"
                               exp-id
                               (shell-quote-argument pdf-file)
                               (shell-quote-argument "Uploaded via Emacs")))
        (message "PDF synced successfully!")))))

(defun my/new-exp-from-current-file ()
  "Create a new eLabFTW experiment from the current Org buffer."
  (interactive)
  (let ((title (org-get-title (current-buffer))))
    
    ;; 1. Fast check: Abort immediately if it exists (no files created)
    (when (elabftw--get-id-by-title title)
      (user-error "Experiment '%s' already exists" title))
    
    ;; 2. Heavy work: Only runs if the check passed
    (let* ((body (org-export-as 'html nil nil t))
           (temp-file (make-temp-file "elabftw-new-" nil ".json"))
           (json-data (json-encode `((title . ,title) (body . ,body)))))
      
      (with-temp-file temp-file
        (insert json-data))
      
      (message "Creating new experiment '%s'..." title)
      (shell-command (format "elapi post experiments -d %s" (shell-quote-argument temp-file)))
      
      (delete-file temp-file)
      (message "New experiment created successfully!"))))

(with-eval-after-load 'eglot
  (with-eval-after-load 'typst-ts-mode
    (add-to-list 'eglot-server-programs
                 `((typst-ts-mode) .
                   ,(eglot-alternatives `(,typst-ts-lsp-download-path
                                          "tinymist"
                                          "typst-lsp")))))
  (add-to-list 'eglot-server-programs
               '((web-mode) . ("vscode-html-language-server" "--stdio"))))

(with-eval-after-load 'cc-mode
  (set-eglot-client! 'cc-mode '("clangd" "-j=3" "--clang-tidy")))

(with-eval-after-load 'python
  (set-eglot-client! '(python-mode python-ts-mode) '("ty" "server"))
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))

;; (setq wl-copy-process nil)
;; (defun wl-copy (text)
;;   (setq wl-copy-process (make-process :name "wl-copy"
;;                                       :buffer nil
;;                                       :command '("wl-copy" "-f" "-n")
;;                                       :connection-type 'pipe
;;                                       :noquery t))
;;   (process-send-string wl-copy-process text)
;;   (process-send-eof wl-copy-process))
;; (defun wl-paste ()
;;   (if (and wl-copy-process (process-live-p wl-copy-process))
;;       nil ; should return nil if we're the current paste owner
;;       (shell-command-to-string "wl-paste -n | tr -d \r")))
;; (setq interprogram-cut-function 'wl-copy)
;; (setq interprogram-paste-function 'wl-paste)

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
