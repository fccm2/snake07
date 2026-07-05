(* A minimalist-snake-demos, originaly writen in .js *)
(* Author: Florent Monnier, 2024, 2026,
 
 To the extent permitted by law you can use, study, modify, and re-
 distribute, this piece of software, with any spdx license, and /
 or any cc-by-sa license, version 2.5 and / or later,
*)
open Canvas

type dir = {
  dx: int;
  dy: int;
}

let d1 = { dx =  20; dy =   0; }  (* right *)
let d2 = { dx =   0; dy =  20; }  (* down *)
let d3 = { dx = -20; dy =   0; }  (* left *)
let d4 = { dx =   0; dy = -20; }  (* up *)
let d0 = { dx =   0; dy =   0; }  (* zero *)

let ds = [|
  d1;
  d2;
  d3;
  d4;
|]

type sn = {
  sx: int;
  sy: int;

  dir: dir;

  trail: dir list;

  size: int;  (* max size *)

  len: int;

  twCl1: string;
  twCl2: string;
}
(*
  shape: Canvas.path2d;
  color: string;
  name: string;
  moves: pos list;
  pos: pos;
  strength: int;
  stra_pos: int;
  kind: shape_kind;
}
*)

(*
let sn = {
  sx: int;
  sy: int;

  dir: dir;

  trail: dir list;

  size:64,  // max size
  len:0,
  twCl1:'#2358',
  twCl2:'#46b2',

}
*)

let sn1 = {
  sx = 120;
  sy = 100;
  dir = d0;
  trail = [];
  size = 64;  (* max size *)
  len = 0;
  twCl1 = "#2358";
  twCl2 = "#46b2";
}

let sn2 = {
  sx = 460;
  sy = 320;
  dir = d0;
  trail = [];
  size = 64;
  len = 0;
  twCl1 = "#5238";
  twCl2 = "#b462";
}

let sn3 = {
  sx = 240;
  sy = 220;
  dir = d0;
  trail = [];
  size = 64;
  len = 0;
  twCl1 = "#2538";
  twCl2 = "#4b62";
}

let canvas = Canvas.getElementById document "c1"
let ctx = Canvas.getContext canvas "2d"

let w = 780;;
let h = 500;;

let sn_lst = ref [ sn1; sn2; sn3; ]

type towers = {
  tx: int;
  ty: int;

  lim: int;

  cl1: string;
  cl2: string;
}

(*
*)

(*
*)
let twrs_lst = ref [];;

let rand d =
  Random.int d;;

let rnd a b =
  (a + (rand (1 + b - a)))
;;

let push lst elem =
  lst := elem :: !lst ;
;;

let shift lst =
  match lst with
  | _ :: lst -> lst
  | [] -> lst

let putTwr sn =
  push twrs_lst {
    tx = sn.sx;
    ty = sn.sy;
    lim = rnd 320 3200;
    cl1 = sn.twCl1;
    cl2 = sn.twCl2;
  }
  (*
  twrs.push(
    { x:sn.x,
      y:sn.y,
      lim:rnd(320, 3200),
      cl1:sn.twCl1,
      cl2:sn.twCl2,
    }
  )
  *)
;;

(*
var twrs = [];
function putTwr(sn) {
  twrs.push(
    { x:sn.x,
      y:sn.y,
      lim:rnd(320, 3200),
      cl1:sn.twCl1,
      cl2:sn.twCl2,
    }
  );
}

*)

let swtchSn () =
  (*
  let sn = sn1;
  sn1 = sn2;
  sn2 = sn3;
  sn3 = sn;
  *)
  match !sn_lst with
  | [ sn1; sn2; sn3; ] ->
      sn_lst := [ sn2; sn3; sn1; ] ;
  | _ -> ()
;;

(*
function swtchSn() {
  let sn = sn1;
  sn1 = sn2;
  sn2 = sn3;
  sn3 = sn;
}
*)


let cShp1 = Canvas.newPath2D_e () ;;
Canvas.pathArc cShp1 10.0 10.0 9 0 6.2830 ;;

let drawBg () =
  Canvas.fillStyle ctx "#223";
  Canvas.fillRect ctx 0 0 w h;
