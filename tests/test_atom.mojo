from yaml import DecodeError, decode_value, encode_value, yaml_bool, yaml_int, yaml_null, yaml_string


def main() raises:
    _round("null\n", True)
    _round("true\n", True)
    _round("false\n", False)
    _round("0\n", False)
    _round("150\n", False)
    _round("-1\n", False)
    _round("hi\n", False)
    var v = decode_value("true".as_bytes())
    if not v.as_bool():
        raise Error("true")
    v = decode_value("null".as_bytes())
    if not v.is_null():
        raise Error("null")
    v = decode_value("150".as_bytes())
    if v.as_int() != Int64(150):
        raise Error("150")
    v = decode_value("\"hi\"".as_bytes())
    if v.as_str() != "hi":
        raise Error("hi")
    var n = yaml_null()
    var b = encode_value(n)
    if len(b) < 4:
        raise Error("encode null")
    print("test_atom ok")


def _round(text: String, _unused: Bool) raises:
    _ = _unused
    var v = decode_value(text.as_bytes())
    var out = encode_value(v)
    var v2 = decode_value(Span(out))
    _ = v2
