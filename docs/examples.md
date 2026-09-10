# Examples

## Generated struct

```mojo
from yaml import decode, encode
from Message import Message

def main() raises:
    var m = Message()
    m.f_bool = True
    m.f_int64 = Int64(150)
    m.f_string = String("hi")
    var buf = encode(m)
    var back = decode[Message](buf)
    print(back.f_string)
```

`encode` writes block YAML with a 2-space indent and ends the document with
one `LF`. `decode` reads one document and rejects a second one.

## Dynamic value

```mojo
from yaml import decode_value, encode_value

def main() raises:
    var v = decode_value("a: 1\nb: [2, 3]\n".as_bytes())
    print(v.get("a").as_int())
    var out = encode_value(v)
```

`YamlValue` is an arena. `at`, `pair`, and `get` return views of the same
arena with a different root index.

## Multi-document stream

```mojo
from yaml import decode_all_values, encode_all_values

def main() raises:
    var docs = decode_all_values("1\n---\n2\n".as_bytes())
    print(docs[0].as_int(), docs[1].as_int())
```

An empty buffer is a valid empty stream.
