from yaml import decode_value, encode_value, yaml_int, yaml_string


def main() raises:
    var v = decode_value("hello: 1\n".as_bytes())
    var out = encode_value(v)
    print(String(from_utf8=out))
    _ = yaml_int(Int64(1))
    _ = yaml_string("ok")
