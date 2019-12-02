open BsMocha
let describe, it = Mocha.describe, Async.it;;


describe "Node_Stream" (fun () -> begin
  it "should work" (fun done_ -> begin
    let open Node_Stream
    in
    let stream_a = Duplex.pass_through ()
    and stream_b = Duplex.pass_through ()
    and arr = [||]
    in
    let _ =
      stream_b |> Readable.on_data (fun data -> Js.Array.push data arr |> ignore);
      stream_b
      |> Readable.on_end (fun () -> begin
           let result = arr |> Js.Array.map Node.Buffer.toString
           in
           Assert.deep_equal result [|"foo"; "bar"|];
           done_ ()
         end)
    in
    Readable.pipe stream_a stream_b;
    Writable.write stream_a "foo";
    Writable.write stream_a "bar";
    Writable.end_ stream_a ();
  end)
end)
