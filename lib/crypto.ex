defmodule Crypto do
	# printable aes128 ecb
	def aes128_ecb_decrypt(ct, key) do
		:crypto.block_decrypt(:aes_ecb, key, ct) |> String.replace(~r/\x00|\x04/, "")
	end


end