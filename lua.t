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
  $ luac -l a.lua
  $ ls
  $ lua luac.out
$ java -jar /tmp/unluac_2023_07_04.jar luac.out
  $ ./luadecompiler -dis luac.out
