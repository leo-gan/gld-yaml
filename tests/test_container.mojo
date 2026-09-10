from yaml import decode_value, encode_value


def main() raises:
    var v = decode_value("a: 1\nb: 2\n".as_bytes())
    if not v.is_map():
        raise Error("map")
    if v.get("a").as_int() != Int64(1):
        raise Error("a")
    if v.get("b").as_int() != Int64(2):
        raise Error("b")
    v = decode_value("- 1\n- 2\n".as_bytes())
    if not v.is_seq():
        raise Error("seq")
    if v.count() != 2:
        raise Error("count")
    if v.at(0).as_int() != Int64(1):
        raise Error("0")
    v = decode_value("items:\n- sku: a\n  qty: 1\n".as_bytes())
    if not v.is_map():
        raise Error("items map")
    var items = v.get("items")
    if items.count() != 1:
        raise Error("items count")
    if items.at(0).get("sku").as_str() != "a":
        raise Error("sku")
    var enc = encode_value(v)
    var v2 = decode_value(enc)
    if v2.get("items").at(0).get("qty").as_int() != Int64(1):
        raise Error("roundtrip qty")
    print("test_container ok")
