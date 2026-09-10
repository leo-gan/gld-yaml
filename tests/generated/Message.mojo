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

struct Message(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var f_bool: Bool
    var f_int32: Int64
    var f_int64: Int64
    var f_float64: Float64
    var f_string: String
    var f_bool_2: Bool
    var f_int32_2: Int64
    var f_string_2: String

    def __init__(out self):
        self.f_bool = False
        self.f_int32 = Int64(0)
        self.f_int64 = Int64(0)
        self.f_float64 = 0.0
        self.f_string = String()
        self.f_bool_2 = False
        self.f_int32_2 = Int64(0)
        self.f_string_2 = String()

    def __init__(out self, var f_bool: Bool, var f_int32: Int64, var f_int64: Int64, var f_float64: Float64, var f_string: String, var f_bool_2: Bool, var f_int32_2: Int64, var f_string_2: String):
        self.f_bool = f_bool^
        self.f_int32 = f_int32^
        self.f_int64 = f_int64^
        self.f_float64 = f_float64^
        self.f_string = f_string^
        self.f_bool_2 = f_bool_2^
        self.f_int32_2 = f_int32_2^
        self.f_string_2 = f_string_2^

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
        if self.f_bool:
            n += 4
        else:
            n += 5
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 9
        n += encoded_int_len(self.f_int32)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 9
        n += encoded_int_len(self.f_int64)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 11
        n += encoded_float_len(self.f_float64)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 10
        n += encoded_string_len(self.f_string.as_bytes(), options)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 10
        if self.f_bool_2:
            n += 4
        else:
            n += 5
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 11
        n += encoded_int_len(self.f_int32_2)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 12
        n += encoded_string_len(self.f_string_2.as_bytes(), options)
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nf_bool: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_bool: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_bool: ")
        first = False
        w.write_bool(self.f_bool)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_int32: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_int32: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_int32: ")
        first = False
        w.write_int(self.f_int32)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_int64: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_int64: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_int64: ")
        first = False
        w.write_int(self.f_int64)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_float64: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_float64: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_float64: ")
        first = False
        w.write_float(self.f_float64)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_string: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_string: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_string: ")
        first = False
        w.write_string(self.f_string, options)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_bool_2: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_bool_2: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_bool_2: ")
        first = False
        w.write_bool(self.f_bool_2)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_int32_2: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_int32_2: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_int32_2: ")
        first = False
        w.write_int(self.f_int32_2)
        if not first:
            if depth == 0:
                w.write_ascii("\nf_string_2: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("f_string_2: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("f_string_2: ")
        first = False
        w.write_string(self.f_string_2, options)

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("f_bool".as_bytes()):
            self.f_bool = read_bool(r)
        if r.next_key(st) and r.try_key("f_int32".as_bytes()):
            self.f_int32 = r.read_int()
        if r.next_key(st) and r.try_key("f_int64".as_bytes()):
            self.f_int64 = r.read_int()
        if r.next_key(st) and r.try_key("f_float64".as_bytes()):
            self.f_float64 = read_float(r)
        if r.next_key(st) and r.try_key("f_string".as_bytes()):
            self.f_string = r.read_string()
        if r.next_key(st) and r.try_key("f_bool_2".as_bytes()):
            self.f_bool_2 = read_bool(r)
        if r.next_key(st) and r.try_key("f_int32_2".as_bytes()):
            self.f_int32_2 = r.read_int()
        if r.next_key(st) and r.try_key("f_string_2".as_bytes()):
            self.f_string_2 = r.read_string()
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
