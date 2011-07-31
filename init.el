;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Load path etc.

(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

(add-to-list 'load-path dotfiles-dir)
(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit"))
(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit/jabber"))

(setq autoload-file (concat dotfiles-dir "loaddefs.el"))
(setq package-user-dir (concat dotfiles-dir "elpa"))
(setq custom-file (concat dotfiles-dir "custom.el"))

;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

;; backport some functionality to Emacs 22 if needed
(require 'dominating-file)

;; this must be loaded before ELPA since it bundles its own
;; out-of-date js stuff. TODO: fix it to use ELPA dependencies
(load "elpa-to-submit/nxhtml/autostart")

;; Load up ELPA, the package manager

(require 'package)
(package-initialize)
(require 'starter-kit-elpa)

;; Load up starter kit customizations

(require 'starter-kit-defuns)
(require 'starter-kit-bindings)
(require 'starter-kit-misc)
(require 'starter-kit-registers)
(require 'starter-kit-eshell)
(require 'starter-kit-lisp)
(require 'starter-kit-perl)
(require 'starter-kit-ruby)
(require 'starter-kit-js)

(regen-autoloads)
(load custom-file 'noerror)

;; Work around a bug on OS X where system-name is FQDN
(if (eq system-type 'darwin)
    (setq system-name (car (split-string system-name "\\."))))

;; You can keep system- or user-specific customizations here
(setq system-specific-config (concat dotfiles-dir system-name ".el")
      user-specific-config (concat dotfiles-dir user-login-name ".el")
      user-specific-dir (concat dotfiles-dir user-login-name))
(add-to-list 'load-path user-specific-dir)

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))
(if (file-exists-p user-specific-dir)
  (mapc #'load (directory-files user-specific-dir nil ".*el$")))

;; Jonas' customizations
(setq kill-whole-line    t) ; Ctrl-K removes the newline too

(defun transpose-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2)
  )
(defun transpose-line-down ()
  (next-line)
  (interactive)
  (transpose-lines 1)
  (previous-line)
  )

(defun scroll-down-1 ()
  (interactive)
  (scroll-down 1))

(defun scroll-up-1 ()
  (interactive)
  (scroll-up 1))

(global-set-key (kbd "M-p") 'transpose-line-up)
(global-set-key (kbd "M-n") 'transpose-line-down)

(global-set-key [(meta up)] 'scroll-down-1) 
(global-set-key [(meta down)]   'scroll-up-1)

(define-key global-map [f1]   'next-error)

(define-key global-map [dead-tilde] "~")
(define-key global-map [S-dead-circumflex] "^")
(define-key global-map [S-dead-grave] "`")

(global-set-key [(shift f1)]  'previous-error)
(define-key global-map [f3]   'previous-error) ; in some XEmacs versions, shift in not recognized

(define-key global-map [f2]   'call-last-kbd-macro)
(define-key global-map [f5]   'occur)            ;; Search within buffer
(define-key global-map [f6]   'other-window)     ;; Jump to other window
(define-key global-map [f7]   'repeat-complex-command)
(define-key global-map [f9]   'manual-entry)     ;; man <command>  
(define-key global-map [f10]  'cleanuptabs-buffer)
(define-key global-map [f11]  'grep)
(define-key global-map [f12]  'compile)
(global-set-key [(control f11)]   'isearch-toggle-case-fold)
(global-set-key (kbd "C-.") 'dabbrev-expand) ;; M-/ takes 3 keys - tooinconvenient!
(global-set-key (kbd "C-#") 'comment-or-uncomment-region)

(set-variable 'compile-command "rake ")
(set-variable 'compile-command "mlgrep -S ")

(global-set-key [(shift f1)]  'previous-error)


(set-variable 'compile-command "rake ")
(set-variable 'grep-command "mlgrep -S ")

(require 'fontize)
(global-set-key [?\C-+] 'inc-font-size)
(global-set-key [?\C--] 'dec-font-size)
(global-set-key [?\M-+] 'font-next)
(global-set-key [?\M--] 'font-prev)

(setq load-path (cons (expand-file-name "/usr/share/doc/git-core/contrib/emacs") load-path))
(require 'vc-git)
(when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
(require 'git)
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)

(add-to-list 'load-path "~/scala/misc/scala-tool-support/emacs")
(require 'scala-mode-auto)

;; clojure-mode
(require 'clojure-mode)
(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))


(add-to-list 'auto-mode-alist '("\\.mirah\\'" . ruby-mode))



(add-to-list 'load-path "~/pycomplexity/")
(require 'linum)
(require 'pycomplexity)
(add-hook 'python-mode-hook
    (function (lambda ()
      (pycomplexity-mode)
      (linum-mode))))
