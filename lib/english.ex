defmodule English do
	require Bitwise

	def score(str) do
		# ETAOIN SHRDLU
		# http://www.data-compression.com/english.html
		frequency_table = %{"a" => 0.0651738, "b" => 0.0124248, "c" => 0.0217339, "d" => 0.0349835, "e" => 0.1041442, "f" => 0.0197881, "g" => 0.0158610, "h" => 0.0492888, "i" => 0.0558094,
			"j" => 0.0009033, "k" => 0.0050529, "l" => 0.0331490, "m" => 0.0202124, "n" => 0.0564513, "o" => 0.0596302, "p" => 0.0137645, "q" => 0.0008606, "r" => 0.0497563, "s" => 0.0515760,
			"t" => 0.0729357, "u" => 0.0225134, "v" => 0.0082903, "w" => 0.0171272, "x" => 0.0013692, "y" => 0.0145984, "z" => 0.0007836, " " => 0.1918182}
	
		str |> String.downcase |> String.graphemes 
			|> Enum.filter(fn c -> Map.has_key?(frequency_table, c) end) 
			|> Enum.sort |> Enum.chunk_by(fn arg -> arg end) |> 
			Enum.reduce(0, fn(l, acc) -> acc + frequency_table[List.first(l)] * Kernel.length(l) end)
	end

	def hamming_distance(str1, str2) do
		Enum.zip(:binary.bin_to_list(str1), :binary.bin_to_list(str2)) 
		|> Enum.map(fn {b1, b2} -> Bitwise.bxor(b1,b2) end) 
		|> Enum.map(fn xored -> for(<<bit::1 <- :binary.encode_unsigned(xored)>>, do: bit) 
		|> Enum.sum end) |> Enum.sum
	end
end