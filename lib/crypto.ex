defmodule Crypto do
	# printable aes128 ecb
	def aes128_ecb_decrypt(ct, key) do
		:crypto.block_decrypt(:aes_ecb, key, ct)
	end

	def aes128_ecb_encrypt(pt, key) do
		:crypto.block_encrypt(:aes_ecb, key, pt)
	end

	def pad_pkcs_7(block, len) when byte_size(block) == len, do: block
	def pad_pkcs_7(block, len) do
		true = byte_size(block) < len
		pad_length = len - byte_size(block)
		block <> :binary.copy(<<pad_length>>, pad_length)
	end

	def unpad_pkcs_7(block) do
		pad = block |> :binary.last
		cond do
			pad > byte_size(block) -> block
			:binary.part(block, byte_size(block), -pad) == :binary.copy(<<pad>>, pad) -> :binary.part(block, 0, byte_size(block) -pad)
			true -> block
		end
	end

	def aes128_cbc_decrypt(ct, key, iv) do
		(for <<block::binary-16 <- ct>>, do: block)
			|> Enum.map_reduce(iv, fn(block, acc) -> {XOR.fixed_xor(aes128_ecb_decrypt(block, key), acc), block} end)
			|> elem(0)
			|> Enum.map(&Crypto.unpad_pkcs_7(&1))
			|> Enum.join
	end

	def aes128_cbc_encrypt(pt, key, iv) do
		padded_pt = pad_pkcs_7(pt, (byte_size(pt)/16 |> Float.ceil) * 16 |> Kernel.trunc)
		(for <<block::binary-16 <- padded_pt>>, do: block)
			|> Enum.scan(iv, fn(block, acc) -> aes128_ecb_encrypt(XOR.fixed_xor(block, acc), key) end)
			|> Enum.join
	end
end
