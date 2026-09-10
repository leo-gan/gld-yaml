from std.collections import List, Optional, Span

from yaml import (
    Box,
    DecodeError,
    EncodeOptions,
    YamlDatum,
    WireReader,
    WireWriter,
    encoded_float_len,
    encoded_int_len,
    encoded_string_len,
    read_bool,
    read_float,
    read_float_list,
    read_int_list,
    read_string_list,
    write_float_list,
    write_int_list,
    write_string_list,
)

struct Keywords(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var struct_: Int64
    var fn_: String
    var var_: Bool

    def __init__(out self):
        self.struct_ = Int64(0)
        self.fn_ = String()
        self.var_ = False

    def __init__(out self, var struct_: Int64, var fn_: String, var var_: Bool):
        self.struct_ = struct_^
        self.fn_ = fn_^
        self.var_ = var_^

    def encoded_len(self, options: EncodeOptions) -> Int:
        return self.encoded_len_at(options, 0)

    def encoded_len_at(self, options: EncodeOptions, depth: Int) -> Int:
        var n = 0
        var first = True
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 8
        n += encoded_int_len(self.struct_)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 4
        n += encoded_string_len(self.fn_.as_bytes(), options)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 5
        if self.var_:
            n += 4
        else:
            n += 5
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nstruct: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("struct: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("struct: ")
        first = False
        w.write_int(self.struct_)
        if not first:
            if depth == 0:
                w.write_ascii("\nfn: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("fn: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("fn: ")
        first = False
        w.write_string(self.fn_, options)
        if not first:
            if depth == 0:
                w.write_ascii("\nvar: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("var: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("var: ")
        first = False
        w.write_bool(self.var_)

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("struct".as_bytes()):
            self.struct_ = r.read_int()
        if r.next_key(st) and r.try_key("fn".as_bytes()):
            self.fn_ = r.read_string()
        if r.next_key(st) and r.try_key("var".as_bytes()):
            self.var_ = read_bool(r)
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
