defmodule Set1 do
	def hex_to_base64(hex) do
		hex |> String.upcase |> Base.decode16! |> Base.encode64
	end
end