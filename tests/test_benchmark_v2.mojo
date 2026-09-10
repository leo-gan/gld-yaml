from yaml import decode, encode

from Document import Document
from DocumentItem import DocumentItem
from DocumentMeta import DocumentMeta
from Telemetry import Telemetry


def main() raises:
    var d = Document()
    d.id = String("d1")
    d.status = Int64(1)
    d.meta.region = String("us")
    d.meta.version = Int64(2)
    var it = DocumentItem()
    it.sku = String("a")
    it.qty = Int64(1)
    it.price_minor = Int64(99)
    d.items.append(it^)
    var buf = encode(d)
    var back = decode[Document](buf)
    if (
        back.id != "d1"
        or back.items[0].sku != "a"
        or back.items[0].qty != Int64(1)
        or back.meta.version != Int64(2)
    ):
        raise Error("document")
    var t = Telemetry()
    t.values.append(1.5)
    t.values.append(2.0)
    var tb = encode(t)
    var tb2 = decode[Telemetry](tb)
    if len(tb2.values) != 2:
        raise Error("telemetry")
    print("test_benchmark_v2 ok")
