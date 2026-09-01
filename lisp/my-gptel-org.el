;;; my-gptel-org.el -*- lexical-binding: t; -*-
(require 'gptel)

(require 'org)

(defun my/org-subtree-content ()

  "Return content of current org subtree as string."

  (save-excursion

    (org-back-to-heading t)

    (let ((beg (point)))

      (org-end-of-subtree t t)

      (buffer-substring-no-properties beg (point)))))

(defun my/gptel-check-org-subtree ()

  "Check current org subtree for logical and grammar issues."

  (interactive)

  (let* ((content (my/org-subtree-content))

         (prompt

          (concat

           "Überprüfe die folgende Aufgabe und ihre Lösung.\n\n"

           "1. Prüfe auf logische Fehler.\n"

           "2. Prüfe auf Grammatik und Rechtschreibung.\n"

           "3. Prüfe NICHT auf Leerzeichen oder Formatierung.\n\n"

           "Das Ergebnis MUSS exakt folgendes Format haben:\n\n"

           "* Logische Fehler\n"

           "INHALT\n\n"

           "* Rechtschreibung\n"

           "INHALT\n\n"

           "Hier ist der Inhalt:\n\n"

           content))

         (target-buffer (get-buffer-create "*GPTEL Org Check*")))

    (with-current-buffer target-buffer

      (erase-buffer)

      (org-mode)

      (insert "#+TITLE: GPTEL Prüfung\n\n")

      (insert "* Anfrage läuft ...\n\n"))

    (display-buffer target-buffer)

    (gptel-request

        prompt

      :callback

      (lambda (response info)

        (with-current-buffer target-buffer

          (erase-buffer)

          (org-mode)

          (if response

              (insert response)

            (insert "* Fehler\n\n")

            (insert (format "%S" info)))

          (goto-char (point-min)))))))

(provide 'my-gptel-org)
