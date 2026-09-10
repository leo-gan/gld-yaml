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

struct LongList(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var value: Int64
    var next: Optional[Int64]

    def __init__(out self):
        self.value = Int64(0)
        self.next = Optional[Int64]()

    def __init__(out self, var value: Int64, var next: Optional[Int64]):
        self.value = value^
        self.next = next^

    def encoded_len(self, options: EncodeOptions) -> Int:
        return self.encoded_len_at(options, 0)

    def encoded_len_at(self, options: EncodeOptions, depth: Int) -> Int:
        var n = 0
        var first = True
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 7
        n += encoded_int_len(self.value)
        if self.next:
            if not first:
                n += 1
            first = False
            n += depth * options.indent
            n += 6
            n += encoded_int_len(self.next.value())
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
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
        w.write_int(self.value)
        if self.next:
            if not first:
                if depth == 0:
                    w.write_ascii("\nnext: ")
                else:
                    w.write_lf()
                    w.indent_depth = depth
                    w.write_indent(options)
                    w.write_ascii("next: ")
            else:
                if not inline_first:
                    w.indent_depth = depth
                    w.write_indent(options)
                w.write_ascii("next: ")
            first = False
            w.write_int(self.next.value())

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        self.next = Optional[Int64]()
        if r.next_key(st) and r.try_key("value".as_bytes()):
            self.value = r.read_int()
        if r.next_key(st) and r.try_key("next".as_bytes()):
            if r.peek_is_null():
                r.read_null()
                self.next = Optional[Int64]()
            else:
                var _o = Int64()
                _o.decode_from(r)
                self.next = Optional[Int64](_o^)
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
