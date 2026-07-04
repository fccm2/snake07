type document  // type to represent the html document
type context

@val external document: document = "document"
@val external window: Dom.element = "window"

@send external getElementById: (document, string) => Dom.element = "getElementById"
@send external getContext: (Dom.element, string) => context = "getContext"

@send external fillRect: (context, int, int, int, int) => unit = "fillRect"
@set external fillStyle: (context, string) => unit = "fillStyle"
@send external fillText: (context, string, int, int) => unit = "fillText"
@set external font: (context, string) => unit = "font"

@send external stroke: context => unit = "stroke"

type mouse_event = {
    clientX: int,
    clientY: int,
    offsetX: int,
    offsetY: int,
}

type key_event = {
  keyCode: int,
  key: string,
}

type interval_id

@send external addKeyEventListener: (Dom.element, string, key_event => unit, bool) => unit = "addEventListener"
@send external addMouseEventListener: (Dom.element, string, mouse_event => unit, bool) => unit = "addEventListener"

@val external setInterval: (unit => unit, int) => interval_id = "setInterval"

/*
  This file was made for learning purpose,
  you should use "rescript-webapi" instead, for a better interface:
  
    github.com > rescript-webapi

  https://github.com/tinymce/rescript-webapi

*/

/* Path2D */

type path2d
@new external newPath2D: string => path2d = "Path2D"
@send external fillPath2D: (context, path2d) => unit = "fill"
@send external strokePath2D: (context, path2d) => unit = "stroke"

/* empty */
@new external newPath2D_e: unit => path2d = "Path2D"

@send external pathArc: (path2d, float, float, int, int, float) => unit = "arc"

@send external translate: (context, int, int) => unit = "translate"

/*
@send external setTransform: (context, int, int, int, int, int, int) => unit = "setTransform"
*/
@send external setTransform: (context, float, float, float, float, float, float) => unit = "setTransform"

/*
let loadIdentity = (ctx) => { setTransform(ctx, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0) }
*/

@set external filter: (context, string) => unit = "filter"

@set external strokeStyle: (context, string) => unit = "strokeStyle"

@set external lineWidth: (context, float) => unit = "lineWidth"

@val external console_log: string => unit = "console.log"

