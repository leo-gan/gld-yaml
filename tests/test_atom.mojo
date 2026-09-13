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
    test_flow_json_object()
    test_duplicate_key_rejected()
    test_directive_only_rejected()
    test_yaml13_directive_ok()
    print("test_atom ok")


def test_flow_json_object() raises:
    var v = decode_value("{\"harbor\":\"kelp\",\"count\":3}".as_bytes())
    if not v.is_map():
        raise Error("flow object")
    if v.get("harbor").as_str() != "kelp":
        raise Error("harbor")
    if v.get("count").as_int() != Int64(3):
        raise Error("count")


def test_duplicate_key_rejected() raises:
    var raised = False
    try:
        _ = decode_value("harbor: 1\nharbor: 2\n".as_bytes())
    except _:
        raised = True
    if not raised:
        raise Error("dup key")


def test_directive_only_rejected() raises:
    var raised = False
    try:
        _ = decode_value("%YAML 1.2\n".as_bytes())
    except _:
        raised = True
    if not raised:
        raise Error("directive only")


def test_yaml13_directive_ok() raises:
    var v = decode_value("%YAML 1.3\n---\n\"foo\"\n".as_bytes())
    if v.as_str() != "foo":
        raise Error("yaml 1.3")


def _round(text: String, _unused: Bool) raises:
    _ = _unused
    var v = decode_value(text.as_bytes())
    var out = encode_value(v)
    var v2 = decode_value(Span(out))
    _ = v2
