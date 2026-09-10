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

struct EventAttr(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var key: String
    var value: String

    def __init__(out self):
        self.key = String()
        self.value = String()

    def __init__(out self, var key: String, var value: String):
        self.key = key^
        self.value = value^

    def encoded_len(self, options: EncodeOptions) -> Int:
        return self.encoded_len_at(options, 0)

    def encoded_len_at(self, options: EncodeOptions, depth: Int) -> Int:
        var n = 0
        var first = True
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 5
        n += encoded_string_len(self.key.as_bytes(), options)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 7
        n += encoded_string_len(self.value.as_bytes(), options)
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nkey: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("key: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("key: ")
        first = False
        w.write_string(self.key, options)
        if not first:
            if depth == 0:
                w.write_ascii("\nvalue: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("value: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("value: ")
        first = False
        w.write_string(self.value, options)

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("key".as_bytes()):
            self.key = r.read_string()
        if r.next_key(st) and r.try_key("value".as_bytes()):
            self.value = r.read_string()
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
