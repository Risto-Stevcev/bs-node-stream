type 'a t

type readable = [ `readable ]
 and writable = [ `writable ]
type duplex = [ readable | writable ]


module Readable = struct
  external make: unit -> readable t = "Readable" [@@bs.module "stream"] [@@bs.new]
  external read: [> readable] t -> int -> unit = "read" [@@bs.send]
  external pipe: [> readable] t -> [> writable] t -> unit = "pipe" [@@bs.send]

  external on_data: (_ [@bs.as "data"]) -> (Node.Buffer.t -> unit) -> unit = "on"
  [@@bs.send.pipe: [> readable] t]

  external on_end: (_ [@bs.as "end"]) -> (unit -> unit) -> unit = "on"
  [@@bs.send.pipe: [> readable] t]
end


module Writable = struct
  external make: unit -> writable t = "Writable" [@@bs.module "stream"] [@@bs.new]
  external write: [> writable] t -> string -> unit = "write" [@@bs.send]
  external write': [> writable] t -> Node.Buffer.t -> unit = "write" [@@bs.send]
  external end_: [> writable] t -> unit -> unit = "end" [@@bs.send]
end


module Duplex = struct
  external pass_through: unit -> duplex t = "PassThrough" [@@bs.module "stream"] [@@bs.new]
end


external stdin: readable t = "stdin" [@@bs.val] [@@bs.scope "process"]
external stdout: writable t = "stdout" [@@bs.val] [@@bs.scope "process"]
