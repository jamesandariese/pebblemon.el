;;; pebblemon.el --- PebbLemon integration for Emacs

;; Copyright (C) 2013 James Andariese

;; Author: James Andariese <james@strudelline.net>
;; Version: 1.1
;; Package-Requires: ((json "0.0"))
;; Keywords: pebble jabber

;;; Commentary:

;; This package provides a function to send messages to your Pebble
;; through the PebbLemon service on Google App Engine

(require 'json)

;;;###autoload
(defun pebblemon-send (title msg)
  (interactive "sTitle: \nsMessage: ")
  (if (string-match-p "^/" pebblemon-auth)
	(start-process "jabber.el.pebble.strudelline.net" nil
		       "curl"
		       "-F" (concat "user=" (substring pebblemon-auth 1))
		       "-F" (concat "title=" title)
		       "-F" (concat "message=" msg)
		       "http://linode.strudelline.net:8088/push")
    
    (start-process "jabber.el.pebble.strudelline.net" nil
		   "curl"
		   "-d" (json-encode `((auth . ,pebblemon-auth)
				       (title . ,title)
				       (message . ,msg)))
		   "https://pebblemon.appspot.com/send")
    ))

;;;###autoload
(defgroup pebblemon nil
  "PebbLemon integration options"
  :group 'applications)

;;;###autoload
(defcustom pebblemon-auth
  ""
  "PebbLemon auth token (usually a UUID)"
  :type '(string)
  :group 'pebblemon)

;;; pebblemon.el ends here
