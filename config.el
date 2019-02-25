;; Emacs-config by olikasg.

;; This file is a starting point to bootstrap an emacs config on any of
;; my computers.

(when (string-equal system-type "darwin")
  (setq ns-right-alternate-modifier (quote none))
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key "£" (lambda() (interactive) (insert ?#)))
  (global-set-key [kp-delete] 'delete-char))

(if window-system
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)))

(setq mouse-wheel-scroll-amount '(3 ((shift) . 5) ((control))))
(setq mouse-wheel-progressive-speed nil)

;; display time
;; (setq display-time-day-and-date t
;;      display-time-24hr-format t)
;; (display-time)

;; ediff does not open a new frame
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; Tab to spaces
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Mail address on my personal machine
(setq user-mail-address "gabor.olah@erlang-solutions.com"
      user-login-name "olikasg"
      user-full-name "Gabor Olah")

;; Thanks to Niles (http://nileshk.com/2009/06/13/prompt-before-closing-emacs.html)
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))

(global-set-key (kbd "C-x C-c") 'ask-before-closing)

;; Dired act as a file manager
(setq dired-dwim-target t)

(setq require-final-newline t)

(global-hl-line-mode t)

(setq-default fill-column 80)

(defun set-trailing-whitespace ()
  (setq show-trailing-whitespace t))


(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("elpa" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
;;(setq package-enable-at-startup nil)
(package-initialize)
;(package-read-all-archive-contents)
;(package-refresh-contents)

(add-to-list 'load-path (concat
 (file-name-as-directory emacs-repository-path)
                         "use-package-2.1"))

(require 'use-package)

(setq use-package-verbose t)
;(setq use-package-debug t)

(use-package dash
  :ensure t)

(use-package popup
  :ensure t)

(use-package magit
  :ensure t
  :pin melpa-stable
  :init
  (setq git-commit-summary-max-length 72)
  (setq git-commit-fill-column 72) ; Longer than 72 characters in a line looks ugly on GitHub
  :bind (("C-c s" . magit-status)
         ("C-c l" . magit-log-all)))

(use-package cl
  :demand t)

(use-package diminish
  :ensure t)

(use-package undo-tree
  :ensure t
  :ensure diff
  :ensure diminish
  :pin gnu
  :load-path "~/.emacs.d/elpa/undo-tree-0.6.5"
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package powerline
  :ensure t
  :ensure cl
  :pin melpa-stable
  :defer t
  :config
  (powerline-default-theme))

(use-package bm
  :ensure t
  :pin marmalade
  :bind (("<f6>" . bm-toggle)
         ("<f7>" . bm-previous)
         ("<f8>" . bm-next)))

(use-package ace-window
  :ensure t
  :pin elpa
  :bind (("M-p" . ace-window))
  :disabled t)

;; (use-package zenburn-theme
;;   :ensure t
;;   :pin melpa-stable)

(use-package monokai-theme
  :ensure t
  :pin melpa-stable
  :disabled t)

(use-package color-theme-solarized
  :ensure t
  :pin melpa)

(use-package alchemist
  :ensure t
  :pin melpa-stable)

(use-package hc-zenburn-theme
  :ensure t
  :pin melpa-stable
  :defer t
  :init
  (load-theme 'hc-zenburn t))

(use-package edts
  :ensure t
  :pin melpa
  :disabled t)

(use-package erlang
  :ensure t
  :pin melpa-stable
  :config
  (add-hook 'erlang-mode-hook 'set-trailing-whitespace))

(use-package helm
  :ensure t
  :pin melpa
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
          helm-input-idle-delay 0.01  ; this actually updates things
                                        ; reeeelatively quickly.
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode))
  :bind (("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("C-x C-f" . helm-find-files)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x c s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ("C-x c b" . my/helm-do-grep-book-notes)
         ("C-x c SPC" . helm-all-mark-rings)))
(ido-mode -1) ;; Turn off ido mode in case I enabled it accidentally


(use-package helm-ack ;; deprcated
  :ensure t
  :pin melpa-stable
  :disabled t) 

(use-package helm-ag
  :ensure t
  :pin melpa-stable
  :config
  (custom-set-variables
   '(helm-ag-base-command "ack --nocolor --nogroup")))

(use-package helm-git
  :ensure t
  :pin melpa
  :disabled t)

(use-package helm-git-grep
  :ensure t
  :pin melpa-stable
  :disabled t)

(use-package projectile
  :ensure t
  :pin melpa)

(use-package helm-projectile
  :ensure t
  :pin melpa
  :bind (("C-x p f" . helm-projectile-find-file)))

(use-package markdown-mode
  :ensure t
  :pin melpa-stable)

(use-package writeroom-mode
  :ensure t
  :pin melpa-stable)

(use-package dockerfile-mode
  :ensure t
  :pin melpa-stable)

(use-package docker
  :ensure t
  :pin melpa-stable)

(use-package ensime
  :ensure t
  :pin melpa-stable
  :config
  (setq ensime-startup-snapshot-notification nil))

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))

(use-package yaml-mode
  :ensure t
  :pin melpa-stable)

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))
;;;;

(use-package cider
  :ensure t
  :pin melpa-stable)

(use-package paredit
  :ensure t
  :pin melpa-stable
  :config
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode))

(use-package parinfer
  :ensure t
  :disabled t
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
                                        ;pretty-parens  ; different paren styles for different modes.
                                        ;evil           ; If you use Evil.
                                        ;lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
             paredit))        ; Introduce some paredit commands.
                                        ;smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
                                        ;smart-yank   ; Yank behavior depend on mode.

    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package company
  :ensure t
  :pin melpa
  :bind (("C-;" . company-complete))
  :config
  (global-company-mode))

(use-package company-flx
  :ensure t
  :config
  (company-flx-mode +1))

(use-package which-key
  :ensure t
  :pin gnu
  :config
  (which-key-mode))

;; find aspell and hunspell automatically
(cond
 ;; try hunspell at first
 ;; if hunspell does NOT exist, use aspell
 ((executable-find "hunspell")
  (setq ispell-program-name "hunspell")
  (setq ispell-local-dictionary "en_US")
  (setq ispell-local-dictionary-alist
        ;; Please note the list `("-d" "en_US")` contains ACTUAL parameters passed to hunspell
        ;; You could use `("-d" "en_US,en_US-med")` to check with multiple dictionaries
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

 ((executable-find "aspell")
  (setq ispell-program-name "aspell")
  ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))))

(global-set-key (kbd "C-;") 'ispell-word)
