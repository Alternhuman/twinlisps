(defun unificarEntrada(e1 e2)
	(let ((unificador nil))
		(if (eql (first e1) (first e2)) 
			(catch 'unificarException (unificar (rest e1) (rest e2) unificador))
			'no-unificable
		)
	)
)

(defun unificarPrueba(e1 e2)
	(let ((unificador nil))
			(catch 'unificarException (unificar e1 e2 unificador))			
	)
)

(defun unificar(e1 e2 unificador)
	(cond 
		((eq e1 e2) unificador)
		((or (null e1) (null e2)) (throw 'unificarException 'no-unificable))
		((or (atom e1) (esvariable e1)) (print "Camino 1: e1 es atomo o variable") (unif e1 e2)) 
		((or (atom e2) (esvariable e2)) (print "Camino 2: e2 es atomo o variable") (unif e2 e1))
		((or (atom e1) (atom e2))
    		(throw 'unificarException 'no-unificable))
		(T 
			(print "Camino 3")
			(set 'f1 (first e1))
			(set 't1 (rest e1))

			(set 'f2 (first e2))
			(set 't2 (rest e2))

			(set 'z1 (unificar f1 f2 unificador))
			(setf unificador (append unificador (list z1)))
			
			(set 'g1 (aplicar z1 t1))
			(set 'g2 (aplicar z1 t2))

			(set 'z2 (unificar g1 g2 unificador))
			;(when (not (member z2 unificador)) (setf unificador (append unificador (list z2))))
			;(setf unificador (append unificador (list '(a b))))
		)

	)
)


(defun unif(e1 e2)
	(cond
		((esvariable e1) 
			(if (and (not(atom e2)) (member (extraerSimbolo e1) e2)) NIL) (list e2 e1))
		((esvariable e2) (list e1 e2))
		(T (print "Los dos son atomos") NIL)
	)
)


(defun aplicar (sustitucion lista)
	(when (eq lista '(*)) lista)
	(if (eq lista '())
	()
	(cons (sustituir (first sustitucion) (first (rest sustitucion)) (first lista))
		(poner (first sustitucion) (first (rest sustitucion)) (rest lista))))
)

(defun sustituir (a b elem)
	(if (eq elem a)
	b
	elem)
)

(defun poner (a b lista)
(if (eq lista '())
()
(cons (sustituir a b (first lista))(poner a b (rest lista))))
)


(defun esvariable (algo)
	(cond 
		((atom algo) NIL)
		((eq '? (first algo)) T)
	)
)

(defun extraerSimbolo(simbolo)
	(first (rest simbolo))
)



(defparameter *literal1* '(P x))
(defparameter *literal2* '(P (? a)))
(defparameter *literal3* '(P (? x) B))
(defparameter *literal4* '(P A (? y)))
(defparameter *literal5* '(P (? x) B (? c)))
(defparameter *literal6* '(P y (? A) d))



(defparameter *literal7* 'a)
(defparameter *literal8* 'b)
(defparameter *literal9* '(? b))
(defparameter *literal10* '(? a))


;(unificar '(P (? x) B) '(P (? y) A))


;;; Here is some test data:
;(defparameter *literal1* '(p x (f a)))
;(defparameter *literal2* '(p b y))
;(defparameter *literal3* '(p (f x) (g a y)))
;(defparameter *literal4* '(p (f (h b)) (g x y)))
;(defparameter *literal5* '(p x))
;(defparameter *literal6* '(p (f x)))
;(defparameter *literal7* '(p x (f y) x))
;(defparameter *literal8* '(p z (f z) a))

;;; Here's a function for demonstrating UNIFY.
(defun show-unification (lit1 lit2)
  "Prints out both inputs and output from UNIFY."
  (format t "~%El resultado de  UNIFICAR on ~s and ~s is ~s."
          lit1 lit2 (unificarEntrada lit1 lit2) ) )

(defun test ()
  "Calls UNIFY with sample arguments."
  (show-unification *literal1* *literal2*)
  (show-unification *literal3* *literal4*)
  (show-unification *literal5* *literal6*)
)
  ;(show-unification *literal7* *literal8*)
  
  ;(let ((u (unify *literal7* *literal8*)))
  ;  (format t "~%Result of applying U to ~s is ~s."
  ;          *literal7* (do-subst *literal7* u) )
  ;  (format t "~%Result of applying U to ~s is ~s."
  ;          *literal8* (do-subst *literal8* u) )
  ;) )