;;

let drawRect (x, y) cl =
  Canvas.fillStyle ctx cl;
  Canvas.fillRect ctx x y 20 20;
;;

let drawSn sn cl =
  drawRect (sn.sx, sn.sy) cl;
;;

let drawTxt (x, y) txt cl =
  Canvas.fillStyle ctx cl;
  Canvas.font ctx "15px mono";
  Canvas.fillText ctx txt x y;
;;

(* stepSn *)

let stepSn sn =
  let d = sn.dir in
  let trail, len =
    if (d <> d0) then
    begin
      let trail = { dx = sn.sx; dy = sn.sy; } :: sn.trail in
      let len = sn.len + 1 in
      let trail =
        if sn.len >= sn.size then shift sn.trail else trail
      in
      (trail, len)
    end
    else
      (sn.trail, sn.len)
  in
  let sx = sn.sx + d.dx in
  let sy = sn.sy + d.dy in
  { sn with sx; sy; trail; len; }
;;

(*
function stepSn(sn) {
  let d = sn.dir;
  if (d != d0) {
    sn.trail.push( { x:sn.x, y:sn.y } );
    sn.len++;
    if (sn.len >= sn.size) sn.trail.shift();
  }
  sn.x += d.x;
  sn.y += d.y;
}
*)

(* rnd-take *)

let rndTake arr =
  let n = Array.length arr in
  arr.(Random.int n)

(* mv-twrs *)

let mvTwrs () =

  twrs_lst :=
    List.map (fun twr ->
      if (Random.float 1.0) < 0.01 then
      begin
        let d = rndTake ds in
        let tx = twr.tx + d.dx in
        let ty = twr.ty + d.dy in
        { twr with tx; ty; }
      end
      else twr
    ) !twrs_lst;

  ()
;;


(* step-twrs. *)

let stepTwrs () =
  (*
  for (let tw of twrs) {
    tw.lim--;
  }
  *)
  twrs_lst :=
    List.map (fun twr ->
      let lim = twr.lim - 1 in
      { twr with lim; }
    ) !twrs_lst;

  (*
  twrs = twrs.filter(tw => tw.lim >= 0);
  *)

  twrs_lst :=
    List.filter (fun twr ->
      twr.lim >= 0
    ) !twrs_lst;
  
  mvTwrs ();
;;


(* step-funct. *)

let step_f () =
  begin
    match !sn_lst with
    | [ sn1; sn2; sn3; ] ->

        let sn1 = stepSn sn1 in
        let sn2 = stepSn sn2 in
        let sn3 = stepSn sn3 in
   
        sn_lst := [ sn1; sn2; sn3; ] ;

    | _ -> ()
  end;


  (*
  stepSn(sn1);
  stepSn(sn2);
  stepSn(sn3);

  stepTwrs();
  *)
  stepTwrs () ;
  ()
;;


let drawShp shp (x, y) cl =
  Canvas.lineWidth ctx 4.2;
  Canvas.strokeStyle ctx cl;
  Canvas.translate ctx (x) (y);
  Canvas.strokePath2D ctx shp;
  Canvas.translate ctx (-x) (-y);
;;

(*
*)

let drawTwr tw =
  Canvas.fillStyle ctx tw.cl1;
  Canvas.fillRect ctx (tw.tx-5) (tw.ty-5) (30) (30);
  drawShp cShp1 (tw.tx, tw.ty) tw.cl2;
;;

let setId () =
  Canvas.setTransform ctx 1.0 0.0 0.0 1.0 0.0 0.0;
;;

(*
let setId () =

let loadIdentity ctx =
  Canvas.setTransform ctx 1.0 0.0 0.0 1.0 0.0 0.0;
;;

*)

(*
let floor = truncate;;
*)
let floor id = id;;

let mvView () =
  setId ();
  Canvas.translate ctx (-(floor(sn1.sx / w) * w)) (-(floor(sn1.sy / h) * h));
;;


(* draw-funct. *)

