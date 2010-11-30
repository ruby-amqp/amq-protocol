# -*- coding: utf-8 -*-

def genSingleEncode(spec, cValue, unresolved_domain):
    buffer = []
    type = spec.resolveDomain(unresolved_domain)
    if type == 'shortstr':
        buffer.append("pieces << [%s.length].pack('B')" % (cValue,))
        buffer.append("pieces << %s" % (cValue,))
    elif type == 'longstr':
        buffer.append("pieces << [%s.length].pack('>I')" % (cValue,))
        buffer.append("pieces << %s" % (cValue,))
    elif type == 'octet':
        buffer.append("pieces << [%s].pack('B')" % (cValue,))
    elif type == 'short':
        buffer.append("pieces << [%s].pack('>H')" % (cValue,))
    elif type == 'long':
        buffer.append("pieces << [%s].pack('>I')" % (cValue,))
    elif type == 'longlong':
        buffer.append("pieces << [%s].pack('>Q')" % (cValue,))
    elif type == 'timestamp':
        buffer.append("pieces << [%s].pack('>Q')" % (cValue,))
    elif type == 'bit':
        raise "Can't encode bit in genSingleEncode"
    elif type == 'table':
        buffer.append("self.encode_table(pieces, %s) # TODO" % (cValue,))
    else:
        raise "Illegal domain in genSingleEncode", type

    return buffer


def genEncodeMethodDefinition(spec, m):
    def finishBits():
        if bit_index is not None:
            return "pieces << [bit_buffer].pack('B')"

    bit_index = None
    buffer = []

    for f in m.arguments:
        if spec.resolveDomain(f.domain) == 'bit':
            if bit_index is None:
                bit_index = 0
                buffer.append("bit_buffer = 0")
            if bit_index >= 8:
                finishBits()
                buffer.append("bit_buffer = 0")
                bit_index = 0
            buffer.append("bit_buffer = bit_buffer | (1 << %d) if %s" % (bit_index, f.ruby_name))
            bit_index = bit_index + 1
        else:
            finishBits()
            bit_index = None
            buffer += genSingleEncode(spec, f.ruby_name, f.domain)

    finishBits()
    return buffer
