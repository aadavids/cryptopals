module Set1 do
  def hex_to_base64 hex
    [[hex].pack("H*")].pack("m")
  end
end
