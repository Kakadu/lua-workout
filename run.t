  $ echo "let rec fac n = if n<=1 then 1 else n* fac(n-1)\n" > a.ml
  $ echo "let() = print_int (fac 5)\n" >> a.ml
  $ ocamlc a.ml -dlambda -dinstr -o a.byte
  (setglobal A!
    (letrec
      (fac/267
         (function n/268[int] : int
           (if (<= n/268 1) 1 (* n/268 (apply fac/267 (- n/268 1))))))
      (let
        (*match*/271 = (apply (field 43 (global Stdlib!)) (apply fac/267 5)))
        (makeblock 0 fac/267))))
  	branch L2
  L1:	acc 0
  	push
  	const 1
  	geint
  	branchifnot L3
  	const 1
  	return 1
  L3:	acc 0
  	offsetint -1
  	push
  	offsetclosure 0
  	apply 1
  	push
  	acc 1
  	mulint
  	return 1
  L2:	closurerec 1, 0
  	const 5
  	push
  	acc 1
  	apply 1
  	push
  	getglobal Stdlib!
  	getfield 43
  	apply 1
  	push
  	acc 1
  	makeblock 1, 0
  	pop 2
  	setglobal A!
  
  $ ./a.byte
  120
  $ ./main.exe -dlambda -dinstr
   0: CODE 11376
   1: DLPT 0
   2: DLLS 0
   3: PRIM 7858
   4: DATA 592
   5: SYMB 356
   6: CRCS 1214
  (setglobal Asdf!
    (letrec
      (fac/267
         (function n/268[int] : int
           (if (<= n/268 1) 1 (* n/268 (apply fac/267 (- n/268 1))))))
      (let
        (*match*/271 = (apply (field 43 (global Stdlib!)) (apply fac/267 5)))
        (makeblock 0 fac/267))))
  	branch L2
  L1:	acc 0
  	push
  	const 1
  	geint
  	branchifnot L3
  	const 1
  	return 1
  L3:	acc 0
  	offsetint -1
  	push
  	offsetclosure 0
  	apply 1
  	push
  	acc 1
  	mulint
  	return 1
  L2:	closurerec 1, 0
  	const 5
  	push
  	acc 1
  	apply 1
  	push
  	getglobal Stdlib!
  	getfield 43
  	apply 1
  	push
  	acc 1
  	makeblock 1, 0
  	pop 2
  	setglobal Asdf!
  
  $ file asdf.cmo
  asdf.cmo: OCaml object file (.cmo) (Version 031)
