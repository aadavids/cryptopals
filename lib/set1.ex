defmodule Set1 do
	require Bitwise

	### challenge 1
	def challenge1(hex) do
		Bytes.hex_to_base64(hex)
	end

	### challenge 2
	def challenge2(hex1, hex2) do
		str1 = hex1 |> Bytes.hex_to_bytes
		str2 = hex2 |> Bytes.hex_to_bytes
		XOR.fixed_xor(str1, str2) |> Base.encode16 |> String.downcase
	end

	### challenge 3
	def challenge3(hex) do
		str = hex |> String.upcase |> Base.decode16!
		{_key, _score, str} = XOR.break_single_byte_xor(str)
		str
	end

	### challenge 4
	def challenge4 do
		{_c, _score, str} = "4.txt" |> File.read! |> String.split("\n") |> Enum.map(fn l -> Bytes.hex_to_bytes(l) end) |> XOR.detect_single_character_xor
		str
	end

	### challenge 5
	def challenge5(str, key) do
		XOR.repeating_key_xor(str, key) |> Bytes.bytes_to_hex
	end

	### challenge 6
	def challenge6 do
		ct = "6.txt" |> File.read! |> Base.decode64!(ignore: :whitespace)
		key = (for <<x::binary-29 <- ct>>, do: :binary.bin_to_list(x)) |> List.zip |> Enum.map(&Tuple.to_list/1) |> Enum.map(fn block -> :binary.list_to_bin(block) end) |> Enum.map(&XOR.break_single_byte_xor/1) |> Enum.reduce(<<>>, fn({c, _, _}, acc) -> acc <> <<c>> end)
		XOR.repeating_key_xor(ct, key)
	end

	def challenge7 do
		key = "YELLOW SUBMARINE"
		ct = "7.txt" |> File.read! |> Base.decode64!(ignore: :whitespace)
		Crypto.aes128_ecb_decrypt(ct, key)
	end	
end
