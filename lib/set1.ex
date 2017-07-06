defmodule Set1 do
	require Bitwise

	### challenge 1
	def hex_to_base64(hex) do
		hex |> String.upcase |> Base.decode16! |> Base.encode64
	end

	### challenge 2
	def fixed_xor_hex(hex1, hex2) do
		l1 = hex1 |> String.upcase |> Base.decode16! |> :binary.bin_to_list
		l2 = hex2 |> String.upcase |> Base.decode16! |> :binary.bin_to_list
		Enum.zip(l1, l2) |> Enum.map(fn({x,y}) -> Bitwise.bxor(x, y) end) |> :binary.list_to_bin |> Base.encode16 |> String.downcase
	end

	def fixed_xor(b1, b2) do
		Enum.zip(:binary.bin_to_list(b1), :binary.bin_to_list(b2)) 
		|> Enum.map(fn({x,y}) -> Bitwise.bxor(x, y) end) 
		|> :binary.list_to_bin 
	end

	def single_byte_xor(str, byte) do
		String.duplicate(byte, byte_size(str))
		fixed_xor(str, String.duplicate(byte, byte_size(str)))
	end

	def score(str) do
	# ETAOIN SHRDLU
	# http://www.data-compression.com/english.html
	frequency_table = %{"a" => 0.0651738, "b" => 0.0124248, "c" => 0.0217339, "d" => 0.0349835, "e" => 0.1041442, "f" => 0.0197881, "g" => 0.0158610, "h" => 0.0492888, "i" => 0.0558094,
	"j" => 0.0009033, "k" => 0.0050529, "l" => 0.0331490, "m" => 0.0202124, "n" => 0.0564513, "o" => 0.0596302, "p" => 0.0137645, "q" => 0.0008606, "r" => 0.0497563, "s" => 0.0515760,
	"t" => 0.0729357, "u" => 0.0225134, "v" => 0.0082903, "w" => 0.0171272, "x" => 0.0013692, "y" => 0.0145984, "z" => 0.0007836, " " => 0.1918182}
	
	str |> String.downcase |> String.graphemes |> Enum.filter(fn c -> Map.has_key?(frequency_table, c) end) |> Enum.sort |> Enum.chunk_by(fn arg -> arg end) |> Enum.reduce(0, fn(l, acc) -> acc + frequency_table[List.first(l)] * Kernel.length(l) end)
	end

	### challenge 3
	def break_single_byte_xor(hex) do
		str = hex |> String.upcase |> Base.decode16!
		character_table = Enum.concat(?A..?Z, ?a..?z) |> List.to_string |> String.graphemes
		decode_list = Enum.map(character_table, fn c -> single_byte_xor(str, c) end)
		Enum.max_by(decode_list, fn str -> score(str) end)
	end
end
