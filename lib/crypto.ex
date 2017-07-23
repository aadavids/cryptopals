defmodule Crypto do
	# printable aes128 ecb
	def aes128_ecb_decrypt(ct, key) do
		:crypto.block_decrypt(:aes_ecb, key, ct) |> String.replace(~r/\x00|\x04/, "")
	end

	def pad_pkcs_7(block, len) do
		true = byte_size(block) < len
		pad_length = len - byte_size(block)
		block <> :binary.copy(<<pad_length>>, pad_length)
	end
end