
(require 'ert)

(ert-deftest aider-buffer-name-from-git-repo-path-test ()
  "Test the aider-buffer-name-from-git-repo-path function."
  (should (equal (aider-buffer-name-from-git-repo-path "/Users/username/git/repo" "/Users/username")
                 "*aider:~/git/repo*"))
  (should (equal (aider-buffer-name-from-git-repo-path "/home/username/git/repo" "/home/username")
                 "*aider:~/git/repo*"))
  (should (equal (aider-buffer-name-from-git-repo-path "/Users/username/git/repo/subdir" "/Users/username")
                 "*aider:~/git/repo/subdir*"))
  (should (equal (aider-buffer-name-from-git-repo-path "/home/username/git/repo/subdir" "/home/username")
                 "*aider:~/git/repo/subdir*")))

(ert-deftest test-aider-region-refactor-generate-command ()
  "Test the aider-region-refactor-generate-command function."
  (should (equal (aider-region-refactor-generate-command "some code"
                                                         "my-function" "refactor this")
                 "/architect \"in function my-function, for the following code block, refactor this: some code\"\n"))
  (should (equal (aider-region-refactor-generate-command "some code" nil
                                                         "make it more functional")
                 "/architect \"for the following code block, make it more functional: some code\"\n"))
  )

;; test for aider--ask-git-diff-format-and-get-answer

(aider--ask-git-diff-format-and-get-answer "write a helloworld program")

(aider--ask-git-diff-format-and-get-answer "write a fibnacci function")

(aider--ask-git-diff-format-and-get-answer "proofreading my english: How do your did, was now a good day?")

(aider--ask-git-diff-format-and-get-answer "proofreading my english, return in chinese: How do your did, was now a good day?")

(message (aider--extract-last-diff+block (get-buffer (aider-buffer-name))))

(defun aider--extract-between-last-two-prompts (buffer)
  "Extract content between the last two prompts in BUFFER.
The prompt is a line starting with '>'.
Returns the content as string, or signals an error if not found."
  (with-current-buffer buffer
    (save-excursion
      (goto-char (point-max))
      (if (re-search-backward "^>" nil t 2) ;; find second-to-last prompt
          (let ((answer-start (point)))
            (forward-line)
            (buffer-substring-no-properties 
             answer-start
             (progn
               (re-search-forward "^>" nil t) ;; find last prompt
               (line-beginning-position))))
        (error "Could not find answer in buffer")))))
