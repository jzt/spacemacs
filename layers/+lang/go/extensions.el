(setq go-pre-extensions
  '(
    ;; pre extension gos go here
    ))

(setq go-post-extensions
  '(
    ;; post extension gos go here
    go-guru
    go-rename
    ))

;; For each extension, define a function go/init-<extension-go>
;;
;; (defun go/init-my-extension ()
;;   "Initialize my extension"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun load-gopath-file(gopath name)
  "Search for NAME file in all paths referenced in GOPATH."
  (let* ((sep (if (spacemacs/system-is-mswindows) ";" ":"))
         (paths (split-string gopath sep))
         found)
    (loop for p in paths
          for file = (concat p name) when (file-exists-p file)
          do
          (load-file file)
          (setq found t)
          finally return found)))

(defun go/init-go-guru()
  (let ((go-path (getenv "GOPATH")))
    (if (not go-path)
        (spacemacs-buffer/warning
         "GOPATH variable not found, go-guru configuration skipped.")
      (when (load-gopath-file
             go-path "/src/golang.org/x/tools/cmd/guru/go-guru.el")
        (spacemacs/declare-prefix-for-mode 'go-mode "mr" "rename")
        (spacemacs/set-leader-keys-for-major-mode 'go-mode
          "ro" 'go-guru-set-scope
          "r<" 'go-guru-callers
          "r>" 'go-guru-callees
          "rc" 'go-guru-peers
          "rd" 'go-guru-definition
          "rf" 'go-guru-freevars
          ;; "rg" 'go-guru-callgraph
          "ri" 'go-guru-implements
          "rp" 'go-guru-pointsto
          "rr" 'go-guru-referrers
          "rs" 'go-guru-callstack
          "rw" 'go-guru-whicherrs
					"rx" 'go-guru-expand-region
          "rt" 'go-guru-describe)))))

(defun go/init-go-rename()
  (use-package go-rename
    :init
    (spacemacs/set-leader-keys-for-major-mode 'go-mode "rn" 'go-rename)))
