open Ocamlbuild_plugin;;
open Command;;
dispatch begin function
| After_rules ->
    flag ["ocaml"; "pp"; "use_ulex"] (S[A"camlp5o"; A"pa_ulex.cma"]);
    flag ["ocaml"; "pp"; "camlp5orf"] (S[A"camlp5o"; A"pa_macro.cmo"; A"pa_extend.cmo"; A"q_MLast.cmo"]);
    dep ["ocaml"; "ocamldep"; "use_ulex"] ["pa_ulex.cma"];
    ocaml_lib ~tag_name:"use_ulex" "ulexing";
| _ -> ()
end;;
