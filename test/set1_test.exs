defmodule Set1Test do
	use ExUnit.Case
	doctest Set1

	test "Challenge 1" do
		hex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
		base64 = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
		assert Set1.hex_to_base64(hex) == base64
	end

	test "Challenge 2" do
		hex1 = "1c0111001f010100061a024b53535009181c"
		hex2 = "686974207468652062756c6c277320657965"
		xord = "746865206b696420646f6e277420706c6179"
		assert Set1.fixed_xor_hex(hex1, hex2) == xord
	end

	test "Challenge 3" do
		hex = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
		assert Set1.break_single_byte_xor(hex) == "Cooking MC's like a pound of bacon"
	end

	test "Challenge 5" do
		key = "ICE"
		str = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
		encrypted = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
		assert Set1.repeating_key_xor(str, key) == encrypted
	end
end
