;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(let ((personal-settings "~/.doom.d/myenv.el"))
 (when (file-exists-p personal-settings)
   (load-file personal-settings))
)
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

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
(setq org-directory "~/org/"
      org-roam-directory "~/Sync/notes")

(setq deft-directory "~/Documents")

(setq org-cite-global-bibliography "~/Sync/bibliography/MyLibrary.bib")

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
;; (use-package! pet
;;   :config
  ;; (add-hook 'python-base-mode-hook 'pet-mode -10))

(use-package! ox-koma-letter
  :after ox)

(set-file-template! "/brief\\.org$" :trigger "__brief.org" :mode 'org-mode)


(after! org
  (setq org-latex-compiler "lualatex")
  (setq org-latex-src-block-backend 'engraved)
  (setq org-export-show-temporary-export-buffer t)
  (setq org-latex-engraved-options
        '(("commandchars" . "\\\\\\{\\}") ("highlightcolor" . "white!95!black!80!blue")
          ("breaklines" . "true")
          ("numbers" . "left")
          ("breaksymbol" . "\\color{white!60!black}\\tiny\\ensuremath{\\hookrightarrow}"))))

;; Configure ox-latex
(after! ox-latex
  (setopt org-latex-pdf-process
      '("latexmk -lualatex -interaction=nonstopmode -output-directory=%o %f"))

  (add-to-list 'org-latex-classes
               '("koma-article" "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (setopt org-latex-default-class "koma-article"))

(after! ansible
        (setq ansible-vault-password-file  "~/.ansible/vault_id.txt"))
;;
;; Configure GPTEL
;;

(after! gptel
  ;; enable MCP
  (require 'gptel-integrations)
  ;; more config
  (setq gptel-default-mode 'org-mode)
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  ;;
  ;; Make backends
  (gptel-make-ollama "Ollama"             ;Any name of your choosing
    :host "localhost:11434"               ;Where it's running
    :stream t                             ;Stream responses
    :models '(mistral:latest qwen3.5:4b)) 
                                        ; Anthropic / Claude
  (gptel-make-anthropic "Claude"
    :stream t
    :key (auth-source-pick-first-password :host "api.anthropic.com")
    :models '(claude-sonnet-5))

  (gptel-make-openai "GWDG"
    :host "chat-ai.academiccloud.de"
    :endpoint "/v1/chat/completions"
    :stream t
    :key (auth-source-pick-first-password :host "chat-ai.academiccloud")
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
               :description "Mistral Large 3 675B Instruct 2512; dez 2025; vision"
               )
              (
               qwen3.8-27b
               :description "Qwen 3.8 27b"
               :capabilities (media tool json url)
               :multimodal t
               :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp" "application/pdf" "video/mp4" "video/mpeg" )
               )
              (
               qwen3.6-35b-a3b
               :description "Qwen 3.6 35B A3B"
               :capabilities (media tool json url)
               :multimodal t
               :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp" "application/pdf" "application/pptx")
               )
              (qwen3-omni-30b-a3b-instruct
               :description "Qwen 3 OMNI: "
               :capabilities (media tool json url)
               )
              (
               qwen3-coder-next
               :description "Qwen 3 Coder Next: Feb 2026; text, coding"
               :capabilities (media tool json url)
               )
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
               )))
 ;; Default backend and model
  (setq gptel-model 'qwen3.6-35b-a3b); 'qwen3.8-27b)
  (setq gptel-backend (gptel-get-backend "GWDG")))

(use-package mcp
  :ensure t
  :after gptel
  :custom (mcp-hub-servers
           `(
             ;; ("filesystem" . (:command "npx"
             ;;                  :args ("-y" "@modelcontextprotocol/server-filesystem")
             ;;                 :roots ("/home/lizqwer/MyProject/")))
             ("fetch" . (:command "uvx" :args ("mcp-server-fetch")))
             ;; ("arxiv-mcp-server" . (:command "uv" :args ("tool run arxiv-mcp-server")))
             ;("qdrant" . (:url "http://localhost:8000/sse"))
             ))
  :config (require 'mcp-hub)
  :hook (after-init . mcp-hub-start-all-server))

(use-package! gptel-agent
  :config (gptel-agent-update))         ;Read files from agents directories

;; https://github.com/emacs-languagetool/eglot-ltex-plus

(use-package! eglot-ltex-plus
  :commands (eglot-ltex-plus--server-program)
  :init
  (setq eglot-ltex-plus-server-path "/opt/homebrew/bin/ltex-ls-plus"
        eglot-ltex-plus-communication-channel 'stdio))

(defun my/ltex-toggle ()
  "Start or stop LTEX+ (via Eglot) in the current buffer."
  (interactive)
  (require 'eglot-ltex-plus)
  (if-let ((server (eglot-current-server)))
      (progn (eglot-shutdown server)
             (message "LTEX+ stopped"))
    (call-interactively #'eglot)
    (message "LTEX+ started")))

;; (add-hook 'eglot-managed-mode-hook
;;           (lambda ()
;;             (when (derived-mode-p 'org-mode)
;;               (if (eglot-managed-p)
;;                   (flyspell-mode -1)
;;                (flyspell-mode 1)))))

(map! :leader
      :desc "LTEX+ grammar check" "t L" #'my/ltex-toggle)
