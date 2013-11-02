(* This file has been generated by extraction
   of bootstrap/Monad.v. It shouldn't be
   modified directly. To regenerate it run
   coqtop -batch -impredicative-set -l
   bootstrap/Monad.v in Coq's source
   directory. *)

type __ = Obj.t
let __ = let rec f _ = Obj.repr f in Obj.repr f

module IOBase = 
 struct 
  type 'a coq_T = unit -> 'a
  
  type 'a coq_Ref = 'a Pervasives.ref
  
  (** val ret : 'a1 -> 'a1 coq_T **)
  
  let ret = fun a -> (); fun () -> a
  
  (** val bind :
      'a1 coq_T -> ('a1 -> 'a2 coq_T) -> 'a2
      coq_T **)
  
  let bind = fun a k -> (); fun () -> k (a ()) ()
  
  (** val ignore :
      'a1 coq_T -> unit coq_T **)
  
  let ignore = fun a -> (); fun () -> ignore (a ())
  
  (** val seq :
      unit coq_T -> 'a1 coq_T -> 'a1 coq_T **)
  
  let seq = fun a k -> (); fun () -> a (); k ()
  
  (** val ref : 'a1 -> 'a1 coq_Ref coq_T **)
  
  let ref = fun a -> (); fun () -> Pervasives.ref a
  
  (** val set :
      'a1 coq_Ref -> 'a1 -> unit coq_T **)
  
  let set = fun r a -> (); fun () -> Pervasives.(:=) r a
  
  (** val get : 'a1 coq_Ref -> 'a1 coq_T **)
  
  let get = fun r -> (); fun () -> Pervasives.(!) r
  
  (** val raise : exn -> 'a1 coq_T **)
  
  let raise = fun e -> (); fun () -> raise (Proof_errors.Exception e)
  
  (** val catch :
      'a1 coq_T -> (exn -> 'a1 coq_T) -> 'a1
      coq_T **)
  
  let catch = fun s h -> (); fun () -> try s () with Proof_errors.Exception e -> h e ()
  
  (** val read_line : string coq_T **)
  
  let read_line = fun () -> try Pervasives.read_line () with e -> raise e ()
  
  (** val print_char : char -> unit coq_T **)
  
  let print_char = fun c -> (); fun () -> print_char c
  
  (** val print :
      Pp.std_ppcmds -> unit coq_T **)
  
  let print = fun s -> (); fun () -> try Pp.pp s; Pp.pp_flush () with e -> raise e ()
  
  (** val timeout :
      int -> 'a1 coq_T -> 'a1 coq_T **)
  
  let timeout = fun n t -> (); fun () ->
    let timeout_handler _ = Pervasives.raise (Proof_errors.Exception Proof_errors.Timeout) in
    let psh = Sys.signal Sys.sigalrm (Sys.Signal_handle timeout_handler) in
    Pervasives.ignore (Unix.alarm n);
    let restore_timeout () =
      Pervasives.ignore (Unix.alarm 0);
      Sys.set_signal Sys.sigalrm psh
    in
    try
      let res = t () in
      restore_timeout ();
      res
    with
    | e -> restore_timeout (); Pervasives.raise e
 
 end

type proofview = { initial : (Term.constr*Term.types)
                             list;
                   solution : Evd.evar_map;
                   comb : Goal.goal list }

type logicalState = proofview

type logicalMessageType = bool

type logicalEnvironment = Environ.env

module NonLogical = 
 struct 
  type 'a t = 'a IOBase.coq_T
  
  type 'a ref = 'a IOBase.coq_Ref
  
  (** val ret : 'a1 -> 'a1 t **)
  
  let ret x =
    IOBase.ret x
  
  (** val bind :
      'a1 t -> ('a1 -> 'a2 t) -> 'a2 t **)
  
  let bind x k =
    IOBase.bind x k
  
  (** val ignore : 'a1 t -> unit t **)
  
  let ignore x =
    IOBase.ignore x
  
  (** val seq : unit t -> 'a1 t -> 'a1 t **)
  
  let seq x k =
    IOBase.seq x k
  
  (** val new_ref : 'a1 -> 'a1 ref t **)
  
  let new_ref x =
    IOBase.ref x
  
  (** val set : 'a1 ref -> 'a1 -> unit t **)
  
  let set r x =
    IOBase.set r x
  
  (** val get : 'a1 ref -> 'a1 t **)
  
  let get r =
    IOBase.get r
  
  (** val raise : exn -> 'a1 t **)
  
  let raise e =
    IOBase.raise e
  
  (** val catch :
      'a1 t -> (exn -> 'a1 t) -> 'a1 t **)
  
  let catch s h =
    IOBase.catch s h
  
  (** val timeout : int -> 'a1 t -> 'a1 t **)
  
  let timeout n x =
    IOBase.timeout n x
  
  (** val read_line : string t **)
  
  let read_line =
    IOBase.read_line
  
  (** val print_char : char -> unit t **)
  
  let print_char c =
    IOBase.print_char c
  
  (** val print : Pp.std_ppcmds -> unit t **)
  
  let print s =
    IOBase.print s
  
  (** val run : 'a1 t -> 'a1 **)
  
  let run = fun x -> try x () with Proof_errors.Exception e -> Pervasives.raise e
 end

module Logical = 
 struct 
  type 'a t =
    proofview -> Environ.env -> __ ->
    ((('a*proofview)*bool) -> (exn -> __
    IOBase.coq_T) -> __ IOBase.coq_T) -> (exn
    -> __ IOBase.coq_T) -> __ IOBase.coq_T
  
  (** val ret :
      'a1 -> proofview -> Environ.env -> __
      -> ((('a1*proofview)*bool) -> (exn ->
      'a2 IOBase.coq_T) -> 'a2 IOBase.coq_T)
      -> (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let ret x =
    (); (fun s e _ sk fk ->
      sk ((x,s),true) fk)
  
  (** val bind :
      'a1 t -> ('a1 -> 'a2 t) -> proofview ->
      Environ.env -> __ ->
      ((('a2*proofview)*bool) -> (exn -> 'a3
      IOBase.coq_T) -> 'a3 IOBase.coq_T) ->
      (exn -> 'a3 IOBase.coq_T) -> 'a3
      IOBase.coq_T **)
  
  let bind x k =
    (); (fun s e _ sk fk ->
      Obj.magic x s e __ (fun a fk0 ->
        let x0,c = a in
        let x1,s0 = x0 in
        Obj.magic k x1 s0 e __ (fun a0 fk1 ->
          let y,c' = a0 in
          sk (y,(if c then c' else false))
            fk1) fk0) fk)
  
  (** val ignore :
      'a1 t -> proofview -> Environ.env -> __
      -> (((unit*proofview)*bool) -> (exn ->
      'a2 IOBase.coq_T) -> 'a2 IOBase.coq_T)
      -> (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let ignore x =
    (); (fun s e _ sk fk ->
      Obj.magic x s e __ (fun a fk0 ->
        let x0,c = a in
        let a0,s0 = x0 in sk (((),s0),c) fk0)
        fk)
  
  (** val seq :
      unit t -> 'a1 t -> proofview ->
      Environ.env -> __ ->
      ((('a1*proofview)*bool) -> (exn -> 'a2
      IOBase.coq_T) -> 'a2 IOBase.coq_T) ->
      (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let seq x k =
    (); (fun s e _ sk fk ->
      Obj.magic x s e __ (fun a fk0 ->
        let x0,c = a in
        let u,s0 = x0 in
        Obj.magic k s0 e __ (fun a0 fk1 ->
          let y,c' = a0 in
          sk (y,(if c then c' else false))
            fk1) fk0) fk)
  
  (** val set :
      logicalState -> proofview ->
      Environ.env -> __ ->
      (((unit*proofview)*bool) -> (exn -> 'a1
      IOBase.coq_T) -> 'a1 IOBase.coq_T) ->
      (exn -> 'a1 IOBase.coq_T) -> 'a1
      IOBase.coq_T **)
  
  let set s =
    (); (fun s0 e _ sk fk ->
      sk (((),s),true) fk)
  
  (** val get :
      proofview -> Environ.env -> __ ->
      (((logicalState*proofview)*bool) ->
      (exn -> 'a1 IOBase.coq_T) -> 'a1
      IOBase.coq_T) -> (exn -> 'a1
      IOBase.coq_T) -> 'a1 IOBase.coq_T **)
  
  let get s e r sk fk =
    sk ((s,s),true) fk
  
  (** val put :
      logicalMessageType -> proofview ->
      Environ.env -> __ ->
      (((unit*proofview)*bool) -> (exn -> 'a1
      IOBase.coq_T) -> 'a1 IOBase.coq_T) ->
      (exn -> 'a1 IOBase.coq_T) -> 'a1
      IOBase.coq_T **)
  
  let put m =
    (); (fun s e _ sk fk -> sk (((),s),m) fk)
  
  (** val current :
      proofview -> Environ.env -> __ ->
      (((logicalEnvironment*proofview)*bool)
      -> (exn -> 'a1 IOBase.coq_T) -> 'a1
      IOBase.coq_T) -> (exn -> 'a1
      IOBase.coq_T) -> 'a1 IOBase.coq_T **)
  
  let current s e r sk fk =
    sk ((e,s),true) fk
  
  (** val zero :
      exn -> proofview -> Environ.env -> __
      -> ((('a1*proofview)*bool) -> (exn ->
      'a2 IOBase.coq_T) -> 'a2 IOBase.coq_T)
      -> (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let zero e =
    (); (fun s e0 _ sk fk -> fk e)
  
  (** val plus :
      'a1 t -> (exn -> 'a1 t) -> proofview ->
      Environ.env -> __ ->
      ((('a1*proofview)*bool) -> (exn -> 'a2
      IOBase.coq_T) -> 'a2 IOBase.coq_T) ->
      (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let plus x y =
    (); (fun s env _ sk fk ->
      Obj.magic x s env __ sk (fun e ->
        Obj.magic y e s env __ sk fk))
  
  (** val split :
      'a1 t -> proofview -> Environ.env -> __
      -> (((('a1*(exn -> 'a1 t), exn)
      Util.union*proofview)*bool) -> (exn ->
      'a2 IOBase.coq_T) -> 'a2 IOBase.coq_T)
      -> (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let split x =
    (); (fun s e _ sk fk ->
      IOBase.bind
        (Obj.magic x s e __ (fun a fk0 ->
          IOBase.ret (Util.Inl
            (a,(fun e0 _ sk0 fk1 ->
            IOBase.bind (fk0 e0) (fun x0 ->
              match x0 with
              | Util.Inl p ->
                let a0,x1 = p in
                sk0 a0 (fun e1 ->
                  x1 e1 __ sk0 fk1)
              | Util.Inr e1 -> fk1 e1)))))
          (fun e0 ->
          IOBase.ret (Util.Inr e0)))
        (fun x0 ->
        match x0 with
        | Util.Inl p ->
          let p0,y = p in
          let a,c = p0 in
          let a0,s0 = a in
          sk (((Util.Inl (a0,(fun e0 x1 x2 ->
            y e0))),s0),c) fk
        | Util.Inr e0 ->
          sk (((Util.Inr e0),s),true) fk))
  
  (** val lift :
      'a1 NonLogical.t -> proofview ->
      Environ.env -> __ ->
      ((('a1*proofview)*bool) -> (exn -> 'a2
      IOBase.coq_T) -> 'a2 IOBase.coq_T) ->
      (exn -> 'a2 IOBase.coq_T) -> 'a2
      IOBase.coq_T **)
  
  let lift x =
    (); (fun s e _ sk fk ->
      IOBase.bind x (fun x0 ->
        sk ((x0,s),true) fk))
  
  (** val run :
      'a1 t -> logicalEnvironment ->
      logicalState ->
      (('a1*logicalState)*logicalMessageType)
      NonLogical.t **)
  
  let run x e s =
    Obj.magic x s e __ (fun a x0 ->
      IOBase.ret a) (fun e0 ->
      IOBase.raise
        ((fun e -> Proof_errors.TacticFailure e)
          e0))
 end

