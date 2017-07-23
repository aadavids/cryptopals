defmodule Bytes do
	def hex_to_bytes(hex) do
		hex |> String.upcase |> Base.decode16!
	end

	def bytes_to_hex(bytes) do
		bytes |> Base.encode16 |> String.downcase
	end

	def hex_to_base64(hex) do
		hex_to_bytes(hex) |> Base.encode64
	end
end