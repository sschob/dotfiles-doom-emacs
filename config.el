;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "stoeff00@gmail.com")

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
  (load-file "~/.doom.d/clock-setup.el")
  (setq org-directory "~/org"
        org-agenda-files (quote ("~/org/todo/todo.org"
                                 "~/org/todo.org"
                                 "~/org/todo/bpw.org"
                                 "~/org/todo/privat.org"
                                 "~/org/todo/refile.org"
                                 "~/org/notes.org"
                                 "~/vorlesungen/TIB_ML/readme.org"
                                 "~/vorlesungen/AdvDM/readme.org"))
        org-todo-keywords (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING")))))


(after! ox-latex
  (setq org-latex-listings 'minted
        org-latex-pdf-process '("latexmk -pdf -shell-escape %o %f"))
  (add-to-list 'org-latex-packages-alist '("" "minted" ))
  (add-to-list 'org-latex-classes
               '("koma-article" "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
 )
