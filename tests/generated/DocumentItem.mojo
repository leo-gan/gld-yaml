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

struct DocumentItem(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var sku: String
    var qty: Int64
    var price_minor: Int64

    def __init__(out self):
        self.sku = String()
        self.qty = Int64(0)
        self.price_minor = Int64(0)

    def __init__(out self, var sku: String, var qty: Int64, var price_minor: Int64):
        self.sku = sku^
        self.qty = qty^
        self.price_minor = price_minor^

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
        n += encoded_string_len(self.sku.as_bytes(), options)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 5
        n += encoded_int_len(self.qty)
        if not first:
            n += 1
        first = False
        n += depth * options.indent
        n += 13
        n += encoded_int_len(self.price_minor)
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nsku: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("sku: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("sku: ")
        first = False
        w.write_string(self.sku, options)
        if not first:
            if depth == 0:
                w.write_ascii("\nqty: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("qty: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("qty: ")
        first = False
        w.write_int(self.qty)
        if not first:
            if depth == 0:
                w.write_ascii("\nprice_minor: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("price_minor: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("price_minor: ")
        first = False
        w.write_int(self.price_minor)

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("sku".as_bytes()):
            self.sku = r.read_string()
        if r.next_key(st) and r.try_key("qty".as_bytes()):
            self.qty = r.read_int()
        if r.next_key(st) and r.try_key("price_minor".as_bytes()):
            self.price_minor = r.read_int()
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
