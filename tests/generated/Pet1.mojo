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

struct Pet1(Copyable, Movable, Defaultable, Deinitable, YamlDatum):
    var breed: String

    def __init__(out self):
        self.breed = String()

    def __init__(out self, var breed: String):
        self.breed = breed^

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
        n += encoded_string_len(self.breed.as_bytes(), options)
        return n

    def encode_to(self, mut w: WireWriter, options: EncodeOptions):
        self.encode_to_at(w, options, 0, False)

    def encode_to_at(self, mut w: WireWriter, options: EncodeOptions, depth: Int, inline_first: Bool = False):
        var first = True
        if not first:
            if depth == 0:
                w.write_ascii("\nbreed: ")
            else:
                w.write_lf()
                w.indent_depth = depth
                w.write_indent(options)
                w.write_ascii("breed: ")
        else:
            if not inline_first:
                w.indent_depth = depth
                w.write_indent(options)
            w.write_ascii("breed: ")
        first = False
        w.write_string(self.breed, options)

    def decode_from[origin: ImmOrigin](mut self, mut r: WireReader[origin]) raises DecodeError:
        var saved = r.take_alias()
        var st = r.begin_map()
        if r.next_key(st) and r.try_key("breed".as_bytes()):
            self.breed = r.read_string()
        while r.next_key(st):
            r.skip_pair()
        r.end_map(st)
        if saved:
            r.end_alias(saved.value())
