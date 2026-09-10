from codegen.names import mojo_ident


def main() raises:
    if mojo_ident("struct") != "struct_":
        raise Error("struct")
    if mojo_ident("value") != "value":
        raise Error("value")
    print("test_codegen_names ok")
