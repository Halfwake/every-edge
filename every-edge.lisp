(defparameter *square-nodes* '(a b c d))
(defparameter *square-edges* '((a b) (b c) (c d) (d a)))
; A -- B
; |    |
; C -- D

(defparameter *chain-nodes* '(a b c d e))
(defparameter *chain-edges* '((a b) (a c) (b c) (c d) (c d) (e d)))
;   A
;  / \
; B - C - D
;      \ /
;       E

(defparameter *gem-nodes* '(a b c d))
(defparameter *gem-edges* '((a c) (a d) (c d) (c e) (e d)))
;   A
;  / \
; C - D
;  \ /
;   E

(defun relevant-edges (node edges)
  (loop for edge in edges if (member node edge) collect edge))

(defun other-node (node edge)
  (cond ((eq node (first edge)) (second edge))
	((eq node (second edge)) (first edge))))

(defun quicksort (lst)
  (if (> (length lst) 1)
      (let ((pivot (first lst))
	    (rest (rest lst)))
	(append (quicksort (loop for i in rest if (< i pivot) collect i))
		(list pivot)
		(quicksort (loop for i in rest if (>= i pivot) collect i))))
      lst))

(defun equal-set (set1 set2 &key (test #'equal))
  (flet ((every-is-member-p (set1 set2)
	   (every (lambda (item)
		    (member item set1 :test test))
		  set2)))
    (and (every-is-member-p set1 set2)
	 (every-is-member-p set2 set1))))

(defun solve-from (node edges visited-edges attempted-edges)
  (if (equal-set edges visited-edges)
      visited-edges
      (let* ((relevant-edges (relevant-edges node edges))
	     (viable-edges (set-difference relevant-edges
					   (append visited-edges attempted-edges))))
	(if viable-edges
	    (let* ((attempt-edge (first viable-edges))
		   (next-node (other-node node attempt-edge))
		   (new-visited-edges (cons attempt-edge visited-edges)))
	      (or (solve-from next-node edges new-visited-edges nil)
		  (solve-from node edges visited-edges
			      (cons attempt-edge attempted-edges))))
	    nil))))

(defun solve (nodes edges)
  (remove-if-not #'identity
		 (loop for node in nodes
		    collect (solve-from node edges nil nil))))

(defun instruct (edges)
  (labels ((walk-edges (start-node edges)
	     (when edges
	       (let ((next-node (other-node start-node (first edges))))
		 (format t ", go to node ~a" next-node)
		 (walk-edges next-node (rest edges))))))
    (let ((start-end-node (if (< 2 (length edges))
			      (first (first edges))
			      (other-node (first (intersection (first edges)
							       (second edges)))
					  (first edges)))))
      (format t "start at node ~a" start-end-node)
      (walk-edges start-end-node edges)
      (format t ", stop"))))
		 
    

(defun solve-instruct (nodes edges)
  (dolist (path (solve nodes edges))
    (instruct path)))
	
