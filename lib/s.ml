(** A transport is used to send and receive bytes and file descriptors.
    Typically this will just call the usual Unix [sendmsg] and [recvmsg] functions,
    but other transports are possible. *)
class type transport = object
  method send : Cstruct.t -> Unix.file_descr list -> unit Lwt.t
  (** [send data fds] transmits the bytes of [data] and the file descriptors in [fds]. *)

  method recv : Cstruct.t -> (int * Unix.file_descr list) Lwt.t
  (** [recv buffer] reads incoming data from the remote peer.
      The data is read into [buffer] and the method returns the number of bytes
      read and the list of attached file descriptors. *)

  method shutdown : unit Lwt.t
  (** Shut down the sending side of the connection. This will cause the peer to read end-of-file. *)

  method up : bool
  (** [up] is [true] until the transport has sent or received an end-of-file
      (indicating that the connection is being shut down).
      This can be accessed via {!Proxy.transport_up}. *)

  method pp : Format.formatter -> unit
  (** Can be used for logging. *)
end

type ('a, 'role) user_data = ..
(** Extra data that can be attached to a proxy of type ['a] with ['role]. *)

type ('a, 'role) user_data += No_data
(** The default user data for a proxy. *)
