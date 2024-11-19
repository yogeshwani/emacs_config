;; Don't show the splash screen
(setq inhibit-startup-message t)  ; Comment at end of line!

;; The following are some configs to disable a few things. However,
;; I don't prefer some of them and those are commented out.

(scroll-bar-mode 1)         ; Enable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
;;(tooltip-mode -1)         ; Disable tooltips
(menu-bar-mode 1)           ; Enable the menu bar
(set-fringe-mode 10)        ; Give some breathing room
(column-number-mode 1)      ; show column number 
;; Set up the visible bell
(setq visible-bell t)

;; Emacs move between buffers
(windmove-default-keybindings 'meta)

;; configure ispell 
(setq ispell-program-name "C:/Program Files (x86)/Aspell/bin/aspell")

;; Set font. This is not installed and gives an error so needs to be checked.
(set-face-attribute 'default nil :font "Fira Code Retina" :height 100)

;; Load the Modus Vivendi dark theme
(load-theme 'modus-vivendi t)

;; If you're using Emacs 27, either install Modus themes or use this one!
;; some oher themes I tried out
;; (load-theme 'deeper-blue t) ; better than the modus-vivendi but keeping the other one for now.
;; (load-theme 'tango-dark)
;; (load-theme 'wombat)
;;(load-theme 'manoj-dark)

;; Package Manager stuff 
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
;; use-package really simpliffies things so a good one to use.
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

;; use package is a very efficient way to manage packages
;; need to understand how it works and understand its usage
;; syntax a bit more in detail
(require 'use-package)
(setq use-package-always-ensure t)

;; gives the history of the commands being used. Mostly used to see the key bindings
(use-package command-log-mode)

;; This is used to display custom icons in the mode line. However,
;; for this to work correctly the following command has to be used
;; the very first time
;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

;; this configures the mode line to look and feel a bit modern
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

; @todo look at this later
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

;; Need to understand regarding this
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; This package come up with a useful window which contains the key binding completions.
;; this is very useful to quickly look at key bindings
(use-package which-key
  :init (which-key-mode)
  ;;:diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; helpful [rovides more help to the usual emacs describe functions
(use-package helpful
  :bind
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-function] . helpful-callable))

;; General package makes it easy to maangekey bindings
;; just like use-pacakge makes it easy for package managing general does the
;; same for the keybindings both at local and global scope
;; basically creates a ayw/leader-keys namespace kind of and then all the custom key bindigns
;; stay there
;; Need to understand this a bit more.
;; @todo this doesn't work correctly. 
(use-package general
  :config
  (general-create-definer yw/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "C-c g")

  (yw/leader-keys
    "t"  '(:ixsgnore t :which-key "toggles")
    "tt" '(load-theme :which-key "choose theme")))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(yw/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Magit configuration
(use-package magit)

;; forge package is used on top of magit to get fantastic integration with github.
;; there is a token creation step which needs to be done.
;; @todo Need to check if this intergrates with Azure devops too..
(use-package forge
   :after magit)


(defun yw/org-mode-setup ()
  ())

;;org more is already installed and comes by default in an emacs installation. Hovever, just a agood thing to do this may be?
;; basic keys whic i always forget
;; shift + tab -> collapses headliens and cycles throught views 
;; ctrl + RET drops a new headline or sub headline
;; atl+ Ret drops a new headline or sub headlien but immediately after (irrespective of any content)
;; alt + arrow kyes moves the sections up or down 
;; C-C C-l insert link
;;shift + riht arrow toggle sTODo state
;;|name| age| | will create tables naad tab will reformat it 
(use-package org
  :hook (org-mode . yw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"))

(use-package org-bullets
  :after org
  :hook
  (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Helm is the package i was using for searching but it looks like the ivy with counsel are quite good
;; need to see how IVy pans in respect to Helm and then can decide to switch
(use-package helm
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("C-x C-b" . helm-mini)
  ("C-x ci" . helm-imenu))

;; projectile is used where you want to switch projects easily and do aa lot of intellignet things on
;; project specific directories.
(use-package projectile
  :diminish projectile-mode
  :custom ((projectile-completion-system 'helm))
  :config (projectile-global-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map))


(use-package helm-projectile
  :config (helm-projectile-on))

(use-package helm-xref)

(use-package hl-todo)

(use-package helm-lsp
       :commands helm-lsp-workspace-symbol) 

(use-package rainbow-mode
  :ensure t)

;; this configuration is obtained from https://www.youtube.com/watch?v=UFPD7icMoHY
(use-package company
  :ensure t
  :hook ((emacs-lisp-mode . (lambda ()
			      setq company-backends '(company-elisp))))
         (emacs-lisp-mode . company-mode)
  :config
  ;; this disables the M-<number> key to select from the drop down
  ;; this calls an internal function so may be can be avoided if not really required
  ;;(company-kymap--unbind-quick-access comapny-active-map)
  ;; this is ddefault tab key function in company mode
  (company-tng-configure-default)
  (setq company-isle-delay 0.1
        company-minimim-prefix-length 1))

(use-package company-box)

(use-package yasnippet)

(use-package dap-mode)

(defun yw/development-mode-setup ()
  "Develpment mode setitings for different languages"
  (interactive)
  (hl-todo-mode t)
  (hs-minor-mode t)
  (company-mode t)
  (company-box-mode t)
  (highlight-numbers-mode t)
  (yas-global-mode t)
  ;; (rainbow-delimiters-mode t) ; this is already enabled separately
  (smart-tab-mode t)
  (color-identifiers-mode t)
  ;;(lsp t)
  (setq indent-tabs-mode t)
  (setq show-trailing-whitespace t))


;; This is actually the major mode used to devlop C code and is loaded in EMACS automatically. I wanted to avoid
;; things like
;; (add-hook 'c-mode-hook . 'lsp-mode-hook) and wanted to make the use of use-package everywhere. Hence, using it
;; in this config in the following way.
(use-package cc-mode
 :hook
  (c-mode . lsp-mode )
  (c++-mode . lsp-mode))

(use-package python
  :hook
   (python-mode . lsp-mode))

(use-package clang-format)

;; (use-package dap-cpptools) doesnt work here for some reason. Need to understand it. I emailed the maintainer of
;; dap-mode and he suggested this to me in his email.
;; @todo Need to check why this is the case.
(require 'dap-cpptools)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
   (lsp-mode . yw/development-mode-setup)
  :init
   (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  ;;:bind-keymap
   ;;("C-c l" . lsp-command-map)
   :config
    (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
    (lsp-enable-which-key-integration t))

(use-package lsp-ui
    :commands (lsp-ui-mode))

;; if you are ivy user
;;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;;(use-package dap-c) to load the dap adapter for your language
    
;; obtained from https://sachachua.com/dotemacs/index.html#python
;; has been edited to suite my needs. 
(use-package elpy
  :config
  (elpy-enable)
  (setq python-shell-interpreter "ipython3"
        python-shell-interpreter-args "-i --simple-prompt")
  (setq python-indent-offset 4))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" default))
 '(package-selected-packages
   '(clang-format rainbow-mode helpful lsp-ui company-box hl-todo dap-cpptools helm-xref c-mode dap-mode org-bullets helm-lsp yassnippet yasnippet company lsp-mode forge magit all-the-icons which-key rainbow-delimiters doom-themes doom-modeline command-log-mode helm-projectile use-package projectile helm))
 '(warning-suppress-log-types '((auto-save))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;### (autoloads nil nil ("elpa/rainbow-mode-1.0.6/rainbow-mode-autoloads.el"
;;;;;;  "elpa/rainbow-mode-1.0.6/rainbow-mode-pkg.el") (0 0 0 0))

;;;***

;;;### (autoloads nil "elpa/rainbow-mode-1.0.6/rainbow-mode" "elpa/rainbow-mode-1.0.6/rainbow-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from elpa/rainbow-mode-1.0.6/rainbow-mode.el

(autoload 'rainbow-mode "elpa/rainbow-mode-1.0.6/rainbow-mode" "\
Colorize strings that represent colors.
This will fontify with colors the string like \"#aabbcc\" or \"blue\".

This is a minor mode.  If called interactively, toggle the
`Rainbow mode' mode.  If the prefix argument is positive, enable
the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `rainbow-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "elpa/rainbow-mode-1.0.6/rainbow-mode" '("rainbow-"))
;;;***
