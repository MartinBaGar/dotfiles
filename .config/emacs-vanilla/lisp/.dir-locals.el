;; lisp/.dir-locals.el
((org-mode . ((eval . (add-hook 'after-save-hook #'org-babel-tangle nil t)))))
