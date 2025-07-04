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

;; GPTEL
(use-package! gptel)
;;:config
;;(setq! gptel-api-key "your key"))

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("srcarticle"
                 "\\documentclass[11pt]{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

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

  (setq! citar-bibliography '("/Users/sschober/Sync/bibliography/MyLibrary.bib"))

  )

(after! ox-latex
  (setq org-latex-compiler "lualatex")
  )

(after! citar
  (setq citar-file-open-functions '(("html" . citar-file-open-external)
                                    ("pdf" . citar-file-open-external)
                                    (t . find-file))))

(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(after! gptel
  (setq gptel-default-mode 'org-mode))

(after! org
  (defun +org/preview-export-latex-blocks2 ()
    "Run LaTeX preview for all #+begin_export latex blocks in the buffer."
    (interactive)
    (message "Latex preview started")
    (save-excursion
      (goto-char (point-min))
      (let ((count 0))
        (while (re-search-forward
                "^[ \t]*#\\+begin_export latex[ \t]*\n\\(\\(?:.\\|\n\\)*?\\)^#\\+end_export" nil t)
          (let ((beg (match-beginning 0))
                (end (match-end 0)))
            ;; Temporär 'org-latex-preview' vorgaukeln
            (message "Latex preview: founed block")
            (org--latex-preview-region beg end)
            (cl-incf count)))
        (message "LaTeX preview done. %d blocks rendered." count))))

  (defun +org/preview-export-latex-blocks3 ()
    "Run LaTeX preview for all #+begin_export latex blocks in the buffer."
    (interactive)
    (let ((count 0))
      (org-element-map (org-element-parse-buffer) 'export-block
        (lambda (blk)
          (when (string= (org-element-property :type blk) "LATEX")
            (let ((beg (org-element-property :begin blk))
                  (end (org-element-property :end blk)))
              (message "Latex preview: found export block")
              (org-latex-preview nil beg end)
              (cl-incf count)))))
      (message "LaTeX preview done. %d blocks rendered." count)))

  (defun +org/preview-export-latex-blocks4 ()
    "Render LaTeX previews for all #+begin_export latex blocks."
    (interactive)
    (let ((count 0))
      (save-excursion
        (org-element-map (org-element-parse-buffer) 'export-block
          (lambda (blk)
            (when (string= (org-element-property :type blk) "LATEX")
              (let* ((beg (org-element-property :begin blk))
                     (end (org-element-property :end blk))
                     (contents (org-element-property :value blk))
                     ;; simulate block
                     (image (org-create-formula-image
                             (string-trim contents)
                             (plist-get org-format-latex-options :foreground)
                             (plist-get org-format-latex-options :background)
                             'block
                             (plist-get org-format-latex-options :scale)
                             org-preview-latex-default-process)))
                (when image
                  (let ((ov (make-overlay beg end)))
                    (overlay-put ov 'org-latex-preview t)
                    (overlay-put ov 'display image)
                    (overlay-put ov 'modification-hooks
                                 (list (lambda (o &rest _) (delete-overlay o))))
                    (cl-incf count))))))))
      (message "LaTeX preview done. %d blocks rendered." count)))

  (defun +org/preview-export-latex-blocks ()
    "Render LaTeX previews for all #+begin_export latex blocks."
    (interactive)
    (let ((count 0)
          (opts (list :foreground (face-foreground 'default nil t)
                      :background (face-background 'default nil t)
                      :scale 1.0)))  ;; Optional skalieren
      (save-excursion
        (org-element-map (org-element-parse-buffer) 'export-block
          (lambda (blk)
            (when (string= (org-element-property :type blk) "LATEX")
              (let* ((beg (org-element-property :begin blk))
                     (end (org-element-property :end blk))
                     (contents (org-element-property :value blk))
                     (formula (string-trim contents))
                     (image (org-create-formula-image
                             formula nil opts (current-buffer) org-preview-latex-default-process)))
                (when image
                  (let ((ov (make-overlay beg end)))
                    (overlay-put ov 'org-latex-preview t)
                    (overlay-put ov 'display image)
                    (overlay-put ov 'modification-hooks
                                 (list (lambda (o &rest _) (delete-overlay o))))
                    (cl-incf count))))))))
      (message "LaTeX preview done. %d blocks rendered." count)))
  ;; Hook beim Öffnen von org-mode Buffern
  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'after-save-hook #'+org/preview-latex-in-export-blocks nil 'local)))

  (map! :map org-mode-map
        :localleader
        :desc "Preview LaTeX in export blocks"
        "P" #'+org/preview-export-latex-blocks))
