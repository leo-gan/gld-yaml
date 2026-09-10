from yaml import parse_schema_file


def main() raises:
    var doc = parse_schema_file("testdata/schema/benchmark_v2.json")
    if doc.root_name != "Message":
        raise Error(doc.root_name)
    print("test_schema_parse ok")
