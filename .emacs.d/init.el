(require 'org)
(defun org-babel-load-file-custom (file tangled-file &optional compile)
  "Load Emacs Lisp source code blocks in the Org FILE.
This function exports the source code using `org-babel-tangle'
and then loads the resulting file using `load-file'.  With
optional prefix argument COMPILE, the tangled Emacs Lisp file is
byte-compiled before it is loaded."
  (interactive "fFile to load: \nP")
    ;; Tangle only if the Elisp file is older than the Org file.
    ;; Catch the case when the .el file exists while the .org file is missing.
    (unless (file-exists-p file)
      (error "File to tangle does not exist: %s" file))
    (when (file-newer-than-file-p file tangled-file)
      (org-babel-tangle-file file
                             tangled-file
                             (rx string-start
                                 (or "emacs-lisp" "elisp")
                                 string-end))
      ;; Make sure that tangled file modification time is
      ;; updated even when `org-babel-tangle-file' does not make changes.
      ;; This avoids re-tangling changed FILE where the changes did
      ;; not affect the tangled code.
      (when (file-exists-p tangled-file)
        (set-file-times tangled-file)))
    (if compile
	(progn
	  (byte-compile-file tangled-file)
	  (load-file (byte-compile-dest-file tangled-file))
	  (message "Compiled and loaded %s" tangled-file))
      (load-file tangled-file)
      (message "Loaded %s" tangled-file)))

(org-babel-load-file-custom "~/.emacs.org" "/tmp/.emacs")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-dark-high-contrast))
 '(custom-safe-themes
   '("51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "3e200d49451ec4b8baa068c989e7fba2a97646091fd555eca0ee5a1386d56077" "524fa911b70d6b94d71585c9f0c5966fe85fb3a9ddd635362bfabd1a7981a307" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" "efcecf09905ff85a7c80025551c657299a4d18c5fcfedd3b2f2b6287e4edd659" "d89e15a34261019eec9072575d8a924185c27d3da64899905f8548cbd9491a36" "833ddce3314a4e28411edf3c6efde468f6f2616fc31e17a62587d6a9255f4633" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" default))
 '(package-selected-packages
   '(org-ref org-fragtog glsl-mode rainbow-delimiters magit buffer-move rust-mode cmake-mode maxima projectile dashboard org solarized-theme exwm))
 '(warning-suppress-types '((emacs))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
