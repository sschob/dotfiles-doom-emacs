;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("srcarticle"
                 "\\documentclass[11pt]{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (setq org-latex-packages-alist
        (append org-latex-packages-alist
                '(("AUTO" "babel")
                  ("" "csquotes"))))

  (add-to-list 'org-latex-packages-alist '("" "wrapfig")))

(setq org-latex-compiler "lualatex")
(setq org-latex-src-block-backend 'engraved)

(setq org-latex-engraved-options
      '(("commandchars" . "\\\\\\{\\}") ("highlightcolor" . "white!95!black!80!blue")
        ("breaklines" . "true")
        ("numbers" . "left")
        ("breaksymbol" . "\\color{white!60!black}\\tiny\\ensuremath{\\hookrightarrow}")))

(after! org
  (setq org-preview-latex-default-process 'imagemagick)
  (setq org-preview-latex-process-alist
        '((imagemagick :programs ("lualatex" "convert")
           :description "Convert LaTeX to PNG using LuaLaTeX and ImageMagick"
           :message "Compiling LaTeX fragment with LuaLaTeX..."
           :image-input-type "pdf"
           :image-output-type "png"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler ("lualatex -interaction nonstopmode -output-directory %o %f")
           :image-converter ("convert -density 300 -trim -quality 100 %f %O"))))
  ;; (setq org-latex-packages-alist
  ;;       '(("" "tikz" t)
  ;;         ("" "tikz-qtree" t)
  ;;         ("noend" "algpseudocode" t)))

  ;; (setq org-latex-preamble "\\usetikzlibrary{arrows.meta, positioning, automata, chains, scopes}")

  (setq org-format-latex-header
        (concat org-format-latex-header
                "\n\\usepackage{tikz}"
                "\n\\usetikzlibrary{arrows.meta, positioning, automata, chains, scopes}"
                "\n\\usepackage[noend]{algpseudocode}"))

  (setq! citar-bibliography '("~/Sync/bibliography/MyLibrary.bib")))
;; end after! org

(after! org
  (defun my/org-name-latest-clocktable (name)
    "Insert #+NAME: name before first table after point."
    (save-excursion
      (when (re-search-forward "^|.*" nil t)
        (beginning-of-line)
        (insert (format "#+NAME: %s\n" name)))))

  (defun my/org-auto-name-clocktable (&rest _)
    "Auto-name clocktable result using :name from BEGIN line."
    (message "Running clocktable advice")
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^#\\+BEGIN: clocktable.*:name \\(\\S-+\\)" nil t)
        (let ((name (match-string 1)))
          (forward-line)
          (when (re-search-forward "^|.*" nil t)
            (beginning-of-line)
            (unless (save-excursion (forward-line -1) (looking-at "^#\\+NAME:"))
              (insert (format "#+NAME: %s\n" name))))))))

  (advice-add 'org-update-dblock :after #'my/org-auto-name-clocktable))

;;; workaround for this https://github.com/emacs-jupyter/jupyter/issues/607
;;; Stand 22.04.26
(after! jupyter-org-client
  (defun my/jupyter-org-results-drawer-pre-blank-fix (element)
    "Advice to ensure the RESULTS drawer has a :pre-blank 0 property.
     This prevents 'wrong-type-argument wholenump nil' errors in newer Org versions."
    (if (and element (eq (org-element-type element) 'drawer))
        (progn
          (org-element-put-property element :pre-blank 0)
          element)
      element))
  (advice-add 'jupyter-org-results-drawer
              :filter-return
              #'my/jupyter-org-results-drawer-pre-blank-fix))

(after! ob-core
  (require 'ansi-color)

  (defun my/org-babel-ansi-colorize-results ()
    (when-let* ((result (org-babel-where-is-src-block-result))
                (end (save-excursion
                       (goto-char result)
                       (org-babel-result-end))))
      (ansi-color-apply-on-region result end)))

  (add-hook 'org-babel-after-execute-hook
            #'my/org-babel-ansi-colorize-results))

(after! citar
  (setq citar-file-open-functions '(("html" . citar-file-open-external)
                                    ("pdf" . citar-file-open-external)
                                    (t . find-file))))

(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(with-eval-after-load 'gptel
  (setq gptel-default-mode 'org-mode)

  (setq gptel-model 'mistral-large-3-675b-instruct-2512)
  (setq
   gptel-backend
   (gptel-make-openai "gwdg"
     :host "chat-ai.academiccloud.de"
     :endpoint "/v1/chat/completions"
     :stream t
     :key gptel-api-key
     :models '(
               (meta-llama-3.1-8b-instruct
                :description
                "Meta Llama 3.1 8B Instruct; dez 2023; text only"
                )
               (openai-gpt-oss-120b
                :description
                "Open AI open weight model"
                )
               (mistral-large-3-675b-instruct-2512
                :description
                "Mistral Large 3 675B Instruct 2512; dez 2025; vision"
                )
               qwen3-235b-a22b
               qwen2.5-coder-32b-instruct
               qwen3-30b-a3b-instruct-2507
               (apertus-70b-instruct-2509
                :description
                "Fully open-source, Multilingual; text"
                )
               (devstral-2-123b-instruct-2512
                :description
                "agentic LLM for software engineering task"
                )
               deepseek-r1-distill-llama-70b
               (internvl3.5-30b-a3b
                :description
                "OpenGVLa Vision, lightweight and fast (Aug 2025)")
               (qwen3-vl-30b-a3b-instruct
                :description
                "Qwen 3 VL 30B A3B Instruct; text/image/video"
                )
               (glm-4.7
                :description
                "glm-4.7; text; use for coding"
                )))))


;; taken from https://github.com/doomemacs/doomemacs/issues/581#issuecomment-434449160

(defun doom--get-modules (file)
  (unless (file-exists-p file)
    (user-error "%s does not exist" file))
  (with-temp-buffer
    (insert-file-contents file)
    (when (re-search-forward "(doom! " nil t)
      (goto-char (match-beginning 0))
      (cdr (sexp-at-point)))))

(defun doom--put-modules (tmpfile modules)
  (with-temp-file tmpfile
    (delay-mode-hooks (emacs-lisp-mode))
    (insert (replace-regexp-in-string " " "\n" (prin1-to-string modules)))
    (indent-region (point-min) (point-max))))

;;;###autoload
(defun doom/what-has-changed ()
  "Open an ediff session to compare the module list in
  ~/.emacs.d/init.example.el and ~/.doom.d/init.el."
  (interactive)
  (let ((old-modules (doom--get-modules (expand-file-name "static/init.example.el" doom-emacs-dir)))
        (new-modules (doom--get-modules (expand-file-name "init.el" doom-private-dir)))
        (example-init-el "/tmp/doom-init.example.el")
        (private-init-el "/tmp/doom-private-init.el"))
    (doom--put-modules example-init-el old-modules)
    (doom--put-modules private-init-el new-modules)
    (ediff private-init-el example-init-el)))

;;(setq doom-font (font-spec :family "IosevkaTerm Nerd Font" :size 14))
;;(setq doom-variable-pitch-font (font-spec :family "IosevkaTerm Nerd Font" :size 14))
