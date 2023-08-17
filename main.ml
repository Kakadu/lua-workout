let () =
  let ch = open_in "a.byte" in
  Bytesections.read_toc ch;
  List.iteri
    (fun i (name, len) -> Printf.printf "%2d: %s %d\n" i name len)
    (Bytesections.toc ());
  flush stdout;
  close_in ch

open Misc
open Compile_common

let to_bytecode i Typedtree.{ structure; coercion; _ } =
  (structure, coercion)
  |> Profile.(record transl) (Translmod.transl_implementation i.module_name)
  |> Profile.(record ~accumulate:true generate)
       (fun { Lambda.code = lambda; required_globals } ->
         lambda
         |> print_if i.ppf_dump Clflags.dump_rawlambda Printlambda.lambda
         |> Simplif.simplify_lambda
         |> print_if i.ppf_dump Clflags.dump_lambda Printlambda.lambda
         |> Bytegen.compile_implementation i.module_name
         |> print_if i.ppf_dump Clflags.dump_instr Printinstr.instrlist
         |> fun bytecode -> (bytecode, required_globals))

let emit_bytecode i (bytecode, required_globals) =
  let cmofile = cmo i in
  let oc = open_out_bin cmofile in
  Misc.try_finally
    ~always:(fun () -> close_out oc)
    ~exceptionally:(fun () -> Misc.remove_file cmofile)
    (fun () ->
      bytecode
      |> Profile.(record ~accumulate:true generate)
           (Emitcode.to_file oc i.module_name cmofile ~required_globals))

let implementation ~start_from ~source_file ~output_prefix =
  let backend info typed =
    let bytecode = to_bytecode info typed in
    emit_bytecode info bytecode
  in
  with_info ~source_file ~output_prefix ~dump_ext:"cmo" @@ fun info ->
  match (start_from : Clflags.Compiler_pass.t) with
  | Parsing -> Compile_common.implementation info ~backend
  | _ ->
      Misc.fatal_errorf "Cannot start from %s"
        (Clflags.Compiler_pass.to_string start_from)

module Options = Main_args.Make_bytecomp_options (Main_args.Default.Main)

let program = "demo"

let () =
  let ppf = Format.std_formatter in
  Clflags.add_arguments __LOC__ Options.list;
  Compenv.readenv ppf Before_args;
  Compenv.parse_arguments (ref Sys.argv) Compenv.anonymous program;
  Compmisc.read_clflags_from_env ();
  implementation ~start_from:Clflags.Compiler_pass.Parsing ~source_file:"a.ml"
    ~output_prefix:"asdf" ~native:false ~tool_name:"demo"