let draw_f () =
  setId ();
  drawBg ();
  mvView ();

  (*
  setId();
  drawBg();
  mvView();

  for (let s of sn1.trail) drawRect(s.x, s.y, '#8888');
  for (let s of sn2.trail) drawRect(s.x, s.y, '#8888');
  for (let s of sn3.trail) drawRect(s.x, s.y, '#8888');
  *)

  begin
    match !sn_lst with
    | [ sn1; sn2; sn3; ] ->

        List.iter (fun (d) -> drawRect (d.dx, d.dy) "#8888") sn1.trail;
        List.iter (fun (d) -> drawRect (d.dx, d.dy) "#8888") sn2.trail;
        List.iter (fun (d) -> drawRect (d.dx, d.dy) "#8888") sn3.trail;

    | _ -> ()
  end;

  (*
  for (let tw of twrs) drawTwr(tw);
  *)
  List.iter
    drawTwr
    !twrs_lst;

  (*
  drawSn(sn1, '#ddd');
  drawSn(sn2, '#888');
  drawSn(sn3, '#888');
  *)
  (*
  *)
  begin
    match !sn_lst with
    | [ sn1; sn2; sn3; ] ->

        drawSn sn1 "#ddd";
        drawSn sn2 "#888";
        drawSn sn3 "#888";

    | _ -> ()
  end;

  ()
;;


(* first-loop *)

let animate_loop () =
  draw_f ();
  step_f ();
  ()
;;

(* main *)

(*

# 1000 / 5 ;;
- : int = 200

*)

let () =

  let one_second = 1000 in
  let _ = one_second in
  let _ = Canvas.setInterval animate_loop (1000 / 5) in  (* 5 frames per seconds *)
  ()
;;


(*

function loop() {
  draw();
  step();
}
setInterval(loop, 200);

*)

let setd sn d =
  let dir =
    if (sn.dir = d1 && d = d3) then d0 else
    if (sn.dir = d3 && d = d1) then d0 else
    if (sn.dir = d2 && d = d4) then d0 else
    if (sn.dir = d4 && d = d2) then d0 else
    d
  in
  { sn with dir; }
;;

let setd d =
  match !sn_lst with
  | [ sn1; sn2; sn3; ] ->
      let sn1 = setd sn1 d in
      sn_lst := [ sn1; sn2; sn3; ] ;
  | _ -> ()


type key_change = KeyDown | KeyUp


let key_event key_change ev =
  begin match key_change, ev.Canvas.keyCode with
  | KeyDown, 37 -> setd d3;  (* left *)
  | KeyDown, 39 -> setd d1;  (* right *)
  | KeyDown, 38 -> setd d4;  (* up *)
  | KeyDown, 40 -> setd d2;  (* down *)
  (*
    case 37: setd(sn1, d3); // left
    case 39: setd(sn1, d1); // right
    case 38: setd(sn1, d4); // up
    case 40: setd(sn1, d2); // down
  *)

  | _ -> ()
  end;

  begin match key_change, ev.Canvas.key with
  | KeyDown, "p" -> setd d0; (* setd(sn1, d0); *) ()
  | KeyDown, " " -> setd d0; (* setd(sn1, d0); *) ()
  | KeyDown, "a" -> putTwr sn1; (* putTwr(sn1);  *) ()
  | KeyDown, "s" -> swtchSn (); (* swtchSn();    *) ()

  | _ -> ()
  end;
;;

let () =

  (*
  let animate () =
    update ();
    display board ();
    ()
  in
  *)

  (*
  Canvas.addKeyEventListener Canvas.window "keydown" (keychange_event KeyDown) true;
  Canvas.addKeyEventListener Canvas.window "keyup"   (keychange_event KeyUp) true;
  *)

  Canvas.addKeyEventListener Canvas.window "keydown" (key_event KeyDown) true;
  Canvas.addKeyEventListener Canvas.window "keyup"   (key_event KeyUp) true;

  (*
  Canvas.addMouseEventListener Canvas.window "mousedown" (mouse_event board MouseDown) true;
  Canvas.addMouseEventListener Canvas.window "mouseup" (mouse_event board MouseUp) true;
  *)

  (*
  let _ = Canvas.setInterval animate (1000/20) in   (* 20 frames per seconds *)
  *)
  ()
;;

