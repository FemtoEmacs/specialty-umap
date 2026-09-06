;;; specialty.el --- Execute medical-specialty UMAP tour blocks -*- lexical-binding: t; -*-

(require 'eshell)
(require 'em-rebind)
(require 'subr-x)

(defgroup specialty-tour nil
  "Run the medical-specialty UMAP guided tour from Markdown."
  :group 'tools)

(defcustom specialty-tour-project-root
  (file-name-directory (or load-file-name buffer-file-name default-directory))
  "Root directory containing the specialty UMAP project."
  :type 'directory :group 'specialty-tour)

(defcustom specialty-tour-file
  (expand-file-name "TOUR.md" specialty-tour-project-root)
  "Markdown file displayed by `specialty-tour-open'."
  :type 'file :group 'specialty-tour)

(defcustom specialty-tour-eshell-buffer-name "*specialty-umap-tour*"
  "Name of the Eshell buffer used by the specialty tour."
  :type 'string :group 'specialty-tour)

(defvar-local specialty-tour--eshell-buffer nil)

(defun specialty-tour--block-at-point ()
  "Return the executable shell block containing point, or nil."
  (save-excursion
    (let ((origin (point)) begin end language)
      (when (re-search-backward
             "^[ \t]*```[ \t]*\\(sh\\|shell\\|bash\\)[ \t]*$" nil t)
        (setq language (match-string-no-properties 1)
              begin (line-beginning-position 2))
        (goto-char begin)
        (when (re-search-forward "^[ \t]*```[ \t]*$" nil t)
          (setq end (line-beginning-position))
          (when (and (>= origin begin) (<= origin end))
            (list :language language :begin begin :end end
                  :source (string-trim-right
                           (buffer-substring-no-properties begin end)))))))))

(defun specialty-tour--eshell-buffer ()
  "Return the live specialty-tour Eshell, creating it when needed."
  (if (buffer-live-p specialty-tour--eshell-buffer)
      specialty-tour--eshell-buffer
    (setq specialty-tour--eshell-buffer
          (save-window-excursion
            (eshell "new")
            (rename-buffer specialty-tour-eshell-buffer-name t)
            (current-buffer)))))

(defun specialty-tour-execute-block ()
  "Execute the fenced shell block containing point in the tour Eshell."
  (interactive)
  (let ((block (specialty-tour--block-at-point)))
    (unless block
      (user-error "Point is not inside a fenced sh, shell, or bash block"))
    (let* ((source (plist-get block :source))
           (script (format "cd %s\n%s"
                           (shell-quote-argument
                            (expand-file-name specialty-tour-project-root))
                           source))
           (command (format "/bin/sh -c %s" (shell-quote-argument script)))
           (eshell-buffer (specialty-tour--eshell-buffer))
           (window (get-buffer-window eshell-buffer)))
      (unless window
        (setq window (split-window (selected-window) nil 'below))
        (set-window-buffer window eshell-buffer))
      (with-selected-window window
        (goto-char (point-max))
        (insert command)
        (eshell-send-input))
      (message "Running TOUR.md block in %s"
               specialty-tour-eshell-buffer-name))))

(defvar specialty-tour-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c e") #'specialty-tour-execute-block)
    map)
  "Keymap for `specialty-tour-mode'.")

(define-minor-mode specialty-tour-mode
  "Execute fenced shell blocks in the specialty UMAP tour with `C-c e'."
  :lighter " Specialty-Tour" :keymap specialty-tour-mode-map)

;;;###autoload
(defun specialty-tour-open ()
  "Open the specialty TOUR.md above its dedicated Eshell window."
  (interactive)
  (let* ((tour-buffer (find-file-noselect specialty-tour-file))
         (eshell-buffer
          (with-current-buffer tour-buffer
            (specialty-tour-mode 1)
            (specialty-tour--eshell-buffer))))
    (delete-other-windows)
    (switch-to-buffer tour-buffer)
    (setq-local specialty-tour--eshell-buffer eshell-buffer)
    (let ((bottom (split-window (selected-window) nil 'below)))
      (set-window-buffer bottom eshell-buffer)
      (with-current-buffer eshell-buffer
        (setq default-directory
              (file-name-as-directory
               (expand-file-name specialty-tour-project-root))))
      (select-window (get-buffer-window tour-buffer))
      (goto-char (point-min))
      (message "Specialty UMAP tour ready: use C-c e in a shell block"))))

(provide 'specialty)
;;; specialty.el ends here
