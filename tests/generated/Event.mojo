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

from EventAttr import EventAttr

struct Event(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var ts: Int64
    var attrs: List[EventAttr]

    def __init__(out self):
        self.ts = Int64(0)
        self.attrs = List[EventAttr]()

    def __init__(out self, var ts: Int64, var attrs: List[EventAttr]):
        self.ts = ts^
        self.attrs = attrs^

    def encoded_len(self, options: EncodeOptions) -> Int:
        return self.encoded_len_at(options, 0)

    def encoded_len_at(self, options: EncodeOptions, depth: Int) -> Int:
        var n = 0
        var first = True
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 4
        n += encoded_int_len(self.ts)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 7
        n += 1 + len(self.attrs) * 8
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nts: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("ts: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("ts: ")
        first = False
        w.write_int(self.ts)
        if not first:
            if depth == 0:
                w.write_ascii("\nattrs: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("attrs: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("attrs: ")
        first = False
        w.write_lf()
        var _i = 0
        while _i < len(self.attrs):
            if _i > 0:
                w.write_lf()
            w.indent_depth = depth
            w.write_indent(options)
            w.write_ascii("- ")
            self.attrs[_i].encode_to_at(w, options, depth + 1, True)
            _i += 1

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("ts".as_bytes()):
            self.ts = r.read_int()
        if r.next_key(st) and r.try_key("attrs".as_bytes()):
            self.attrs = List[EventAttr]()
            var _st = r.begin_seq()
            while r.next_item(_st):
                var _el = EventAttr()
                _el.decode_from(r)
                self.attrs.append(_el^)
            r.end_seq(_st)
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
