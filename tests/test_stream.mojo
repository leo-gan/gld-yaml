from yaml import YamlValue, decode_all_values, encode_all_values, yaml_int


def main() raises:
    var docs = decode_all_values("1\n---\n2\n".as_bytes())
    if len(docs) != 2:
        raise Error("count")
    if docs[0].as_int() != Int64(1) or docs[1].as_int() != Int64(2):
        raise Error("values")
    var empty = decode_all_values("".as_bytes())
    if len(empty) != 0:
        raise Error("empty")
    var one = List[YamlValue]()
    one.append(yaml_int(Int64(3)))
    var buf = encode_all_values(one)
    var back = decode_all_values(buf)
    if back[0].as_int() != Int64(3):
        raise Error("round")
    print("test_stream ok")
