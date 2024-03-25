;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;(setq user-full-name (getenv "USER_FULL_NAME")
;-     user-mail-address (getenv "USER_EMAIL"))

(let ((personal-settings "~/.doom.d/myenv.el"))
 (when (file-exists-p personal-settings)
   (load-file personal-settings)))
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; should be set before the package loads
(setq org-roam-directory "~/.deft")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(use-package! ox-ipynb
  ;; :hook (prog-mode . org-mode)
  :init
  ;; code here will run immediately
  :config
  ;;  code here will run after the package is loaded
  )

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; disable right option modifier to typeset certain symbols
(setq mac-right-option-modifier nil)
;; tried this use !after, but does not work
;; (after! macos
;;   (setq mac-right-option-modifier nil))

;; set-key for easier backslash
(global-set-key (kbd "s-ß") (kbd "\\"))

(after! org
  ; (load-file "~/.doom.d/clock-setup.el")
  (setq org-directory "~/org"
        org-agenda-files (quote ("~/org/lehre.org"
                                 "~/org/projects.org"
                                 "~/org/todo.org"
                                 "~/org/privat.org"
                                 "~/org/hse.org"
                                 "~/org/notes.org"
                                 "~/vorlesungen/TIB_ML/readme.org"
                                 "~/vorlesungen/AdvDM/readme.org"))
        org-todo-keywords (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING")))))


(after! ox-latex
  (setq org-latex-listings 'minted
        org-latex-pdf-process '("latexmk -pdf -shell-escape -output-directory=%o %f"))

  (add-to-list 'org-latex-packages-alist '("" "minted" ))
  (add-to-list 'org-latex-classes
               '("koma-article" "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("beamerS" "\\documentclass[presentation]{beamerswitch}"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
               ))

(after! citar
  (setq! citar-bibliography  '("~/Sync/bibliography/MyLibrary.bib"))
  (setq! citar-notes-path "~/Sync/notes/")
  (setq! citar-library-paths '("~/Sync/bibliography/"))
  )

;(after! org-cite
;  (setq! org-cite-insert-processor 'citar)
;  (setq! org-cite-follow-processor 'citar)
;  (setq! org-cite-activate-processor 'citar))

;; +biblio-default-bibliography-files (concat (getenv "HOME") "/Dropbox/bibliography/MyLibrary.bib") ;'("/path/to/bibliography.bib")
;;https://github.com/jkitchin/org-ref/issues/757
;;+biblio-notes-path (concat (getenv "HOME") "/Sync/notes/"))
;; config for biblio
;(setq! +biblio-pdf-library-dir "~/Dropbox/bibliography/"
;       +biblio-default-bibliography-files '("~/Dropbox/bibliography/MyLibrary.bib")
;       +biblio-notes-path "~/Sync/notes/")
;
(setq bibtex-dialect 'biblatex);
; Workaround https://github.com/jkitchin/org-ref/issues/845#
;; (setq orhc-candidate-formats '(
;;                                ("online" . "|${=key=}| ${author}, ${title}, (${year})")
;;                                ("audio" . "|${=key=}| ${author}, ${title}")
;;                                ("article" . "|${=key=}| ${author}, ${title}, ${journal} (${year}). ${keywords}")
;;                                ("book" . "  |${=key=}| ${author}, ${title} (${year}) ${keywords}.")
;;                                ("inbook" . "  |${=key=}| ${author}, ${chapter} in ${title} (${year}) ${keywords}")
;;                                ("techreport" . "  |${=key=}| ${title}, ${institution} (${year}). ${keywords}")
;;                                ("inproceedings" . "  |${=key=}| ${author}, ${title} in ${booktitle} (${year}). ${keywords}")
;;                                ("incollection" . "  |${=key=}| ${author}, ${title} in ${booktitle} (${year}). ${keywords}")
;;                                ("phdthesis" . "  |${=key=}| ${author}, ${title}, ${school} (${year}). Phd thesis. ${keywords}")
;;                                ("mastersthesis" . "  |${=key=}| ${author}, ${title}, ${school} (${year}). MS thesis. ${keywords}")
;;                                ("misc" . "  |${=key=}| ${author}, ${title}")
;;                                ("unpublished" . "  |${=key=}| ${author}, ${title}")))
;
;; (use-package! org-download
;;   :commands
;;   org-download-dnd
;;   org-download-yank
;;   org-download-screenshot
;;   org-download-dnd-base64
;;   :config
;;   (setq org-download-image-dir "./images"
;;         org-download-link-format "[[file:%s]]\n"
;;         org-download-method 'directory
;;         org-download-heading-lvl nil
;;         org-download-timestamp "_%Y%m%d_%H%M%S"
;;         org-download-screenshot-method
;;         (cond (IS-MAC "screencapture -i %s")
;;               (IS-LINUX
;;                (cond ((executable-find "maim")  "maim -s %s")
;;                      ((executable-find "scrot") "scrot -s %s")
;;                      ((executable-find "gnome-screenshot") "gnome-screenshot -a -f %s")))))
;;  )
(use-package! pet
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))
