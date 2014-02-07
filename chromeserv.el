;;; chromeserv.el --- Collection of utilities used by chrome-emacsclient extension

(require 'compile)
(require 'url-parse)
(require 'simple-httpd)


(defun chromeserv-find-file (url line)
  "Find file to open in buffer by url.

If file is not found in `compilation-search-path` then it will be opened via http."
  (message "chromeserv-find-file visiting %s, line %s" url line)
  (let ((path (car (split-string (url-filename (url-generic-parse-url url)) "?")))
        (search-dirs compilation-search-path)
        (spec-dir (directory-file-name default-directory))
        buffer this-dir this-parts filename parts)
    (setq filename (file-name-nondirectory path)
          parts (cdr (split-string (directory-file-name (file-name-directory path)) "/")))
    (while (and search-dirs (null buffer))
      (setq this-dir (or (car search-dirs) spec-dir)
            search-dirs (cdr search-dirs)
            this-parts parts)
      (while (and (file-exists-p this-dir) this-parts)
        (setq this-dir (concat this-dir "/" (car this-parts))
              this-parts (cdr this-parts)))
      (when (null this-parts)
        (let ((name (expand-file-name filename this-dir)))
          (setq buffer (and (file-exists-p name)
                            (find-file-noselect name))))))
    (if buffer
        (let ((win (get-buffer-window buffer)))
          (if win (select-window win)
            (switch-to-buffer buffer)))
      (message "chromeserv-find-file could not find requested file (%s). Try adding project path to `compilation-search-path`. Meanwhile opened requested file from server in temp buffer." path)
      (browse-url-emacs url))
    (goto-line line)))

;; Servlets

(defun httpd/chromeserv/visit (proc _path query _req &rest _args)
  (let ((url (nth 1 (assoc "url" query)))
        (line (string-to-number (nth 1 (assoc "line" query)))))
    (chromeserv-find-file url line)
    (ignore-errors
      (with-temp-buffer "OK" (httpd-send-header proc 200)))))

(provide 'chromeserv)
