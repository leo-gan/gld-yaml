from std.time import perf_counter_ns

from yaml import decode, encode, encode_into

from Message import Message


def _sample() -> Message:
    var m = Message()
    m.f_bool = True
    m.f_int32 = Int64(1)
    m.f_int64 = Int64(150)
    m.f_float64 = 1.5
    m.f_string = String("hi")
    m.f_bool_2 = False
    m.f_int32_2 = Int64(2)
    m.f_string_2 = String("z")
    return m^


def main() raises:
    var m = _sample()
    var dest = List[Byte]()
    var i = 0
    while i < 200:
        _ = encode_into(m, dest)
        i += 1
    var n = 30000
    var t0 = perf_counter_ns()
    i = 0
    var enc_n = 0
    while i < n:
        enc_n = encode_into(m, dest)
        i += 1
    var t1 = perf_counter_ns()
    var enc_dt = Int(t1 - t0) // n
    t0 = perf_counter_ns()
    i = 0
    while i < n:
        _ = decode[Message](dest)
        i += 1
    var t2 = perf_counter_ns()
    var dec_dt = Int(t2 - t0) // n
    print("encode_ns", enc_dt, "decode_ns", dec_dt, "bytes", enc_n)
    _ = encode(m)
