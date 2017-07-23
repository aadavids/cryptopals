defmodule XOR do
	require Bitwise
	def fixed_xor(b1, b2) do
		Enum.zip(:binary.bin_to_list(b1), :binary.bin_to_list(b2)) 
		|> Enum.map(fn({x,y}) -> Bitwise.bxor(x, y) end) 
		|> :binary.list_to_bin 
	end

	def single_byte_xor(str, single_byte_key) do
		:binary.copy(single_byte_key, byte_size(str))
		XOR.fixed_xor(str, :binary.copy(single_byte_key, byte_size(str)))
	end

	def break_single_byte_xor(str) do
		character_table = 0..255
		decode_list = Enum.map(character_table, fn c -> {c, single_byte_xor(str, <<c>>)} end)
		Enum.map(decode_list, fn {c, str} -> {c, English.score(str), str} end) |> Enum.max_by(fn {_c, score, _str} -> score end)
	end

	def detect_single_character_xor(file_list) do
		file_list |> Enum.map(fn l -> XOR.break_single_byte_xor(l) end) 
		|> Enum.max_by(fn {_c, score, _str} -> score end)
	end

	def repeating_key_xor(str, key) do
		repeated_key = :binary.copy(key, byte_size(str) + 1) |> String.slice(0, byte_size(str))
		fixed_xor(str, repeated_key)
	end

	def break_repeating_key_xor(ct) do
	key_size = Enum.min_by(2..40, fn ks -> English.hamming_distance(Kernel.binary_part(ct, 0,ks), Kernel.binary_part(ct, ks,ks*2))/ks end)
	(for <<x::binary-2 <- ct>>, do: :binary.bin_to_list(x)) |> List.zip
	# (for <<x::binary-5 <- ct>>, do: :binary.bin_to_list(x)) |> List.zip |> Enum.map(&Tuple.to_list/1) |> Enum.map(fn block -> :binary.list_to_bin(block) end) |> Enum.map(&Set1.break_single_byte_xor/1)
	# key = (for <<x::binary-5 <- ct>>, do: :binary.bin_to_list(x)) |> List.zip |> Enum.map(&Tuple.to_list/1) |> Enum.map(fn block -> :binary.list_to_bin(block) end) |> Enum.map(&XOR.break_single_byte_xor/1) |> Enum.reduce(<<>>, fn({c, _, _}, acc) -> acc <> <<c>> end)
	end
end