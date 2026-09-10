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

from DocumentMeta import DocumentMeta
from DocumentItem import DocumentItem

struct Document(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var id: String
    var status: Int64
    var meta: DocumentMeta
    var items: List[DocumentItem]

    def __init__(out self):
        self.id = String()
        self.status = Int64(0)
        self.meta = DocumentMeta()
        self.items = List[DocumentItem]()

    def __init__(out self, var id: String, var status: Int64, var meta: DocumentMeta, var items: List[DocumentItem]):
        self.id = id^
        self.status = status^
        self.meta = meta^
        self.items = items^

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
        n += encoded_string_len(self.id.as_bytes(), options)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 8
        n += encoded_int_len(self.status)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 6
        n += self.meta.encoded_len_at(options, depth + 1)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 7
        n += 1 + len(self.items) * 8
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nid: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("id: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("id: ")
        first = False
        w.write_string(self.id, options)
        if not first:
            if depth == 0:
                w.write_ascii("\nstatus: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("status: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("status: ")
        first = False
        w.write_int(self.status)
        if not first:
            if depth == 0:
                w.write_ascii("\nmeta: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("meta: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("meta: ")
        first = False
        w.write_lf()
        self.meta.encode_to_at(w, options, depth + 1, False)
        if not first:
            if depth == 0:
                w.write_ascii("\nitems: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("items: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("items: ")
        first = False
        w.write_lf()
        var _i = 0
        while _i < len(self.items):
            if _i > 0:
                w.write_lf()
            w.indent_depth = depth
            w.write_indent(options)
            w.write_ascii("- ")
            self.items[_i].encode_to_at(w, options, depth + 1, True)
            _i += 1

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("id".as_bytes()):
            self.id = r.read_string()
        if r.next_key(st) and r.try_key("status".as_bytes()):
            self.status = r.read_int()
        if r.next_key(st) and r.try_key("meta".as_bytes()):
            var _c = DocumentMeta()
            _c.decode_from(r)
            self.meta = _c^
        if r.next_key(st) and r.try_key("items".as_bytes()):
            self.items = List[DocumentItem]()
            var _st = r.begin_seq()
            while r.next_item(_st):
                var _el = DocumentItem()
                _el.decode_from(r)
                self.items.append(_el^)
            r.end_seq(_st)
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
