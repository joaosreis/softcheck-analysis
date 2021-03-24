open Base
open Softcheck
open Cfg
open Scil

module Make
    (E : Expr.S)
    (N : Cfg_node.S with type expr = E.t)
    (Cfg : Flow_graph.FlowGraph with type block = N.t) (S : sig
      val aexp : E.t -> Set.M(E).t

      val contains_ident : E.t -> E.t -> bool
    end) =
struct
  module Solve (P : sig
    val graph : Cfg.t
  end) =
  struct
    module Spec = Node_specifics.Make (E) (N)

    let aexp_star =
      let blocks =
        Hashtbl.fold
          ~f:(fun ~key:_ ~data:d acc -> Set.add acc d)
          (Cfg.get_blocks P.graph)
          ~init:(Set.empty (module N))
      in
      Set.fold
        ~f:(fun acc b ->
          Set.union (Spec.aexp ~get_non_trivial_subexpr:S.aexp b) acc)
        blocks
        ~init:(Set.empty (module E))

    module L =
      Lattices.Powerset.Make_reverse
        (struct
          include E
        end)
        (struct
          let bottom = aexp_star
        end)

    let kill n =
      let open N in
      match n.stmt_s with
      | Cfg_assign (lv, _) -> Set.filter ~f:(S.contains_ident lv) aexp_star
      | Cfg_call _ | Cfg_guard _ | Cfg_jump | Cfg_var_decl _ ->
          Set.empty (module E)

    let gen n =
      let open N in
      match n.stmt_s with
      | Cfg_assign (_, e) | Cfg_guard e -> S.aexp e
      | Cfg_call (f, args) ->
          let f' = S.aexp f in
          List.fold_left
            ~f:(fun acc e -> Set.union acc (S.aexp e))
            ~init:f' args
      | Cfg_jump | Cfg_var_decl _ -> Set.empty (module E)

    module F = struct
      type vertex = Cfg.Vertex.t

      type state = L.t

      let f _ b s =
        let b' = Cfg.get P.graph b in
        let g = gen b' in
        let k = kill b' in
        Set.union (Set.diff s k) g

      let initial_state = Set.empty (module E)
    end

    include Framework.Dataflow.Backward.Make_solution (L) (Cfg) (F) (P)
  end
end
