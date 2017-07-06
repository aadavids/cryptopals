defmodule Set1 do
	require Bitwise

	# challenge 1
	def hex_to_base64(str) do
		str |> String.upcase |> Base.decode16! |> Base.encode64
	end

	# challenge 2
	def fixed_xor(str1, str2) do
		l1 = str1 |> String.upcase |> Base.decode16! |> :binary.bin_to_list
		l2 = str2 |> String.upcase |> Base.decode16! |> :binary.bin_to_list
		Enum.zip(l1, l2) |> Enum.map(fn({x,y}) -> Bitwise.bxor(x, y) end) |> :binary.list_to_bin |> Base.encode16 |> String.downcase
	end

	# challenge 3
end
