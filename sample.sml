module Piu
  type List a = Cons a (List a) | Nil

  multiplier = 2
  multiply x = x * multiplier
end

multiply 5 |> IO.puts

(|>) x f = f x

Piu.type_of_module => "Piu"

{index : Index} => {index : Index}

func formationAt(index: Index) ->


formationAt(index: q)


formation_at {index : Index, padding : Integer} =
  index
formation_at {index : Index} =
  index


formation_at {index: my_local_index}


(|>) x f -> f x


multiplier -> 2

to_bool x : Int -> Bool =
  if x == 0 then
    False
  else
    True
  end













    False


module Tcp
  type Socket
  type Error

  ffi gen_tcp, listen : Int -> Dict -> Result Socket Error
end

module EchoServer
  import Tcp

  start () = listen 1234

  listen port =
    match Tcp.listen port [packet: 0, active: False] with
      Ok socket ->
        accept socket
      Error reason ->
        error reason
    end

  accept listen_socket =
    match Tcp.accept listen_socket with
      Ok socket ->
        spawn fn () => echo socket end
        accept listen_socket
      Error reason ->
        error reason
    end

  echo socket =
    match Tcp.recv socket 0 with
      Ok data ->
        Tcp.send socket data
        echo socket
      Error Tcp.Closed ->
        ()
    end
end

(* 1 arith
   parens for priority, binary operators + and *, presedence and associativity, integers, floats, unary minus *)
(1 + 2) * 3

(* 2 defs *)

plus3 x = x + 3

pipe_right x f = f x
alias pipe_right |>

append x y = ...
alias append <>

main () = begin
  nine = plus3 (plus3 3)
  nine * 2
    |> print
    |> olo

  [1, 2] <> [3, 4]
  [1, 2]
    <> [3, 4]
  x = [1, 2] <>
  [3, 4]

  True
    && False
end

module Transcoder.Listener exports (start_link) where
  import Logger
  import Transcoder

  max_wait_time_in_secs = 20

  in_queue = Transcoder.config #in_queue

  out_queue = Transcoder.config #out_queue

  in_bucket = Transcoder.config #in_bucket

  out_bucket = Transcoder.config #out_bucket

  downloaded_file = "downloaded.mp4"

  processing_file = "processing.mov"

  processed_file = "processed.mp4"

  start_link () =
    Task.start_link __MODULE__ :loop []

  loop () =
    begin
      match receive_message () with
        Nothing ->
          ()
        Just [#body: message, #receipt_handle: receipt_handle] ->
          message
            |> Json.decode
            |> process_message

          delete_message receipt_handle
      end

      loop ()
    end

  receive_message () =
    begin
      query = ExAws.SQS.receive_message in_queue
      timeout_in_msecs = (max_wait_time_in_secs + 1) * 1000

      params = Dict.put query.params "WaitTimeSeconds" max_wait_time_in_secs

      {query | params = params}
        |> ExAws.request [#http_opts => [#recv_timeout => timeout_in_msecs]]
        |> get_in [#body, #message]
    end

  process_message message =
    match message with
      [#file_name: file_name, #meta: meta] ->
        Logger.info "Start processing #{file_name}"

        download_file file_name
        force_rotation ()
        upload_file file_name
        report file_name meta
      unexpected ->
        Logger.warn "Unexpected message: #{inspect(unexpected)}"
    end

  download_file file_name =
    ExAws.S3.download_file in_bucket file_name downloaded_file
      |> ExAws.request

  force_rotation () =
    begin
      System.cmd "ffmpeg" ["-y", "-i", downloaded_file, "-c:v", "h264", "-c:a", "copy", processing_file]
      System.cmd "ffmpeg" ["-y", "-i", processing_file, "-c:v", "copy", "-c:a", "copy", processed_file]
    end

  upload_file file_name =
    processed_file
      |> ExAws.S3.Upload.stream_file
      |> ExAws.S3.upload out_bucket file_name
      |> ExAws.request

  report file_name meta) =
    ExAws.SQS.send_message out_queue Json.encode([#file_name: file_name, #meta: meta])
      |> ExAws.request

  delete_message receipt_handle =
    ExAws.SQS.delete_message in_queue receipt_handle
      |> ExAws.request
end


module Transcoder.Listener exports (start_link) where
  import Logger
  import Transcoder

  max_wait_time_in_secs = 20

  in_queue = Transcoder.config &in_queue

  out_queue = Transcoder.config &out_queue

  in_bucket = Transcoder.config &in_bucket

  out_bucket = Transcoder.config &out_bucket

  downloaded_file = "downloaded.mp4"

  processing_file = "processing.mov"

  processed_file = "processed.mp4"

  start_link # =
    Task.start_link __MODULE__ &loop []

  loop # =
    begin
      match receive_message # with
        Nothing ->
          #
        Just [&body: message, &receipt_handle: receipt_handle] ->
          message
            |> Json.decode
            |> process_message

          delete_message receipt_handle
      end

      loop #
    end

  receive_message # =
    begin
      query = ExAws.SQS.receive_message in_queue
      timeout_in_msecs = (max_wait_time_in_secs + 1) * 1000

      params = Dict.put query.params "WaitTimeSeconds" max_wait_time_in_secs

      {query | params = params}
        |> ExAws.request [&http_opts => [&recv_timeout => timeout_in_msecs]]
        |> get_in [&body, &message]
    end

  process_message message =
    match message with
      [&file_name: file_name, &meta: meta] ->
        Logger.info "Start processing \(file_name)"

        download_file file_name
        force_rotation #
        upload_file file_name
        report file_name meta
      unexpected ->
        Logger.warn "Unexpected message: \(inspect unexpected)"
    end

  download_file file_name =
    ExAws.S3.download_file in_bucket file_name downloaded_file
      |> ExAws.request

  force_rotation # =
    begin
      System.cmd "ffmpeg" ["-y", "-i", downloaded_file, "-c:v", "h264", "-c:a", "copy", processing_file]
      System.cmd "ffmpeg" ["-y", "-i", processing_file, "-c:v", "copy", "-c:a", "copy", processed_file]
    end

  upload_file file_name =
    processed_file
      |> ExAws.S3.Upload.stream_file
      |> ExAws.S3.upload out_bucket file_name
      |> ExAws.request

  report file_name meta =
    Json.encode [&file_name: file_name, &meta: meta]
      |> ExAws.SQS.send_message out_queue
      |> ExAws.request

  delete_message receipt_handle =
    ExAws.SQS.delete_message in_queue receipt_handle
      |> ExAws.request
end
