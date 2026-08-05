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
;; `load-theme' function. Tjis is the default:
(setq doom-theme 'catppuccin)
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)

(setq doom-font (font-spec :family "Iosevka" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font Propo" :size 16)
      doom-big-font (font-spec :family "Iosevka" :size 20)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono" :size 16))

(set-fontset-font t 'hangul (font-spec :family "D2Coding"))

(setq text-scale-mode-step 1.2)

;; Set the scroll-off (scrolloff) value
(setq scroll-margin 10)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq lsp-ui-doc-enable t
      lsp-ui-doc-show-with-cursor t) ; Show docs when cursor is over a symbol

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(setq display-line-numbers-type 'relative)

(setq org-latex-compiler "lualatex")
(setq org-preview-latex-default-process 'dvisvgm)

(after! org-modern
  (setq org-modern-star
        '("●" "○" "◆" "▶" "▸" "▹")))

;; disable word wrap
(remove-hook 'text-mode-hook #'visual-line-mode)
(setq-default truncate-lines t)

(map! :nv "C-j" "10j"
      :nv "C-k" "10k")

(map! :nv "w" #'evil-forward-WORD-begin
      :nv "b" #'evil-backward-WORD-begin
      :nv "e" #'evil-forward-WORD-end
      :nv "ge" #'evil-backward-WORD-end)

(add-to-list 'default-frame-alist '(undecorated . t))

(use-package! sis
  :if (featurep 'cocoa) ; or (eq system-type 'darwin)
  :config
  (sis-ism-lazyman-config "com.apple.keylayout.ABC" "com.apple.inputmethod.Korean.2SetKorean")

  (sis-global-respect-mode t)
  (sis-global-context-mode t)
  (sis-global-cursor-color-mode t))

(after! latex
  (add-hook 'before-save-hook #'indent-region nil t)
  (map! :map LaTeX-mode-map
        :localleader
        :desc "Fold buffer" "b" #'TeX-fold-buffer))

(add-hook! 'LaTeX-mode-hook
  (add-hook 'post-self-insert-hook
            (lambda ()
              (when (and (bound-and-true-p TeX-fold-mode)
                         ;; Fold when we just typed a non-alpha char after a macro word
                         (not (and (char-before)
                                   (string-match-p "[a-zA-Z*]" (string (char-before))))))
                (+latex-fold-last-macro-a)))
            nil t))

(after! evil-snipe
  (evil-snipe-mode -1)
  (evil-snipe-override-mode -1))

(use-package! rocq-mode
  :hook
  (coq-mode . rocq-mode)
  (rocq-mode . rocq-follow-viewport-mode)
  (rocq-mode . rocq-auto-goals-at-point-mode))

(after! rocq-mode
  (set-face-attribute 'rocq-mode-last-request nil :background "#313244" :underline nil)
  (set-face-attribute 'rocq-mode-processing-face nil :background "#313244" :underline nil)
  (defvar my/rocq-prettify-symbols-alist
    '(("alpha" . ?α) ("beta" . ?β) ("gamma" . ?γ) ("delta" . ?δ)
      ("epsilon" . ?ε) ("zeta" . ?ζ) ("eta" . ?η) ("theta" . ?θ)
      ("iota" . ?ι) ("kappa" . ?κ) ("lambda" . ?λ) ("mu" . ?μ)
      ("nu" . ?ν) ("xi" . ?ξ) ("pi" . ?π) ("rho" . ?ρ)
      ("sigma" . ?σ) ("tau" . ?τ) ("upsilon" . ?υ) ("phi" . ?ϕ)
      ("chi" . ?χ) ("psi" . ?ψ) ("omega" . ?ω)
      ("Gamma" . ?Γ) ("Delta" . ?Δ) ("Theta" . ?Θ) ("Lambda" . ?Λ)
      ("Xi" . ?Ξ) ("Pi" . ?Π) ("Sigma" . ?Σ) ("Upsilon" . ?Υ)
      ("Phi" . ?Φ) ("Psi" . ?Ψ) ("Omega" . ?Ω)
      ("forall" . ?∀) ("exists" . ?∃)
      ("nat" . ?ℕ) ("complex" . ?ℂ) ("real" . ?ℝ)
      ("int" . ?ℤ) ("rat" . ?ℚ)
      ("<=" . ?≤) (">=" . ?≥) ("=>" . ?⇒)
      ("->" . ?→) ("<-" . ?←) ("<->" . ?↔)
      ("\\/" . ?∨) ("/\\" . ?∧)
      ("<>" . ?≠) ("|-" . ?⊢)
      ("===" . ?≡) ("=/=" . ?≢)))
  (dolist (hook '(rocq-mode-hook rocq-goal-mode-hook))
    (add-hook hook (lambda ()
      (setq prettify-symbols-alist my/rocq-prettify-symbols-alist)
      (prettify-symbols-mode 1)))))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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
