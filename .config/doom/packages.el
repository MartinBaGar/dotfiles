;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)

                                        ; (package! org-pandoc-import
                                        ;   :recipe (:host github
                                        ;            :repo "tecosaur/org-pandoc-import"
                                        ;            :files ("*.el" "filters" "preprocessors")))

;; Org mode
(package! org-modern)
(package! org-transclusion)
(package! savefold :recipe (:host github :repo "jcfk/savefold.el"))
(package! ox-typst)
(package! gnuplot :pin "7138b139d2dca9683f1a81325c643b2744aa1ea3")

;; AI
(package! whisper :recipe (:host github :repo "natrys/whisper.el"))
(package! gptel-prompts :recipe (:host github :repo "jwiegley/gptel-prompts"))
(package! gptel-commit :recipe (:host github :repo "lakkiy/gptel-commit"))
(package! gptel-agent)

;; Editor
(package! jinx)
(package! tempel :recipe (:host github :repo "minad/tempel"))
(package! tempel-collection :recipe (:host github :repo "Crandel/tempel-collection"))
(package! eglot-tempel :recipe (:host github :repo "fejfighter/eglot-tempel"))
(package! gt)
(package! magit-todos)

;; Modes
(package! typst-ts-mode :recipe (:host nil :repo "https://git.sr.ht/~meow_king/typst-ts-mode"))
(package! typst-preview :recipe (:host github :repo "havarddj/typst-preview.el"))
(package! popper :recipe (:host github :repo "karthink/popper"))
(package! code-cells :recipe (:host github :repo "astoff/code-cells.el"))
(package! gnuplot-mode :pin "601f6392986f0cba332c87678d31ae0d0a496ce7")

;; Hard dependencies for jupyter
(package! zmq)
(package! websocket)
(package! simple-httpd)
;; The jupyter package itself
(package! emacs-jupyter :recipe (:host github :repo "emacs-jupyter/jupyter"))

;; My packages
(package! org-img :recipe (:host github :repo "MartinBaGar/org-img"))
;; (package! org-typst :recipe (:host github :repo "MartinBaGar/org-typst"))
(package! blender :recipe (:host github :repo "MartinBaGar/blender.el" :files ("*.el" "*.py")))
;; (package! gdoc-handler :recipe (:host github :repo "MartinBaGar/gdoc-handler"))

;; Waiting for approval
