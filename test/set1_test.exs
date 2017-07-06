defmodule Set1Test do
  use ExUnit.Case
  doctest Set1

  test "converts hex string to base64" do
  	hex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  	base64 = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
    assert Set1.hex_to_base64(hex) == base64
  end
end