Given the following shape, draw it without crossing over or going back over previous lines.

```
   o
  / \
 o - o - o
      \ /
       o
```


```lisp
;   A
;  / \
; B - C - D
;      \ /
;       E
(defparameter *chain-nodes* '(a b c d e))
(defparameter *chain-edges* '((a b) (a c) (b c) (c d) (c d) (e d)))

; List of all possible solutions.
(solve *chain-nodes* *chain-edges*)
; Print out instructions for drawing the shape.
(solve-instruct *chain-nodes* *chain-edges*)
```

