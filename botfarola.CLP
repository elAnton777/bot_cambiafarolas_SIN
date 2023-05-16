;;Alejandro Antón Cabezas

(deffunction inicio()
        (reset)
    (printout t "Profundidad Maxima " )
    (bind ?prof (read))
    (printout t "Search strategy " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
    (bind ?a (read))
    (if (= ?a 1)
           then    (set-strategy breadth)
           else   (set-strategy depth))
        (printout t " Ejecute Run  " crlf)
    	(assert (bot 1 1 basquet 0 farola 3 5 2 farola 5 5 2 farola 3 4 3 profundidad 0))
	(assert (warehouse 2 3 ba 1 2 3))
	(assert (profundidad-maxima ?prof))
)

(defglobal ?*nodo* = 0)

(defrule reparacion 
	?f<-(bot ?x ?y basquet ?b $?f0 farola ?xf ?yf ?nb $?f1 profundidad ?p)
	(profundidad-maxima ?pm)
	(test(neq ?p ?pm))
	(test(or (and (= ?x (- ?xf 1)) (= ?y ?yf)) (and (= ?x (+ ?xf 1)) (= ?y ?yf)) (and (= ?y (- ?yf 1)) (= ?x ?xf)) (and (= ?y (+ ?yf 1)) (= ?x ?xf)) ))
	(test(>= ?b ?nb))
=>
	(assert (bot ?x ?y basquet (- ?b ?nb) $?f0 $?f1 profundidad (+ ?p 1)))
	(bind ?*nodo* (+ ?*nodo* 1)) 
)

(defrule IsWarehouse
	?f<-(bot ?x ?y basquet ?b $?farola profundidad ?p)
	(warehouse ?wx ?wy ba $?ba1 ?ba2 $?ba3)
	(profundidad-maxima ?pm)
	(test(neq ?p ?pm))
	(test(and (= ?x ?wx) (= ?y ?wy)))	
	(test(<= (+ ?b ?ba2) 3))
=>
	(assert (bot ?x ?y basquet (+ ?b ?ba2) $?farola profundidad (+ ?p 1)))
	(bind ?*nodo* (+ ?*nodo* 1)) 
)

(defrule fin
	(declare(salience 10))
	?f<-(bot ?x ?y basquet 0 profundidad ?p)
=>
	(printout t "NUMERO DE nodoS EXPANDIDOS O REGLAS DISPARADAS " ?*nodo* crlf)
	(printout t "SOLUCION ENCONTRADA EN NIVEL: " ?p crlf)
	
	(halt)
	
)

(defrule derecha
	?f<-(bot ?x ?y basquet ?b $?farola profundidad ?p)
	(profundidad-maxima ?pm)
	(test(not(member$(create$ farola (+ ?x 1) ?y _) $?farola)))
        (test(> 5 ?x))
	(test(< ?p ?pm))
 
=>
	(assert (bot (+ ?x 1) ?y basquet ?b $?farola profundidad (+ ?p 1)))
	(bind ?*nodo* (+ ?*nodo* 1)) 
)

(defrule izquierda
	?f<-(bot ?x ?y basquet ?b $?farola profundidad ?p)
	(profundidad-maxima ?pm)
	(test(not(member$(create$ farola (- ?x 1) ?y _) $?farola)))
	(test(< 1 ?x))
	(test(< ?p ?pm))
=>
	(assert (bot (- ?x 1) ?y basquet ?b $?farola profundidad (+ ?p 1)))
	(bind ?*nodo* (+ ?*nodo* 1)) 
)

(defrule arriba
	?f<-(bot ?x ?y basquet ?b $?farola profundidad ?p)
	(profundidad-maxima ?pm)
	(test(not(member$(create$ farola ?x (+ ?y 1) _) $?farola)))
	(test(> 5 ?y))
	(test(< ?p ?pm))
=>
	(assert (bot ?x (+ ?y 1) basquet ?b $?farola profundidad (+ ?p 1)))
	(bind ?*nodo* (+ ?*nodo* 1)) 
)

(defrule abajo
	?f<-(bot ?x ?y basquet ?b $?farola profundidad ?p)
	(profundidad-maxima ?pm)
	(test(not(member$(create$ farola ?x (- ?y 1) _) $?farola)))
	(test(< 1 ?y))
	(test(< ?p ?pm))
=>
	(assert (bot ?x (- ?y 1) basquet ?b $?farola profundidad (+ ?p 1)))
	(bind ?*nodo* (+ ?*nodo* 1)) 
)

	