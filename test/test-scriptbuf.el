(load-file "./behave.el")
(load-file "../dbgr-scriptbuf.el")
(load-file "../dbgr-cmdbuf.el")

(behave-clear-contexts)

;; FIXME: use a real process buffer
(defun dbgr-cmdbuf-info-name(var) "foo")
(setq dbgr-cmdbuf-info (make-dbgr-cmdbuf-info))

(context "dbgr-scriptbuf"
	 (tag dbgr-scriptbuf)
	 (setq dbgr-scriptbuf-info nil)
	 (specify "dbgr-scriptbuf? before init"
		  (assert-nil (dbgr-scriptbuf? (current-buffer))))

	 (specify "dbgr-scriptbuf-command-string - uninit"
		  (assert-equal nil (dbgr-scriptbuf-command-string (current-buffer))))
	 (specify "dbgr-scriptbuf-init"
		  (dbgr-scriptbuf-init (current-buffer) (current-buffer)
				       "fake-debugger"
				       '("/bin/pdb" "--emacs" "fake.py" "1"))
		  (assert-equal "fake-debugger" 
				(dbgr-scriptbuf-info-debugger-name dbgr-scriptbuf-info)))

	 (specify "dbgr-scriptbuf? after init"
		  (assert-t (dbgr-scriptbuf? (current-buffer))))

	 (specify "dbgr-scriptbuf-command-string"
		  (assert-equal "/bin/pdb --emacs fake.py 1"
				(dbgr-scriptbuf-command-string (current-buffer))))

	 (specify "dbgr-scriptbuf-init-or-update - update"
		  (dbgr-scriptbuf-init-or-update (current-buffer) (current-buffer))
		  (assert-equal (current-buffer)
				(dbgr-scriptbuf-info-cmdproc dbgr-scriptbuf-info)))
	 
	 (specify "dbgr-scriptbuf-init-or-update - init"
		  (setq dbgr-scriptbuf-info nil)
		  (dbgr-scriptbuf-init-or-update (current-buffer) (current-buffer))
		  (assert-equal (current-buffer)
				(dbgr-scriptbuf-info-cmdproc dbgr-scriptbuf-info)))
	 )

(behave "dbgr-scriptbuf")
