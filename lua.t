  $ cat > a.lua <<-EOF 
  > function fact (n)
  >   if n <= 0 then
  >     return 1
  >   else
  >     return n * fact(n-1)
  >   end
  > end
  > print( fact(5) )
  > print("hello")
  > EOF
  $ cat a.lua
  function fact (n)
    if n <= 0 then
      return 1
    else
      return n * fact(n-1)
    end
  end
  print( fact(5) )
  print("hello")
  $ luac -l a.lua
  
  main <a.lua:0,0> (11 instructions at 0x55a5eaeddc60)
  0+ params, 3 slots, 1 upvalue, 0 locals, 5 constants, 1 function
  	1	[7]	CLOSURE  	0 0	; 0x55a5eaedde00
  	2	[1]	SETTABUP 	0 -1 0	; _ENV "fact"
  	3	[8]	GETTABUP 	0 0 -2	; _ENV "print"
  	4	[8]	GETTABUP 	1 0 -3	; _ENV "fact"
  	5	[8]	LOADK    	2 -4	; 5
  	6	[8]	CALL     	1 2 0
  	7	[8]	CALL     	0 0 1
  	8	[9]	GETTABUP 	0 0 -2	; _ENV "print"
  	9	[9]	LOADK    	1 -5	; "hello"
  	10	[9]	CALL     	0 2 1
  	11	[9]	RETURN   	0 1
  
  function <a.lua:1,7> (11 instructions at 0x55a5eaedde00)
  1 param, 3 slots, 1 upvalue, 1 local, 3 constants, 0 functions
  	1	[2]	LE       	0 0 -1	; - 0
  	2	[2]	JMP      	0 3	; to 6
  	3	[3]	LOADK    	1 -2	; 1
  	4	[3]	RETURN   	1 2
  	5	[3]	JMP      	0 5	; to 11
  	6	[5]	GETTABUP 	1 0 -3	; _ENV "fact"
  	7	[5]	SUB      	2 0 -2	; - 1
  	8	[5]	CALL     	1 2 2
  	9	[5]	MUL      	1 0 1
  	10	[5]	RETURN   	1 2
  	11	[7]	RETURN   	0 1
  $ ls
  a.lua
  luac.out
  luadecompiler
  main.exe
  $ lua luac.out
  120
  hello
$ java -jar /tmp/unluac_2023_07_04.jar luac.out
  $ ./luadecompiler -dis luac.out
  ; Disassembled using luadec 2.2 rev: UNKNOWN for Lua 5.3 from https://github.com/viruscamp/luadec
  ; Command line: -dis luac.out 
  
  ; Function:        0
  ; Defined at line: 0
  ; #Upvalues:       1
  ; #Parameters:     0
  ; Is_vararg:       1
  ; Max Stack Size:  3
  
      0 [-]: CLOSURE   R0 0         ; R0 := closure(Function #0_0)
      1 [-]: SETTABUP  U0 K0 R0     ; U0["fact"] := R0
      2 [-]: GETTABUP  R0 U0 K1     ; R0 := U0["print"]
      3 [-]: GETTABUP  R1 U0 K2     ; R1 := U0["fact"]
      4 [-]: LOADK     R2 K3        ; R2 := 5
      5 [-]: CALL      R1 2 0       ; R1 to top := R1(R2)
      6 [-]: CALL      R0 0 1       ;  := R0(R1 to top)
      7 [-]: GETTABUP  R0 U0 K1     ; R0 := U0["print"]
      8 [-]: LOADK     R1 K4        ; R1 := "hello"
      9 [-]: CALL      R0 2 1       ;  := R0(R1)
     10 [-]: RETURN    R0 1         ; return 
  
  
  ; Function:        0_0
  ; Defined at line: 1
  ; #Upvalues:       1
  ; #Parameters:     1
  ; Is_vararg:       0
  ; Max Stack Size:  3
  
      0 [-]: LE        0 R0 K0      ; if R0 <= 0 then goto 2 else goto 5
      1 [-]: JMP       R0 3         ; PC += 3 (goto 5)
      2 [-]: LOADK     R1 K1        ; R1 := 1
      3 [-]: RETURN    R1 2         ; return R1
      4 [-]: JMP       R0 5         ; PC += 5 (goto 10)
      5 [-]: GETTABUP  R1 U0 K2     ; R1 := U0["fact"]
      6 [-]: SUB       R2 R0 K1     ; R2 := R0 - 1
      7 [-]: CALL      R1 2 2       ; R1 := R1(R2)
      8 [-]: MUL       R1 R0 R1     ; R1 := R0 * R1
      9 [-]: RETURN    R1 2         ; return R1
     10 [-]: RETURN    R0 1         ; return 
  
  
